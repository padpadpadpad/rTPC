#' Jöhnk model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param rmax the rate at optimum temperature
#' @param topt optimum temperatute (ºC)
#' @param a parameter with no biological meaning
#' @param b parameter with no biological meaning
#' @param c parameter with no biological meaning
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @details Equation:
#' \deqn{rate=r_{max} \bigg(1 + a \bigg(\bigg(b^{temp-t_{opt}} -1\bigg) - \frac{ln(b)}{ln(c)}(c^{temp-t_{opt}} -1)\bigg)\bigg)}{%
#' rate = rmax.(1 + a.((b^(temp - topt) - 1) - (log(b)/log(c)).(c^(temp - topt) - 1)))}
#'
#' Start values in \code{get_start_vals} are derived from the data or sensible values from the literature.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are based on extreme values that are unlikely to occur in ecological settings.
#'
#' @note Generally we found this model easy to fit.
#' @concept model
#' @references Joehnk, Klaus D., et al. Summer heatwaves promote blooms of harmful cyanobacteria. Global change biology 14.3: 495-512 (2008)
#' @examples
#' # load in ggplot
#' library(ggplot2)
#'
#' # subset for the first TPC curve
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'joehnk_2008')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~joehnk_2008(temp = temp, rmax, topt, a, b, c),
#' data = d,
#' iter = c(3,3,3,3,3),
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'joehnk_2008'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'joehnk_2008'),
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
#' @export joehnk_2008

joehnk_2008 <- function(temp, rmax, topt, a, b, c){
  est = rmax * (1 + a*((b^(temp - topt) -1) - (log(b)/log(c))*(c^(temp - topt) - 1)))
  return(est)
}

joehnk_2008.starting_vals <- function(d){
  rmax = max(d$y, na.rm = TRUE)
  topt = mean(d$x[d$y == rmax])
  a = mean(c(5.77, 4.68, 18.61))
  b = mean(c(1.30,1.02,1.02))
  c = mean(c(1.37,1.15,1.04))

  return(c(rmax = rmax, topt = topt, a = a, b = b, c = c))
}

joehnk_2008.lower_lims <- function(d){
  rmax = min(d$y, na.rm = TRUE)
  topt = min(d$x, na.rm = TRUE)
  a = 0
  b = 0
  c = 0

  return(c(rmax = rmax, topt = topt, a = a, b = b, c = c))
}

joehnk_2008.upper_lims <- function(d){
  rmax = max(d$y, na.rm = TRUE) * 10
  topt = max(d$x, na.rm = TRUE)
  a = 1000
  b = 10
  c = 100

  return(c(rmax = rmax, topt = topt, a = a, b = b, c = c))
}
