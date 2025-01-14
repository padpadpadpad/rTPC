#' Estimate optimum temperature of a thermal performance curve
#'
#' @param model nls model object that contains a model of a thermal performance curve
#' @details Optimum temperature (ºC) is calculated by predicting over the temperature range using the previously estimated parameters and keeping the temperature where the largest rate value occurs. Predictions are done every 0.001 ºC so the estimate of optimum temperature should be accurate up to 0.001 ºC.
#' @return Numeric estimate of optimum temperature (in ºC)
#' @concept params
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
  return(mean(topt))
}

