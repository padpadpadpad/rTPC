#' Estimate extra parameters
#'
#' @description Estimates extra parameters that are commonly calculated from TPCs
#' @param model nls model object that contains a model of a thermal performance curve
#' @author Daniel Padfield
#' @details Currently calculates maximum rate (rmax) and optimum temperature (topt). If it cannot be calculated will return NA
#'
#' @export est_params

est_params <- function(model){
  t <- data.frame(rmax = tryCatch(rTPC::get_rmax(model), error = function(err) NA),
                  topt = tryCatch(rTPC::get_topt(model), error = function(err) NA),
                  ctmin = tryCatch(rTPC::get_ctmin(model), error = function(err) NA),
                  stringsAsFactors = FALSE)
  return(t)
}
