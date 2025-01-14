#' Simplified Extended Brière model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param tmin low temperature (ºC) at which rates become negative
#' @param tmax high temperature (ºC) at which rates become negative
#' @param a scale parameter to adjust maximum rate of the curve
#' @param b shape parameter to adjust the asymmetry of the curve
#' @param d shape parameter to adjust the asymmetry of the curve
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @references Cruz-Loya, M. et al. Antibiotics shift the temperature response curve of Escherichia coli growth. mSystems 6, e00228–21 (2021).
#' @details Equation:
#' \deqn{rate=a \cdot (temp - t_{min})^b \cdot (t_{max} - temp)^d}{%
#' rate = a.(temp - tmin)^b.(tmax - temp)^d}
#'
#' Start values in \code{get_start_vals} are derived from the data or sensible values from the literature.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are derived from the data or based extreme values that are unlikely to occur in ecological settings.
#' @note Generally we found this model easy to fit.
#' @concept model
#' @examples
#' # load in ggplot
#' library(ggplot2)
#'
#' # subset for the first TPC curve
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'briereextendedsimplified_2021')
#' # fit model
#' mod <- nls.multstart::nls_multstart(
#'   rate~briereextendedsimplified_2021(temp = temp, tmin, tmax, a, b, d),
#'   data = d,
#'   iter = c(4,4,4,4,4),
#'   start_lower = start_vals - 10,
#'   start_upper = start_vals + 10,
#'   lower = get_lower_lims(d$temp, d$rate, model_name = 'briereextendedsimplified_2021'),
#'   upper = get_upper_lims(d$temp, d$rate, model_name = 'briereextendedsimplified_2021'),
#'   supp_errors = 'Y',
#'   convergence_count = FALSE)
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
#' @export briereextendedsimplified_2021

briereextendedsimplified_2021 <- function(temp, tmin, tmax, a, b, d){
  est <- a * (temp - tmin)^b * (tmax - temp)^(d)
  return(est)
}

briereextendedsimplified_2021.starting_vals <- function(d){
  tmin = min(d$x, na.rm = TRUE)
  tmax = max(d$x, na.rm = TRUE)
  b = 3
  a = 2 * 10^-4
  d = 1.5
  return(c(tmin = tmin, tmax = tmax, a = a, b = b, d = d))
}

briereextendedsimplified_2021.lower_lims <- function(d){
  tmin = -50
  tmax = min(d$x, na.rm = TRUE)
  b = 0
  a = 0
  d = 0
  return(c(tmin = tmin, tmax = tmax, a = a, b = b, d = d))
}

briereextendedsimplified_2021.upper_lims <- function(d){
  tmin = max(d$x, na.rm = TRUE)
  tmax = max(d$x, na.rm = TRUE) * 10
  b = 30
  # FW: Unhappy with restrictive upper limits.
  a = Inf
  d = Inf
  return(c(tmin = tmin, tmax = tmax, a = a, b = b, d = d))
}
