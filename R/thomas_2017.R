#' Thomas model (2017) for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param a birth rate at 0 ºC
#' @param b describes the exponential increase in birth rate with increasing temperature
#' @param c temperature-independent mortality term
#' @param d along with e controls the exponential increase in mortality rates with temperature
#' @param e along with d controls the exponential increase in mortality rates with temperature
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @references Thomas, Mridul K., et al. Temperature–nutrient interactions exacerbate sensitivity to warming in phytoplankton. Global change biology 23.8 (2017): 3269-3280.
#' @details Equation:
#' \deqn{rate = a \cdot exp^{b \cdot temp} - (c + d \cdot exp^{e \cdot temp})}{%
#' rate = a . exp(b . temp) - (c + d.(exp(e.temp)))}
#'
#' Start values in \code{get_start_vals} are derived from the data.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are derived from the data or based on extreme values that are unlikely to occur in ecological settings.
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
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'thomas_2017')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~thomas_2017(temp = temp, a, b, c, d, e),
#' data = d,
#' iter = c(3,3,3,3,3),
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'thomas_2017'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'thomas_2017'),
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
#' @export thomas_2017

thomas_2017 <- function(temp, a, b, c, d, e){
  return(a * exp(b * temp) - (c + d*(exp(e*temp))))
}
