#' Estimate extra parameters of a thermal performance curve
#'
#' @param model nls model object that contains a model of a thermal performance curve
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
#' * skewness using [get_skewness()]
#'
#' If any parameters cannot be calculated for a thermal performance curve, they will return \code{NA}.
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
                  tolerance_range = tryCatch(rTPC::get_thermaltolerance(model), error = function(err) NA),
                  skewness = tryCatch(rTPC::get_skewness(model), error = function(err) NA),
                  stringsAsFactors = FALSE)

  return(t)
}
