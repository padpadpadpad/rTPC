#' Beta model for TPC
#'
#' @param temp temperature in degrees centigrade
#' @param a dimensionless parameter
#' @param b dimensionless parameter
#' @param c dimensionless parameter
#' @param d dimensionless parameter
#' @param e dimensionless parameter
#' @author Daniel Padfield
#' @references
#'
#' Niehaus, Amanda C., et al. "Predicting the physiological performance of ectotherms in fluctuating thermal environments." Journal of Experimental Biology 215.4 (2012): 694-701.
#'
#' @export beta_2012

beta_2012 <- function(temp, a, b, c, d, e){
  est <- (a*((temp - b + ((c*(d-1))/(d + e - 2)))/c)^(d-1) * (1 - ((temp - b + ((c*(d-1))/(d + e - 2)))/c))^(e-1)) / (((d-1)/(d + e - 2))^(d-1) * ((e-1)/(d + e - 2))^(e-1))
  return(est)
}
