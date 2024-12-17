#' Boatman model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param rmax the rate at optimum temperature
#' @param tmin low temperature (ºC) at which rates become negative
#' @param tmax high temperature (ºC) at which rates become negative
#' @param a shape parameter to adjust the skewness of the curve
#' @param b shape  parameter to adjust the kurtosis of the curve
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @references Boatman, T. G., Lawson, T., & Geider, R. J. A key marine diazotroph in a changing ocean: The interacting effects of temperature, CO2 and light on the growth of Trichodesmium erythraeum IMS101. PLoS ONE, 12, e0168796 (2017)
#' @details Equation:
#' \deqn{rate= r_{max} \cdot \left(sin\bigg(\pi\left(\frac{temp-t_{min}}{t_{max} - t_{min}}\right)^{a}\bigg)\right)^{b}}{%
#' rate = rmax.(sin(pi.((temp - tmin)/(tmax - tmin))^a))^b}
#'
#' Start values in \code{get_start_vals} are derived from the data or sensible values from the literature.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are derived from the data or based extreme values that are unlikely to occur in ecological settings.
#'
#' @note Generally we found this model easy to fit.
#'
#' @examples
#' # load in ggplot
#' library(ggplot2)
#'
#' # subset for the first TPC curve
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'boatman_2017')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~boatman_2017(temp = temp, rmax, tmin, tmax, a, b),
#' data = d,
#' iter = c(4,4,4,4,4),
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'boatman_2017'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'boatman_2017'),
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
#' @export boatman_2017

boatman_2017 <- function(temp, rmax, tmin, tmax, a, b){
  est <- rmax * (sin(pi * ((temp - tmin)/(tmax - tmin))^a))^b
  return(est)
}

boatman_2017.starting_vals <- function(d){
  rmax = max(d$y, na.rm = TRUE)
  tmin = min(d$x, na.rm = TRUE)
  tmax = max(d$x, na.rm = TRUE)
  a = 1.1
  b = 0.4
  return(c(rmax = rmax, tmin = tmin, tmax = tmax, a = a, b = b))
}

boatman_2017.lower_lims <- function(d){
  rmax = min(d$y, na.rm = TRUE)
  tmin = -50
  tmax = min(d$x, na.rm = TRUE)
  a = 0
  b = 0
  return(c(rmax = rmax, tmin = tmin, tmax = tmax, a = a, b = b))
}

boatman_2017.upper_lims <- function(d){
  rmax = max(d$y, na.rm = TRUE) * 10
  tmin = max(d$x, na.rm = TRUE)
  tmax = max(d$x, na.rm = TRUE) * 10
  a = 50
  b = 10
  return(c(rmax = rmax, tmin = tmin, tmax = tmax, a = a, b = b))
}
