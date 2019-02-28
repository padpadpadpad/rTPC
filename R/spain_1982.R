#' Spain function
#'
#' @param temp temperature in degrees centigrade
#' @param a constant that determines the steepness of the rising portion of the curve
#' @param b constant that determines the position of topt
#' @param c constant that determines the steepness of the decreasing part of the curve
#' @param r0 the apparent rate at 0 ºC
#' @author Daniel Padfield
#' @references BASIC Microcomputer Models in Biology. Addison-Wesley, Reading, MA. 1982
#'
#' @export spain_1982

spain_1982 <- function(temp, a, b, c, r0){
  est = r0 * exp(a*temp) * (1 - b*exp(c*temp))
  return(est)
}
