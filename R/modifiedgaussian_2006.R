#' Modified gaussian function for TPC
#'
#' @param temp temperature in degrees centigrade
#' @param rmax maximum rate at optimum temperature
#' @param topt optimum temperature
#' @param a related to full curve width
#' @param b allows for asymmetry in the curve fit
#' @author Daniel Padfield
#' @export modifiedgaussian_2006

modifiedgaussian_2006 <- function(temp, rmax, topt, a, b){
  est <- rmax * exp(-0.5 * (abs(temp - topt)/a)^b)
  return(est)
}
