#' Weibull model
#'
#'
#' @param temp temperature in degrees centigrade
#' @param a scale the height of the curve
#' @param topt optimum temperature
#' @param b defines the breadth of the curve
#' @param c defines the curve shape
#' @author Daniel Padfield
#' @references Angilletta Jr, Michael J. "Estimating and comparing thermal performance curves." Journal of Thermal Biology 31.7 (2006): 541-545.
#'
#' @export weibull_1995

weibull_1995 <- function(temp, a, topt, b, c){
  return(a*((c-1)/c)^((1-c)/c)*((temp - topt)/b + ((c-1)/c)^(1/c))^(c-1)*exp(-1*(((temp - topt)/b) + ((c-1)/c)^(1/c))^c) + ((c-1)/c))
}


