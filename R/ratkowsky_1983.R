#' Ratkowsky model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param tmin low temperature (ºC) at which rates become negative
#' @param tmax high temperature (ºC) at which rates become negative
#' @param a parameter defined as sqrt(rate)/(temp - tmin)
#' @param b empirical parameter needed to fit the data for temperatures beyond the optimum temperature
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
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
#' # load in ggplot
#' library(ggplot2)
#'
#' # subset for the first TPC curve
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'ratkowsky_1983')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~ratkowsky_1983(temp = temp, tmin, tmax, a, b),
#' data = d,
#' iter = c(4,4,4,4),
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'ratkowsky_1983'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'ratkowsky_1983'),
#' supp_errors = 'Y',
#' convergence_count = FALSE)
#'
#' # look at model fit
#' summary(mod)
#'
#' # get predictions
#' preds <- data.frame(temp = seq(min(d$temp), max(d$temp), length.out = 100))
#' preds <- broom::augment(mod, newdata = preds)
#'
#' # plot
#' ggplot(preds) +
#' geom_point(aes(temp, rate), d) +
#' geom_line(aes(temp, .fitted), col = 'blue') +
#' theme_bw()
#'
#' @export ratkowsky_1983

ratkowsky_1983 <- function(temp, tmin, tmax, a, b){
  est <- ((a * (temp - tmin)) * (1 - exp(b * (temp - tmax))))^2
  return(est)
}
