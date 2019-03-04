#' Quadratic model
#'
#' @param temp temperature in degrees centigrade
#' @param a parameter that defines the rate at 0 ºC
#' @param b parameter with no biological meaning
#' @param c parameter with no biological meaning
#' @author Daniel Padfield
#' @references Montagnes, David JS, et al. "Short‐term temperature change may impact freshwater carbon flux: a microbial perspective." Global Change Biology 14.12: 2823-2838. (2008)
#'
#' @export quadratic_2008

quadratic_2008 <- function(temp, a, b, c) {
  est <- a + b * temp + c * temp^2
  return(est)
}

