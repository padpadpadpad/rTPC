#' Kamykowski 1985 function
#'
#' @param temp temperature in degrees centigrade
#' @param tmin low temperature at which rates become negative
#' @param tmax high temperature at which rates become negative
#' @param a parameter with no biological meaning
#' @param b parameter with no biological meaning
#' @param c parameter with no biological meaning
#' @author Daniel Padfield
#' @references Kamykowski, Daniel. "A survey of protozoan laboratory temperature studies applied to marine dinoflagellate behavior from a field perspective." Contributions in Marine Science. 1985. (1985).
#'
#' @export kamykowski_1985

kamykowski_1985 <- function(temp, tmin, tmax, a, b, c) {
  est <- a * (1 - exp(-b * (temp - tmin))) * (1 - exp(-c * (tmax - temp)))
  return(est)
}
