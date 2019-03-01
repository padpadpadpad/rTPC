#' Boatman 2017 function
#'
#' @param temp temperature in degrees centigrade
#' @param rmax the rate at optimum temperature
#' @param tmin low temperature at which rates become negative
#' @param tmax high temperature at which rates become negative
#' @param a shape parameter to adjust the asymmetry of the skewness
#' @param b is a shape determining parameter, which alters the kurtosis
#' @author Daniel Padfield
#' @references Boatman, T. G., Lawson, T., & Geider, R. J. A key marine diazotroph in a changing ocean: The interacting effects of temperature, CO2 and light on the growth of Trichodesmium erythraeum IMS101. PLoS ONE, 12, e0168796 (2017)
#'
#' @export boatman_2017

boatman_2017 <- function(temp, rmax, tmin, tmax, a, b){
  est <- rmax * (sin(pi * ((temp - tmin)/(tmax - tmin))^a))^b
  return(est)
}

