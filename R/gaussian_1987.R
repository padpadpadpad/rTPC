#' Gaussian model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param rmax maximum rate at optimum temperature
#' @param topt optimum temperature (ºC)
#' @param a related to the full curve width
#' @references Lynch, M., Gabriel, W., Environmental tolerance. The American Naturalist. 129, 283–303. (1987)
#' @details Equation:
#' \deqn{rate = r_{max} \cdot exp^{\bigg(-0.5 \left(\frac{|temp-t_{opt}|}{a}\right)^2\bigg)}}{%
#' rate = rmax.exp(-0.5.(abs(temp - topt)/a)^2)}
#'
#' Start values in \code{get_start_vals} are derived from the data
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are based on extreme values that are unlikely to occur in ecological settings.
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
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'gaussian_1987')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~gaussian_1987(temp = temp,rmax, topt,a),
#'                                  data = d,
#'                                  iter = c(4,4,4),
#'                                  start_lower = start_vals - 10,
#'                                  start_upper = start_vals + 10,
#'                                  lower = get_lower_lims(d$temp, d$rate, model_name = 'gaussian_1987'),
#'                                  upper = get_upper_lims(d$temp, d$rate, model_name = 'gaussian_1987'),
#'                                  supp_errors = 'Y',
#'                                  convergence_count = FALSE)
#'
#' # look at model fit
#' summary(mod)
#'
#' # get predictions
#' preds <- tibble(temp = seq(min(d$temp), max(d$temp), length.out = 100))
#' preds <- broom::augment(mod, newdata = preds)
#'
#' # plot
#' ggplot(preds) +
#' geom_point(aes(temp, rate), d) +
#' geom_line(aes(temp, .fitted), col = 'blue') +
#' theme_bw()
#'
#' @export gaussian_1987

gaussian_1987 <- function(temp, rmax, topt, a){
  est <- rmax * exp(-0.5 * (abs(temp - topt)/a)^2)
  return(est)
}
