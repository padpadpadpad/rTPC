#' Ratkowsky 1983 model
#'
#' @param temp temperature in degrees centigrade
#' @param tmin low temperature at which rates become negative
#' @param tmax high temperature at which rates become negative
#' @param a parameter defined as sqrt(rate)/(temp - tmin)
#' @param b empirical parameter needed to fit the data for temperature above topt
#' @author Daniel Padfield
#' @references Ratkowsky, D.A., Lowry, R.K., McMeekin, T.A., Stokes, A.N., Chandler, R.E., Model for bacterial growth rate throughout the entire biokinetic temperature range. J. Bacteriol. 154: 1222–1226 (1983)
#' @examples
#' # load in data
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#' 
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'ratowsky_1983')
#' mod <- minpack.lm::nlsLM(rate~ratowsky_1983(temp = temp, tmin, tmax, a, b),
#' data = d,
#' start = start_vals,
#' control = minpack.lm::nls.lm.control(maxiter = 100))
#'
#' # look at model
#' summary(mod)
#' est_params(mod)
#' @export ratkowsky_1983

ratkowsky_1983 <- function(temp, tmin, tmax, a, b){
  est <- ((a * (temp - tmin)) * (1 - exp(b * (temp - tmax))))^2
  return(est)
}
