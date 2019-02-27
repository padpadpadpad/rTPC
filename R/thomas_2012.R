#' Thomas (2012) model for TPC
#'
#' @param temp temperature in degrees centigrade
#' @param a arbitrary constant
#' @param b arbitrary constant
#' @param c the range of temperatures over which growth rate is positive, or the thermal niche width (ºC)
#' @param topt determines the location of the maximum of the quadratic portion of this function. When b = 0, tref would equal topt
#' @author Daniel Padfield
#' @references
#'
#' Thomas, Mridul K., et al. A global pattern of thermal adaptation in marine phytoplankton. Science 338.6110, 1085-1088 (2012)
#'
#' @export thomas_2012

thomas_2012 <- function(temp, a, b, c, topt){
  est <-  a * exp(b * temp) * (1 - ((temp - topt)/(c/2))^2)
  return(est)
}

