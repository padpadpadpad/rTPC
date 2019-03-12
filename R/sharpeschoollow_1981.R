#' Sharpe Schoolfield Model for low temperature inactivation
#'
#'
#' @param temp_k temperature in degrees Kelvin
#' @param r_tref rate at the standardised temperature, tref
#' @param e activation energy (eV)
#' @param el low temperature de-activation energy (eV)
#' @param tl temperature at which enzyme is 1/2 active and 1/2 suppressed due to low temperatures
#' @param tref standardisation temperature in degrees centigrade. Temperature at which rates are not inactivated due to low temperature
#' @author Daniel Padfield
#' @references Schoolfield, R. M., Sharpe, P. J. & Magnuson, C. E. Non-linear regression of biological temperature-dependent rate models based on absolute reaction-rate theory. J. Theor. Biol. 88, 719-731 (1981)
#'
#' @export sharpeschoollow_1981

sharpeschoollow_1981 <- function(temp_k, r_tref, e, el, tl, tref){
  tref <- 273.15 + tref
  k <- 8.62e-05
  boltzmann.term <- r_tref*exp(e/k * (1/tref - 1/temp_k))
  inactivation.term <- 1/(1 + exp(-el/k * (1/tl - 1/temp_k)))
  return(boltzmann.term * inactivation.term)
}

