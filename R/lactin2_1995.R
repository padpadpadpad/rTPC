#' Lactin2 model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param a constant that determines the steepness of the rising portion of the curve
#' @param b constant that determines the height of the overall curve
#' @param tmax the temperature at which the curve begins to decelerate beyond the optimum (ºC)
#' @param delta_t thermal safety margin (ºC)
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @references Lactin, D.J., Holliday, N.J., Johnson, D.L. & Craigen, R. Improved rate models of temperature-dependent development by arthropods. Environmental Entomology 24, 69-75 (1995)
#' @details Equation:
#' \deqn{rate= = exp^{a \cdot temp} - exp^{a \cdot t_{max} - \bigg(\frac{t_{max} - temp}{\delta _{t}}\bigg)} + b}{%
#' rate =  exp(a.temp) - exp(a.tmax - ((tmax - temp) / delta_t)) + b}
#'
#' Start values in \code{get_start_vals} are derived from the data or sensible values from the literature.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are derived from the data or based extreme values that are unlikely to occur in ecological settings.
#'
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
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'lactin2_1995')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~lactin2_1995(temp = temp, a, b, tmax, delta_t),
#' data = d,
#' iter = c(3,3,3,3),
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'lactin2_1995'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'lactin2_1995'),
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
#' @export lactin2_1995

lactin2_1995 <- function(temp, a, b, tmax, delta_t){
  est <- exp(a*temp) - exp(a*tmax - ((tmax - temp) / delta_t)) + b
  return(est)
}

lactin2_1995.starting_vals <- function(d){
  tmax = max(d$x, na.rm = TRUE)
  delta_t = mean(tmax - d$x[d$y == max(d$y, na.rm = TRUE)])
  a = 0.1194843
  b = -0.254008

  return(c(a = a, b = b, tmax = tmax, delta_t = delta_t))
}

lactin2_1995.lower_lims <- function(d){
  tmax = min(d$x, na.rm = TRUE)
  delta_t = 0
  a = 0
  b = -10

  return(c(a = a, b = b, tmax = tmax, delta_t = delta_t))
}

lactin2_1995.upper_lims <- function(d){
  tmax = max(d$x, na.rm = TRUE) *10
  delta_t = (tmax - mean(d$x[d$y == max(d$y, na.rm = TRUE)])) *10
  a = 5
  b = 5

  return(c(a = a, b = b, tmax = tmax, delta_t = delta_t))
}
