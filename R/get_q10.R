#' Estimate the q10 value of a thermal performance curve
#'
#' @param model nls model object that contains a model of a thermal performance curve
#' @details Fits the q10 portion of \code{rezende_2019} to all raw data below the optimum temperature (ºC; as estimated by \code{get_topt}).
#' @return Numeric estimate of q10 value
#' @concept params
#' @export get_q10

get_q10 <- function(model){

  # capture environment from model - contains data
  x <- model$m$getEnv()

  # get the name of the temperature column
  formula <- stats::as.formula(model$m$formula())
  param_ind <- all.vars(formula[[3]])[! all.vars(formula[[3]]) %in%
                                        names(model$m$getPars())]

  # get the name of the rate values
  params_dep <- all.vars(formula[[2]])

  # extract the temperature and rate values
  temp <- data.frame(x1 = x[[param_ind]], x2 = x[[params_dep]], stringsAsFactors = FALSE)

  # calculate topt
  topt <- rTPC::get_topt(model)

  # keep just values below topt
  temp <- temp[temp$x1 <= topt,]

  # create K column if needed
  temp$temp <- ifelse(temp$x1 > 150, temp$x1 - 273.15, temp$x1)

  # run model
  mod <- stats::nls(x2 ~ a*10^(log10(q10)/(10/temp)), start = c(a = 0.0577, q10 = 2.77), temp, na.action = stats::na.omit)
  q10 = unname(stats::coef(mod)[2])

  return(q10)
}
