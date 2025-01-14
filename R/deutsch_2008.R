#' Modified deutsch model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param rmax maximum rate at optimum temperature
#' @param topt optimum temperature (ºC)
#' @param ctmax critical thermal maximum (ºC)
#' @param a related to the full curve width
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @references Deutsch, C. A., Tewksbury, J. J., Huey, R. B., Sheldon, K. S., Ghalambor, C. K., Haak, D. C., & Martin, P. R. Impacts of climate warming on terrestrial ectotherms across latitude. Proceedings of the National Academy of Sciences, 105(18), 6668-6672. (2008)
#' @details Equation:
#' \deqn{\textrm{if} \quad temp < t_{opt}: rate = r_{max} \cdot exp^{-\bigg(\frac{temp-t_{opt}}{2a}\bigg)^2}}{%
#' rate = rmax.exp(-((temp - topt)/(2a))^2)}
#' \deqn{\textrm{if} \quad temp > t_{opt}: rate = r_{max} \cdot \left(1 - \bigg(\frac{temp - t_{opt}}{t_{opt} - ct_{max}}\bigg)^2\right)}{%
#' rate = rmax.(1 - ((temp - topt)/(topt - ctmax))^2)}
#'
#' Start values in \code{get_start_vals} are derived from the data.
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
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'deutsch_2008')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~deutsch_2008(temp = temp, rmax, topt, ctmax, a),
#' data = d,
#' iter = c(4,4,4,4),
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'deutsch_2008'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'deutsch_2008'),
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
#' @export deutsch_2008
deutsch_2008 <- function(temp, rmax, topt, ctmax, a){

  est <- {ifelse(temp < topt, rmax * exp(-((temp - topt)/(2*a))^2), rmax * (1 - ((temp - topt)/(topt - ctmax))^2))}

  return(est)
}

deutsch_2008.starting_vals <- function(d){
  rmax = max(d$y, na.rm = TRUE)
  topt = mean(d$x[d$y == rmax])
  ctmax = max(d$x, na.rm = TRUE)
  # use the width of the temperatures measured divided by 5. Somewhat arbritary
  a = (max(d$x, na.rm = TRUE) - min(d$x, na.rm = TRUE))/5

  return(c(rmax = rmax, topt = topt, ctmax = ctmax, a = a))
}

deutsch_2008.lower_lims <- function(d){
  rmax = min(d$y, na.rm = TRUE)
  topt = min(d$x, na.rm = TRUE)
  ctmax = min(d$x, na.rm = TRUE)
  a = 0

  return(c(rmax = rmax, topt = topt, ctmax = ctmax, a = a))
}

deutsch_2008.upper_lims <- function(d){
  rmax = max(d$y, na.rm = TRUE) * 10
  topt = max(d$x, na.rm = TRUE)
  ctmax = max(d$x, na.rm = TRUE) * 10
  a = (max(d$x, na.rm = TRUE) - min(d$x, na.rm = TRUE)) * 10

  return(c(rmax = rmax, topt = topt, ctmax = ctmax, a = a))
}
