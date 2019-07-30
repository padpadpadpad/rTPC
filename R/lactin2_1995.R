#' Lactin2 function
#'
#' @param temp temperature in degrees centigrade
#' @param p constant that determines the steepness of the rising portion of the curve
#' @param c constant that determines the height of the overall curve
#' @param tmax changes the temperature at which the curve begins to decelerate beyond the optimum
#' @param delta_t thermal safety margin
#' @author Daniel Padfield
#' @references Lactin, D.J., Holliday, N.J., Johnson, D.L. & Craigen, R. Improved rate models of temperature-dependent development by arthropods. Environ. Entomol. 24, 69-75 (1995)
#'
#' @export lactin2_1995

lactin2_1995 <- function(temp, p, c, tmax, delta_t){
  est <- exp(p*temp) - exp(p*tmax - ((tmax - temp) / delta_t)) + c
  return(est)
}

