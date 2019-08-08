#' Estimate extra parameters
#'
#' @description Estimates extra parameters that are commonly calculated from TPCs
#' @param model nls model object that contains a model of a thermal performance curve
#' @author Daniel Padfield
#' @details Currently calculates maximum rate (rmax), optimum temperature (topt), critical thermal maximum (ctmax) and minimum (ctmin), thermal tolerance, thermal safety margin and the skewness of the curve. If any parameters cannot be calculated they will return NA.
#'
#' @export est_params

est_params <- function(model){
  t <- data.frame(rmax = tryCatch(rTPC::get_rmax(model), error = function(err) NA),
                  topt = tryCatch(rTPC::get_topt(model), error = function(err) NA),
                  ctmin = tryCatch(rTPC::get_ctmin(model), error = function(err) NA),
                  ctmax = tryCatch(rTPC::get_ctmax(model), error = function(err) NA),
                  e = tryCatch(rTPC::get_e(model), error = function(err) NA),
                  stringsAsFactors = FALSE)
  t$thermal_safety_margin <- t$ctmax - t$topt
  t$tolerance_range <- t$ctmax - t$ctmin
  t$skewness <- tryCatch(rTPC::get_skewness(model), error = function(err) NA)

  return(t)
}
