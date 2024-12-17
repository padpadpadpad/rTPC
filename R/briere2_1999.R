#' Briere2 model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param tmin low temperature (ºC) at which rates become negative
#' @param tmax high temperature (ºC) at which rates become negative
#' @param a scale parameter to adjust maximum rate of the curve
#' @param b shape parameter to adjust the asymmetry of the curve
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @references Brière, J.F., Pracros, P., Le Roux, A.Y., Pierre, J.S.,  A novel rate model of temperature-dependent development for arthropods. Environmental Entomololgy, 28, 22–29 (1999)
#' @details Equation:
#' \deqn{rate=a\cdot temp \cdot(temp - t_{min}) \cdot (t_{max} - temp)^{\frac{1}{b}}}{%
#' rate = a.temp.(temp - tmin).(tmax - temp)^(1/b)}
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
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'briere2_1999')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~briere2_1999(temp = temp, tmin, tmax, a, b),
#' data = d,
#' iter = c(4,4,4,4),
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'briere2_1999'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'briere2_1999'),
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
#' @export briere2_1999

briere2_1999 <- function(temp, tmin, tmax, a, b){
  est <- a*temp * (temp - tmin) * (tmax - temp)^(1/b)
  return(est)
}

briere2_1999.starting_vals <- function(d){
  tmin = min(d$x, na.rm = TRUE)
  tmax = max(d$x, na.rm = TRUE)
  b = 3
  a = 2 * 10^-4
  return(c(tmin = tmin, tmax = tmax, a = a, b = b))
}

briere2_1999.lower_lims <- function(d){
  tmin = -50
  tmax = min(d$x, na.rm = TRUE)
  b = 0
  a = 0
  return(c(tmin = tmin, tmax = tmax, a = a, b = b))
}

briere2_1999.upper_lims <- function(d){
  tmin = max(d$x, na.rm = TRUE)
  tmax = max(d$x, na.rm = TRUE) * 10
  b = 30
  a = 10^-2
  return(c(tmin = tmin, tmax = tmax, a = a, b = b))
}
