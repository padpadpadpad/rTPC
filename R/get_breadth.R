#' Estimate thermal performance breadth of a thermal performance curve
#'
#' @param model nls model object that contains a model of a thermal performance curve
#' @param level proportion of maximum rate over which thermal performance breadth is calculated
#' @details Thermal performance breadth is calculated as the range of temperatures over which a curve's rate is at least 0.8 of peak. This defaults to a proportion of 0.8 but can be changed using the \code{level} argument.
#' @return Numeric estimate of thermal performance breadth (in ºC)
#' @concept params
#' @export get_breadth

get_breadth <- function(model, level = 0.8){

  # capture environment from model - contains data
  x <- model$m$getEnv()

  # get the name of the temperature column
  formula <- stats::as.formula(model$m$formula())
  param_ind <- all.vars(formula[[3]])[! all.vars(formula[[3]]) %in%
                                        names(model$m$getPars())]

  # extract the temperature values
  vals <- x[[param_ind]]

  # new datasets - one for extrapolation and one without
  newdata_extrap <- data.frame(x = seq(min(vals), max(vals), by = 0.001), stringsAsFactors = FALSE)
  newdata <- data.frame(x = seq(min(vals), max(vals), by = 1), stringsAsFactors = FALSE)

  # rename to be the correct column name
  names(newdata) <- param_ind
  names(newdata_extrap) <- param_ind

  # predict over a whole wide range of data - both extrap and non-extrap
  newdata$preds <- stats::predict(model, newdata = newdata)
  newdata_extrap$preds <- stats::predict(model, newdata = newdata_extrap)

  # remove NaNs
  newdata_extrap <- newdata_extrap[!is.nan(newdata_extrap$preds),]

  # calc topt and rmax
  topt = newdata[newdata$preds == max(newdata$preds, na.rm = TRUE), param_ind]
  rmax = newdata[newdata$preds == max(newdata$preds),'preds']

  # keep just temperatures lower than topt
  newdata_extrap_low <- newdata_extrap[newdata_extrap[,param_ind] <= topt,]
  newdata_extrap_high <- newdata_extrap[newdata_extrap[,param_ind] >= topt,]

  # if it is infinite - set it to 5% of rate
  newdata_extrap_low <- newdata_extrap_low[newdata_extrap_low$preds >= (level * rmax),]
  newdata_extrap_high <- newdata_extrap_high[newdata_extrap_high$preds >= (level * rmax),]
  low_val <- suppressWarnings(min(newdata_extrap_low[,param_ind]))
  high_val <- suppressWarnings(max(newdata_extrap_high[,param_ind]))

  return(high_val - low_val)
}
