#' Briere2 function
#'
#' @param temp temperature in degrees centigrade
#' @param tmin low temperature at which rates become negative
#' @param tmax high temperature at which rates become negative
#' @param a scale parameter to adjust maximum rate of the curve
#' @param b shape parameter to adjust the asymmetry of the curve
#' @author Daniel Padfield
#' @references Brière, J.F., Pracros, P., Le Roux, A.Y., Pierre, J.S.,  A novel rate model of temperature-dependent development for arthro- pods. Environ. Entomol. 28, 22–29 (1999)
#'
#' @export briere2_1999

briere2_1999 <- function(temp, tmin, tmax, a, b){
  est <- a*temp * (temp - tmin) * (tmax - temp)^(1/b)
  return(est)
}

