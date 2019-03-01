#' Gaussian function for TPC
#'
#' @param temp temperature in degrees centigrade
#' @param rmax maximum rate at optimum temperature
#' @param topt optimum temperature
#' @param a related to full curve width
#' @author Daniel Padfield
#' @references
#'
#' Lynch, M., Gabriel, W., 1987. Environmental tolerance. Am. Nat. 129, 283–303.
#'
#' @export gaussian_1987

gaussian_1987 <- function(temp, rmax, topt, a){
  est <- rmax * exp(-0.5 * ((temp - topt)/a)^2)
  return(est)
}
