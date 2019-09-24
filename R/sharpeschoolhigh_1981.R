#' Sharpe Schoolfield Model for high temperature inactivation
#'
#'
#' @param (temp + 273.15) temperature in degrees centigrade
#' @param r_tref rate at the standardised temperature, tref
#' @param e activation energy (eV)
#' @param eh high temperature de-activation energy (eV)
#' @param th temperature at which enzyme is 1/2 active and 1/2 suppressed due to high temperatures
#' @param tref standardisation temperature in degrees centigrade
#' @author Daniel Padfield
#' @references Schoolfield, R. M., Sharpe, P. J. & Magnuson, C. E. Non-linear regression of biological temperature-dependent rate models based on absolute reaction-rate theory. J. Theor. Biol. 88, 719-731 (1981)
#'
#' @export sharpeschoolhigh_1981

sharpeschoolhigh_1981 <- function(temp, r_tref, e, eh, th, tref){
  tref <- 273.15 + tref
  k <- 8.62e-05
  boltzmann.term <- r_tref*exp(e/k * (1/tref - 1/(temp + 273.15)))
  inactivation.term <- 1/(1 + exp(eh/k * (1/(th + 273.15) - 1/(temp + 273.15))))
  return(boltzmann.term * inactivation.term)
}

