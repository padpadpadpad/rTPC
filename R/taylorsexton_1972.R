#' Taylor-Sexton model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param rmax maximum performance/value of the trait
#' @param tmin low temperature (ºC) at which rates become negative
#' @param topt optimum temperature (ºC)
#' @author Francis Windram
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @references Taylor, S. E. & Sexton, O. J. Some implications of leaf tearing in Musaceae. Ecology 53, 143–149 (1972).
#' @details Equation:
#' \deqn{rate = R_{\text{max}} \cdot \frac{-(T-T_{\text{min}})^4 + 2 \cdot (T - T_{\text{min}})^2 \cdot (T_{\text{opt}}-T_{\text{min}})^2}{(T_{\text{opt}}-T_{\text{min}})^4}}{%
#' rate = Rmax . ((-(T-Tmin)^4 + 2(T-Tmin)^2 . (Topt-Tmin)^2)/(Topt-Tmin)^4)}
#'
#' Start values in \code{get_start_vals} are derived from the data or sensible values from the literature.
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
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'taylorsexton_1972')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~taylorsexton_1972(temp = temp, rmax, tmin, topt),
#' data = d,
#' iter = 200,
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'taylorsexton_1972'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'taylorsexton_1972'),
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
#' @export taylorsexton_1972
taylorsexton_1972 <- function(temp, rmax, tmin, topt){
  # FW: This restriction may not be needed
  if (topt <= tmin || any(temp < tmin)) {
    return(rep(1e10, length(temp)))
  } else {
    est <- rmax * ( - (temp - tmin)^4 + 2 * ((temp - tmin)^2) * (topt - tmin)^2 ) / (topt - tmin)^4
  }
  return(est)
}

taylorsexton_1972.starting_vals <- function(d){
  rmax = max(d$y, na.rm = TRUE)
  tmin = min(d$x, na.rm = TRUE)
  topt = mean(d$x[d$y == rmax])

  return(c(rmax=rmax, tmin=tmin, topt=topt))
}

taylorsexton_1972.lower_lims <- function(d){
  rmax = 0
  tmin = -20
  topt = 0

  return(c(rmax=rmax, tmin=tmin, topt=topt))
}

taylorsexton_1972.upper_lims <- function(d){
  rmax = Inf
  tmin = 150
  topt = 150

  return(c(rmax=rmax, tmin=tmin, topt=topt))
}
