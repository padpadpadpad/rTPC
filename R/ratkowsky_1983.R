#' Ratkowsky 1983 model
#'
#' @param temp temperature in degrees centigrade
#' @param tmin low temperature at which rates become negative
#' @param tmax high temperature at which rates become negative
#' @param a parameter defined as sqrt(rate)/(temp - tmin)
#' @param b empirical parameter needed to fit the data for temperature above topt
#' @author Daniel Padfield
#' @references Ratkowsky, D.A., Lowry, R.K., McMeekin, T.A., Stokes, A.N., Chandler, R.E., Model for bacterial growth rate throughout the entire biokinetic temperature range. J. Bacteriol. 154: 1222–1226 (1983)
#'
#' @export ratkowsky_1983

ratkowsky_1983 <- function(temp, tmin, tmax, a, b){
  est <- ((a * (temp - tmin)) * (1 - exp(b * (temp - tmax))))^2
  return(est)
}
