#' Calculate extra parameters of a thermal performance curve
#'
#' @param model nls model object that contains a model of a thermal performance curve
#' @param ... additional arguments to pass to any of the functions used to estimate the traits. For example you can change the level argument of [get_breadth()].
#' @return a dataframe containing the estimates of key TPC traits for a given model object. If any parameters cannot be calculated for a thermal performance curve, they will return \code{NA}.
#' @details Currently estimates:
#' * maximum rate (rmax) using [get_rmax()]
#' * optimum temperature (topt) using [get_topt()]
#' * critical thermal maximum (ctmax) using [get_ctmax()]
#' * critical thermal minimum (ctmin) using [get_ctmin()]
#' * activation energy (e) using [get_e()]
#' * deactivation energy (eh) using [get_eh()]
#' * q10 value using [get_q10()]
#' * thermal safety margin using [get_thermalsafetymargin()]
#' * thermal tolerance using [get_thermaltolerance()]
#' * thermal performance breadth using [get_breadth()]
#' * skewness using [get_skewness()]
#'
#' @md
#' @concept params
#' @export calc_params

calc_params <- function(model, ...){
  t <- data.frame(rmax = suppressWarnings(tryCatch(rTPC::get_rmax(model), error = function(err) NA)),
                  topt = suppressWarnings(tryCatch(rTPC::get_topt(model), error = function(err) NA)),
                  ctmin = suppressWarnings(tryCatch(rTPC::get_ctmin(model), error = function(err) NA)),
                  ctmax = suppressWarnings(tryCatch(rTPC::get_ctmax(model), error = function(err) NA)),
                  e = suppressWarnings(tryCatch(rTPC::get_e(model), error = function(err) NA)),
                  eh = suppressWarnings(tryCatch(rTPC::get_eh(model), error = function(err) NA)),
                  q10 = suppressWarnings(tryCatch(rTPC::get_q10(model), error = function(err) NA)),
                  thermal_safety_margin = suppressWarnings(tryCatch(rTPC::get_thermalsafetymargin(model), error = function(err) NA)),
                  thermal_tolerance = suppressWarnings(tryCatch(rTPC::get_thermaltolerance(model), error = function(err) NA)),
                  breadth = suppressWarnings(tryCatch(rTPC::get_breadth(model, ...), error = function(err) NA)),
                  skewness = suppressWarnings(tryCatch(rTPC::get_skewness(model), error = function(err) NA)),
                  stringsAsFactors = FALSE)

  return(t)
}
