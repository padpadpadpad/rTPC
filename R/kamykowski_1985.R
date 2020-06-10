#' Kamykowski model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param tmin low temperature (ºC) at which rates become negative
#' @param tmax high temperature (ºC) at which rates become negative
#' @param a parameter with no biological meaning
#' @param b parameter with no biological meaning
#' @param c parameter with no biological meaning
#' @details Equation:
#' \deqn{rate= a \cdot \big( 1 - exp^{-b\cdot \big(temp-t_{min}\big)}\big) \cdot \big( 1-exp^{-c \cdot \big(t_{max}-temp\big)}\big)}{%
#' rate =  a.(1 - exp(-b.(temp - tmin))).(1 - exp(-c.(tmax - temp)))}
#'
#' Start values in \code{get_start_vals} are derived from the data or sensible values from the literature.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are derived from the data or based extreme values that are unlikely to occur in ecological settings.
#'
#' @note Generally we found this model easy to fit.
#'
#' @references Kamykowski, Daniel. A survey of protozoan laboratory temperature studies applied to marine dinoflagellate behaviour from a field perspective. Contributions in Marine Science. (1985).
#' @examples
#' # load in ggplot
#' library(ggplot2)
#'
#' # subset for the first TPC curve
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'kamykowski_1985')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~kamykowski_1985(temp = temp, tmin, tmax, a, b, c),
#' data = d,
#' iter = c(3,3,3,3,3),
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'kamykowski_1985'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'kamykowski_1985'),
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
#' @export kamykowski_1985

kamykowski_1985 <- function(temp, tmin, tmax, a, b, c) {
  est <- a * (1 - exp(-b * (temp - tmin))) * (1 - exp(-c * (tmax - temp)))
  return(est)
}
