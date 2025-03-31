#' flexTPC model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param tmin low temperature (ºC) at which rates become negative
#' @param tmax high temperature (ºC) at which rates become negative
#' @param rmax maximum performance/value of the trait
#' @param alpha shape parameter to adjust the asymmetry and direction of skew of the curve
#' @param beta shape parameter to adjust the breadth of the curve
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @author Francis Windram
#' @references Cruz-Loya M, Mordecai EA, Savage VM. A flexible model for thermal performance curves. bioRxiv [Preprint]. 2024
#' @details Equation:
# TODO: Add equation and reference
#' \deqn{rate=r_{\text{max}}\left[\left(\frac{T - T_{\text{min}}}{\alpha}\right)^\alpha\left(\frac{T_{\text{max}}-T}{1-\alpha}\right)^{1-\alpha}\left(\frac{1}{T_{\text{max}}-T_{\text{min}}}\right)\right]^{\frac{\alpha(1-\alpha)}{\beta^2}}}{%
#' rate = rmax[((temp-tmin)/alpha)^alpha ((tmax-temp)/(1-alpha))^(1-alpha)(1/(tmax-tmin))]^((alpha(1-alpha))/beta^2)}
#'
#' Start values in \code{get_start_vals} are derived from the data or sensible values from the literature.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are derived from the data or based extreme values that are unlikely to occur in ecological settings.
#' @note Generally this model requires larger iter values in nls_multstart to fit reliably.
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
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'flextpc_2024')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~flextpc_2024(temp = temp, tmin, tmax, rmax, alpha, beta),
#' data = d,
#' iter = c(5,5,5,5,5),
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'flextpc_2024'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'flextpc_2024'),
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
#' @export flextpc_2024

flextpc_2024 <- function(temp, tmin, tmax, rmax, alpha, beta){
  est <- rmax * (((temp - tmin) / alpha) ^ alpha * ((tmax - temp) / (1 - alpha)) ^ (1 - alpha) * (1 / (tmax - tmin))) ^ ((alpha * (1 - alpha)) / beta ^ 2)
  return(est)
}

flextpc_2024.starting_vals <- function(d){
  rmax = max(d$y, na.rm = TRUE)
  topt = mean(d$x[d$y == rmax])
  tmin = min(d$x, na.rm = TRUE)
  tmax = max(d$x, na.rm = TRUE)
  # Use the definitions found in the original paper as starting values
  alpha = (topt - tmin)/(tmax - tmin)
  # Beta is the Upper Thermal Breadth (the range of temps where r(T) > exp(-1/8)*rmax)
  beta = abs(diff(range(d$x[d$y > exp(-1/8)*rmax], na.rm = TRUE)))

  return(c(tmin = tmin, tmax = tmax, rmax = rmax, alpha = alpha, beta = beta))
}

flextpc_2024.lower_lims <- function(d){
  tmin = min(d$x, na.rm = TRUE) - 50
  tmax = min(d$x, na.rm = TRUE)
  rmax = min(d$y, na.rm = TRUE)
  beta = 0  # Cannot be 0
  alpha = 0
  return(c(tmin = tmin, tmax = tmax, rmax = rmax, alpha = alpha, beta = beta))
}

flextpc_2024.upper_lims <- function(d){
  tmin = max(d$x, na.rm = TRUE)
  tmax = max(d$x, na.rm = TRUE) * 5
  rmax = max(d$y, na.rm = TRUE) * 10
  alpha = 1
  beta = 100
  return(c(tmin = tmin, tmax = tmax, rmax = rmax, alpha = alpha, beta = beta))
}

