#' Estimate optimum temperature
#'
#' @description Estimates optimum temperature from a model model of a thermal performance curve.
#' @param model nls model object that contains a model of a thermal performance curve
#' @author Daniel Padfield
#' @details Optimum temperature is calculated by predicting over the temperature range using the previously estimated parameters and subsetting for the largest rate value. Predictions are done every 0.001 temperature value so the estimate of optimum temperature should be accurate up to 0.001 ºC/K
#'
#' @export get_topt

get_topt <- function(model){

  # capture environment from model - contains data
  x <- model$m$getEnv()

  # get the name of the temperature column
  formula <- stats::as.formula(model$m$formula())
  param_ind <- all.vars(formula[[3]])[! all.vars(formula[[3]]) %in%
                                        names(model$m$getPars())]

  # extract the temperature values
  vals <- x[[param_ind]]
  newdata <- data.frame(x = seq(min(vals), max(vals), by = 0.001), stringsAsFactors = FALSE)
  # rename to be the correct column name
  names(newdata) <- param_ind

  # predict over a whole wide range of data
  newdata$preds <- stats::predict(model, newdata = newdata)
  topt = newdata[newdata$preds == max(newdata$preds),param_ind]
  return(topt)
}

