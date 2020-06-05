#' Ratkowsky 1983 model
#'
#' @param temp temperature in degrees centigrade
#' @param tmin low temperature (ºC) at which rates become negative
#' @param tmax high temperature (ºC) at which rates become negative
#' @param a parameter defined as sqrt(rate)/(temp - tmin)
#' @param b empirical parameter needed to fit the data for temperatures beyond the optimum temperature
#' @details Equation:
#' \deqn{rate = (a \cdot (temp-t_{min}))^2 \cdot (1-exp(b \cdot (temp-t_{max})))^2}{%
#' rate = ((a.(temp - tmin)).(1 - exp(b.(temp - tmax))))^2}
#'
#' Start values in \code{get_start_vals} are derived from the data and previous values in the literature.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are based on extreme values that are unlikely to occur in ecological settings.
#'
#' @note Generally we found this model easy to fit.
#' @references Ratkowsky, D.A., Lowry, R.K., McMeekin, T.A., Stokes, A.N., Chandler, R.E., Model for bacterial growth rate throughout the entire biokinetic temperature range. J. Bacteriol. 154: 1222–1226 (1983)
#' @examples
#' # load in data
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'ratkowsky_1983')
#' mod <- minpack.lm::nlsLM(rate~ratkowsky_1983(temp = temp, tmin, tmax, a, b),
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
