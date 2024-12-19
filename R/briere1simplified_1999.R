#' Simplified Brière I model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param tmin low temperature (ºC) at which rates become negative
#' @param tmax high temperature (ºC) at which rates become negative
#' @param a scale parameter to adjust maximum rate of the curve
#' @author Francis Windram
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @references Brière, J.F., Pracros, P., Le Roux, A.Y., Pierre, J.S.,  A novel rate model of temperature-dependent development for arthropods. Environmental Entomololgy, 28, 22–29 (1999)
#' @details Equation:
#' \deqn{rate=a \cdot (temp - t_{min}) \cdot (t_{max} - temp)^{\frac{1}{2}}}{%
#' rate = a.(temp - tmin).(tmax - temp)^(1/2)}
#'
#' Start values in \code{get_start_vals} are derived from the data or sensible values from the literature.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are derived from the data or based extreme values that are unlikely to occur in ecological settings.
#' @note Generally we found this model easy to fit.
#' @examples
#' # load in ggplot
#' library(ggplot2)
#'
#' # subset for the first TPC curve
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'briere1simplified_1999')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~briere1simplified_1999(temp = temp, tmin, tmax, a),
#' data = d,
#' iter = c(3,3,3),
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'briere1simplified_1999'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'briere1simplified_1999'),
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
#' @export briere1simplified_1999

briere1simplified_1999 <- function(temp, tmin, tmax, a){
  est <- a* (temp - tmin) * (tmax - temp)^(1/2)
  return(est)
}

briere1simplified_1999.starting_vals <- function(d){
  tmin = min(d$x, na.rm = TRUE)
  tmax = max(d$x, na.rm = TRUE)
  a = 2 * 10^-4
  return(c(tmin = tmin, tmax = tmax, a = a))
}

briere1simplified_1999.lower_lims <- function(d){
  tmin = -50
  tmax = min(d$x, na.rm = TRUE)
  a = 0
  return(c(tmin = tmin, tmax = tmax, a = a))
}

briere1simplified_1999.upper_lims <- function(d){
  tmin = max(d$x, na.rm = TRUE)
  tmax = max(d$x, na.rm = TRUE) * 10
  a = Inf
  return(c(tmin = tmin, tmax = tmax, a = a))
}
