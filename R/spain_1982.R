#' Spain model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param a constant that determines the steepness of the rising portion of the curve
#' @param b constant that determines the position of topt
#' @param c constant that determines the steepness of the decreasing part of the curve
#' @param r0 the apparent rate at 0 ºC
#' @references BASIC Microcomputer Models in Biology. Addison-Wesley, Reading, MA. 1982
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @details Equation:
#' \deqn{rate = r_0 \cdot exp^{a \cdot temp} \cdot (1-b \cdot exp^{c \cdot temp})}{%
#' rate = est = r0 . exp(a.temp) . (1 - b.exp(c.temp))}
#'
#' Start values in \code{get_start_vals} are derived from the data or plucked from thin air.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are derived from the data or plucked from thin air.
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
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'spain_1982')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~spain_1982(temp = temp, a, b, c, r0),
#' data = d,
#' iter = c(3,3,3,3),
#' start_lower = start_vals - 1,
#' start_upper = start_vals + 1,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'spain_1982'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'spain_1982'),
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
#' @export spain_1982

spain_1982 <- function(temp, a, b, c, r0){
  est = r0 * exp(a*temp) * (1 - b*exp(c*temp))
  return(est)
}

spain_1982.starting_vals <- function(d){
  r0 = min(d$y, na.rm = TRUE)
  a = 0
  b = 0
  c = 0
  return(c(a = a, b = b, c = c, r0 = r0))
}

spain_1982.lower_lims <- function(d){
  r0 = abs(min(d$y, na.rm = TRUE))*-100
  a = -2
  b = -2
  c = -2
  return(c(a = a, b = b, c = c, r0 = r0))
}

spain_1982.upper_lims <- function(d){
  r0 = max(d$y, na.rm = TRUE)
  a = 2
  b = 20
  c = 2
  return(c(a = a, b = b, c = c, r0 = r0))
}
