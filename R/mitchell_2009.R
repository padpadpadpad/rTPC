#' Mitchell Angilletta model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param topt optimum temperature (ºC) where rate is maximal
#' @param a scale parameter to convert the value of the cosine density to the appropriate magnitude
#' @param b parameter dictating the performance breadth
#' @author Daniel Padfield
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @references Mitchell, W. A., & Angilletta Jr, M. J. (2009). Thermal games: frequency-dependent models of thermal adaptation. Functional Ecology, 510-520.
#' @details Equation:
#' \deqn{rate=a\cdot temp \cdot (temp - t_{min}) \cdot (t_{max} - temp)^{\frac{1}{2}}}{%
#' rate = a.temp.(temp - tmin).(tmax - temp)^(1/2)}
#'
#' Start values in \code{get_start_vals} are derived from the data or sensible values from the literature.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are derived from the data or based extreme values that are unlikely to occur in ecological settings.
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
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'mitchell_2009')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~mitchell_2009(temp = temp, topt, a, b),
#' data = d,
#' iter = c(3,3,3),
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'mitchell_2009'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'mitchell_2009'),
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
#' @export mitchell_2009

mitchell_2009 <- function(temp, topt, a, b){
  
  result <- ( 1 / (2 * b) ) * ( 1 + cos( ( (temp - topt) / b ) * pi ) ) * a
  
  # Make sure that all values are positive and that the resulting curve is not multimodal
  
  # if results are negative, make them zero
  result[which(result <= 0)] <- 0
  # in this function b is 1/2 the breadth, so topt - b and topt + b are the inflection points of the curve where the line hits 0
  result[which(temp < topt - b)] <- 0
  result[which(temp > topt + b)] <- 0

  return(result)
}  

mitchell_2009.starting_vals <- function(d){
  topt = mean(d$x[d$y == max(d$y, na.rm = TRUE)])
  a = 2 * 10^-4
  b = max(d$x, na.rm = TRUE) - min(d$x, na.rm = TRUE)
  return(c(topt = topt, a = a, b=b))
}

mitchell_2009.lower_lims <- function(d){
  topt = min(d$x, na.rm = TRUE)
  a = 0
  b = 0
  return(c(topt = topt, a = a, b=b))
}

mitchell_2009.upper_lims <- function(d){
  topt = max(d$x, na.rm = TRUE) *10
  a = Inf
  b = Inf
  return(c(topt = topt, a = a, b=b))
}
