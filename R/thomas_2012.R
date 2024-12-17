#' Thomas model (2012) for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param a arbitrary constant
#' @param b arbitrary constant
#' @param c the range of temperatures over which growth rate is positive, or the thermal niche width (ºC)
#' @param tref determines the location of the maximum of the quadratic portion of this function. When b = 0, tref would equal topt
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @references Thomas, Mridul K., et al. A global pattern of thermal adaptation in marine phytoplankton. Science 338.6110, 1085-1088 (2012)
#' @details Equation:
#' \deqn{rate = a \cdot exp^{b \cdot temp} \bigg(1-\bigg(\frac{temp - t_{ref}}{c/2}\bigg)^2\bigg)}{%
#' rate = a . exp(b . temp) . (1 - ((temp - topt)/(c/2))^2)}
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
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'thomas_2012')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~thomas_2012(temp = temp, a, b, c, tref),
#' data = d,
#' iter = c(4,4,4,4),
#' start_lower = start_vals - 1,
#' start_upper = start_vals + 2,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'thomas_2012'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'thomas_2012'),
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
#' @export thomas_2012

thomas_2012 <- function(temp, a, b, c, tref){
  est <-  a * exp(b * temp) * (1 - ((temp - tref)/(c/2))^2)
  return(est)
}

thomas_2012.starting_vals <- function(d){
  c = max(d$x, na.rm = TRUE) - min(d$x, na.rm = TRUE)
  b = 0
  tref = mean(d$x[d$y==max(d$y, na.rm = TRUE)])
  a = max(d$y)/max(exp(b*d$x)*(1-((d$x-tref)/(c/2))^2))
  return(c(a = a, b = b, c = c, tref = tref))
}

thomas_2012.lower_lims <- function(d){
  tref = min(d$x) - 150
  c = 0
  a = -10
  b = -10
  return(c(a = a, b = b, c = c, tref = tref))
}

thomas_2012.upper_lims <- function(d){
  a = 10
  b = 10
  c = (max(d$x) - min(d$x)) * 10
  tref = max(d$x) + 100
  return(c(a=a, b=b, c=c, tref=tref))
}
