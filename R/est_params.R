#' Estimate extra parameters of a thermal performance curve
#'
#' @param model nls model object that contains a model of a thermal performance curve
#' @details Currently estimates:
#' * maximum rate (rmax)
#' * optimum temperature (topt)
#' * critical thermal maximum (ctmax)
#' * critical thermal minimum (ctmin)
#' * activation energy (e)
#' * deactivation energy (eh)
#' * q10 value
#' * thermal safety margin
#' * thermal tolerance
#' * skewness
#'
#' If any parameters cannot be calculated for a thermal performance curve, they will return NA.
#' @md
#' @export est_params

est_params <- function(model){
  t <- data.frame(rmax = tryCatch(rTPC::get_rmax(model), error = function(err) NA),
                  topt = tryCatch(rTPC::get_topt(model), error = function(err) NA),
                  ctmin = tryCatch(rTPC::get_ctmin(model), error = function(err) NA),
                  ctmax = tryCatch(rTPC::get_ctmax(model), error = function(err) NA),
                  e = tryCatch(rTPC::get_e(model), error = function(err) NA),
                  eh = tryCatch(rTPC::get_eh(model), error = function(err) NA),
                  q10 = tryCatch(rTPC::get_q10(model), error = function(err) NA),
                  thermal_safety_margin = tryCatch(rTPC::get_thermalsafetymargin(model), error = function(err) NA),
                  tolerance_range = tryCatch(rTPC::thermaltolerance(model), error = function(err) NA),
                  skewness = tryCatch(rTPC::get_skewness(model), error = function(err) NA),
                  stringsAsFactors = FALSE)

  return(t)
}
