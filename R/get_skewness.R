#' Estimates skewness of the TPC
#'
#' @description Estimates the skewness of a thermal performance curve
#' @param model nls model object that contains a model of a thermal performance curve
#' @author Daniel Padfield
#' @details Skewness is calculated from the predictions of the model using `moments::skewness`. A negative skewness indicates the TPC is left skewed, the drop after the optimum is steeper than the rise up to the optimum. A positive skewness means that the TPC is right skewed and a value of 0 would mean the curve is symmetrical around the optimum.
#'
#' @export get_skewness

get_skewness <- function(model){

  # capture environment from model - contains data
  x <- model$m$getEnv()

  # get the name of the temperature column
  formula <- stats::as.formula(model$m$formula())
  param_ind <- all.vars(formula[[3]])[! all.vars(formula[[3]]) %in%
                                        names(model$m$getPars())]

  # extract the temperature values
  vals <- x[[param_ind]]
  newdata <- data.frame(x = seq(min(vals), max(vals), length.out = 20), stringsAsFactors = FALSE)
  # rename to be the correct column name
  names(newdata) <- param_ind

  # predict over 20 points
  newdata$preds <- stats::predict(model, newdata = newdata)

  # work out percent of total rate at that temperature
  newdata$percent <- round(newdata$preds/sum(newdata$preds)*100)
  newdata$percent <- newdata$percent+abs(min(newdata$percent))

  # replicate each temperature by its percent of total rate
  temp_vec <- rep(newdata[,param_ind], newdata$percent)

  # calculate skewness
  skewness <- moments::skewness(temp_vec)

  return(skewness)
}

