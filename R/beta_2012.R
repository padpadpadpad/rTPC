#' Beta model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param a dimensionless parameter
#' @param b dimensionless parameter
#' @param c dimensionless parameter
#' @param d dimensionless parameter
#' @param e dimensionless parameter
#' @author Daniel Padfield
#' @references Niehaus, Amanda C., et al. Predicting the physiological performance of ectotherms in fluctuating thermal environments. Journal of Experimental Biology 215.4: 694-701 (2012)
#' @details Equation:
#' \deqn{rate=\frac{a\left(\frac{temp-b+\frac{c(d-1)}{d+e-2}}{c}\right)^{d-1}  \cdot \left(1-\frac{temp-b+\frac{c(d-1)}{d+e-2}}{c}\right)^{e-1}}{{\left(\frac{d-1}{d+e-2}\right)}^{d-1}\cdot \left(\frac{e-1}{d+e-2}\right)^{e-1}}}{%
#' rate = (a.((temp - b + ((c.(d-1))/(d + e - 2)))/c)^(d-1).(1 - ((temp - b + ((c.(d-1))/(d + e - 2)))/c))^(e-1)) / (((d-1)/(d + e - 2))^(d-1).((e-1)/(d + e - 2))^(e-1))}
#'
#' Start values in \code{get_start_vals} are derived from the data or sensible values from the literature.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are derived from the data or based extreme values that are unlikely to occur in ecological settings.
#'
#' @note Generally we found this model difficult to fit.
#' @examples
#' \donttest{
#' # load in ggplot
#' library(ggplot2)
#'
#' # subset for the first TPC curve
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'beta_2012')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~beta_2012(temp = temp, a, b, c, d, e),
#'                                  data = d,
#'                                  iter = c(7,7,7,7,7),
#'                                  start_lower = start_vals - 10,
#'                                  start_upper = start_vals + 10,
#'                                  lower = get_lower_lims(d$temp, d$rate, model_name = 'beta_2012'),
#'                                  upper = get_upper_lims(d$temp, d$rate, model_name = 'beta_2012'),
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
#' }
#' @export beta_2012

beta_2012 <- function(temp, a, b, c, d, e){
  part1 <- a*((temp - b + ((c*(d-1))/(d + e - 2)))/c)^(d-1)
  part2 <- (1 - ((temp - b + ((c*(d-1))/(d + e - 2)))/c))^(e-1)
  part3 <- ((d-1)/(d + e - 2))^(d-1)
  part4 <- ((e-1)/(d + e - 2))^(e-1)

  temp <- part1 * part2
  temp2 <- part3 * part4
  return(temp/temp2)

}
