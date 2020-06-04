#' Molnar model for mortality rate
#'
#'
#' @param temp_k temperature in degrees Kelvin
#' @param r_tref rate at the standardised temperature, tref
#' @param e activation energy (eV)
#' @param el low temperature de-activation energy (eV)
#' @param tl temperature at which enzyme is 1/2 active and 1/2 suppressed due to low temperatures
#' @param eh high temperature de-activation energy (eV)
#' @param th temperature at which enzyme is 1/2 active and 1/2 suppressed due to high temperatures
#' @param tref standardisation temperature in degrees centigrade
#' @references Molnár, P. K., Kutz, S. J., Hoar, B. M., Dobson, A. P., Metabolic approaches to understanding climate change impacts on seasonal host-macroparasite dynamics. Ecology Letters. 16, 9–21 (2013)
#' @export molnar_2013

# define Molnar function
molnar_2013 <- function(temp_k, r_tref, e, el, tl, eh, th, tref){
  tref <- 273.15 + tref
  k <- 8.62e-05
  return(r_tref * (exp((-e/k) * ((1/temp_k) - (1/tref)))) * (1 + exp((el/k) * ((1/temp_k) - (1/tl))) + exp((eh/k) * ((-1/temp_k) + (1/th)))))
}
