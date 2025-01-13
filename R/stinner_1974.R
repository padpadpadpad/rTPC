#' Stinner model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param rmax the maximum rate
#' @param topt optimum temperature (ºC) at which rates are maximal
#' @param a dimensionless parameter
#' @param b dimensionless parameter
#' @author Daniel Padfield
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @references Stinner, R. E., Gutierrez, A. P., & Butler Jr, G. D. (1974). An algorithm for temperature-dependent growth rate simulation12. The Canadian Entomologist, 106(5), 519-524.
#' @details Equation:
#' \deqn{\textrm{if} \quad temp <= t_{opt}: rate = rmax \cdot \frac{1 + exp^{a + b \cdot t_{opt}}}{(1 + exp^{a + b \cdot temp}}}{%
#' rate = rmax.(1 + exp(a + b.topt))/(1 + exp(a + b.temp)}
#' \deqn{\textrm{if} \quad temp <= t_{opt}: rate = rmax \cdot \frac{1 + exp^{a + b \cdot t_{opt}}}{(1 + exp^{a + b \cdot (2 \cdot t_{opt} - temp)}}}{%
#' rate = rmax.(1 + exp(a + b.topt))/(1 + exp( a + b.(2.topt - temp)))}
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
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'stinner_1974')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~stinner_1974(temp = temp, rmax, topt, a, b),
#' data = d,
#' iter = c(4,4,4,4),
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'stinner_1974'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'stinner_1974'),
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
#' @export stinner_1974

stinner_1974 <- function(temp, rmax, topt, a, b){

  est <-{ifelse(temp <= topt, rmax * ((1 + exp(a + b * topt))/(1 + exp(a + b * temp))), rmax * ((1 + exp(a + b * topt))/(1 + exp(a + b * (2* topt - temp)))))}

  return(est)

}

stinner_1974.starting_vals <- function(d){
  rmax = max(d$y, na.rm = TRUE)
  topt = mean(d$x[d$y == rmax])
  a = 0.2
  b = 0.1

  return(c(rmax = rmax, topt = topt, a = a, b = b))
}

stinner_1974.lower_lims <- function(d){
  rmax = min(d$y, na.rm = TRUE)
  topt = min(d$x[d$y == rmax])
  a = 0
  b = 0

  return(c(rmax = rmax, topt = topt, a = a, b = b))
}

stinner_1974.upper_lims <- function(d){
  rmax = max(d$y, na.rm = TRUE) * 10
  topt = max(d$x, na.rm = TRUE) * 10
  a = Inf
  b = Inf

  return(c(rmax = rmax, topt = topt, a = a, b = b))
}
