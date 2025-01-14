#' Weibull model for fitting thermal performance curves
#'
#'
#' @param temp temperature in degrees centigrade
#' @param a scale the height of the curve
#' @param topt optimum temperature
#' @param b defines the breadth of the curve
#' @param c defines the curve shape
#' @references Angilletta Jr, Michael J. Estimating and comparing thermal performance curves. Journal of Thermal Biology 31.7 (2006): 541-545.
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @details Equation:
#' \deqn{rate = a \cdot \bigg( \frac{c-1}{c}\bigg)^{\frac{1-c}{c}}\bigg(\frac{temp-t_{opt}}{b}+\bigg(\frac{c-1}{c}\bigg)^{\frac{1}{c}}\bigg)^{c-1}exp^{-\big(\frac{temp-t_{opt}}{b}+\big( \frac{c-1}{c}\big)^{\frac{1}{c}}\big)^c} + \frac{c-1}{c}}{%
#' rate = ((a.(((c-1)/c)^((1-c)/c)).((((temp-topt)/b)+(((c-1)/c)^(1/c)))^(c-1)).(exp(-((((temp-topt)/b)+(((c-1)/c)^(1/c)))^c)+((c-1)/c)))))}
#'
#' Start values in \code{get_start_vals} are derived from the data.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are derived from the data or based  extreme values that are unlikely to occur in ecological settings.
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
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'weibull_1995')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~weibull_1995(temp = temp, a, topt, b, c),
#' data = d,
#' iter = c(4,4,4,4),
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'weibull_1995'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'weibull_1995'),
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
#' @export weibull_1995

weibull_1995 <- function(temp, a, topt, b, c){
  return((a*(((c-1)/c)^((1-c)/c))*((((temp-topt)/b)+(((c-1)/c)^(1/c)))^(c-1))*(exp(-((((temp-topt)/b)+(((c-1)/c)^(1/c)))^c)+((c-1)/c)))))
}

weibull_1995.starting_vals <- function(d){
  a = mean(d$y, na.rm = TRUE)
  topt = mean(d$x[d$y == max(d$y, na.rm = TRUE)])
  b = max(d$x, na.rm = TRUE) - min(d$x, na.rm = TRUE)
  c = 4

  return(c(a = a, topt = topt, b=b,c=c))
}

weibull_1995.lower_lims <- function(d){
  a = abs(min(d$y, na.rm = TRUE)) * -10
  topt = min(d$x, na.rm = TRUE)
  b = 0
  c = 0
  return(c(a=a, topt = topt, b=b, c=c))
}

weibull_1995.upper_lims <- function(d){
  a = Inf
  topt = max(d$x, na.rm = TRUE)
  b = Inf
  c = Inf
  return(c(a=a, topt = topt, b=b, c=c))
}
