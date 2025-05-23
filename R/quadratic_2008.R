#' Quadratic model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param a parameter that defines the rate at 0 ºC
#' @param b parameter with no biological meaning
#' @param c parameter with no biological meaning
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @references Montagnes, David JS, et al. Short‐term temperature change may impact freshwater carbon flux: a microbial perspective. Global Change Biology 14.12: 2823-2838. (2008)
#' @details Equation:
#' \deqn{rate = a + b \cdot temp + c \cdot temp^2}{%
#' rate = a + b.temp + c.temp^2}
#'
#' Start values in \code{get_start_vals} are derived from the data using previous methods in the literature
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are based on extreme values that are unlikely to occur in ecological settings.
#'
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
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'quadratic_2008')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~quadratic_2008(temp = temp, a, b, c),
#' data = d,
#' iter = c(4,4,4),
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'quadratic_2008'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'quadratic_2008'),
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
#' @export quadratic_2008

quadratic_2008 <- function(temp, a, b, c) {
  est <- a + b * temp + c * temp^2
  return(est)
}

quadratic_2008.starting_vals <- function(d){
  b = (-2*-0.005*max(d$y, na.rm = TRUE))
  a = max(d$y, na.rm = TRUE) - max(b*d$x - 0.005*(d$x^2), na.rm = TRUE)
  c = -2
  return(c(a = a, b = b, c = c))
}

quadratic_2008.lower_lims <- function(d){
  b = abs((-2*-0.005*max(d$y, na.rm = TRUE))) * - 100
  a = abs(max(d$y, na.rm = TRUE) - max(b*d$x - 0.005*(d$x^2), na.rm = TRUE)) * -100
  c = -2 * 10
  return(c(a = a, b = b, c = c))
}

quadratic_2008.upper_lims <- function(d){
  b = abs((-2*-0.005*max(d$y, na.rm = TRUE))) * 100
  a = (abs(max(d$y, na.rm = TRUE) - max(b*d$x - 0.005*(d$x^2), na.rm = TRUE))) * 100
  c = 10
  return(c(a = a, b = b, c = c))
}
