#' Thomas 2017
#'
#' @param temp temperature in degrees centigrade
#' @param a birth rate at 0 ºC
#' @param b describes the exponential increase in birth rate with increasing temperature
#' @param c temperature-independent mortality term
#' @param d along with e controls the exponential increase in mortality rates with temperature
#' @param e along with d controls the exponential increase in mortality rates with temperature
#' @author Daniel Padfield
#' @references Thomas, Mridul K., et al. "Temperature–nutrient interactions exacerbate sensitivity to warming in phytoplankton." Global change biology 23.8 (2017): 3269-3280.
#'
#' @export thomas_2017

thomas_2017 <- function(temp, a, b, c, d, e){
  return(a * exp(b * temp) - (c + d*(exp(e*temp))))
}
