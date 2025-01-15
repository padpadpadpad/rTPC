#' Warren-Dreyer model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param rmax maximum performance/value of the trait
#' @param topt temperature of max performance (ºC)
#' @param a shape parameter
#' @author Francis Windram
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @references Warren, C. R. & Dreyer, E. Temperature response of photosynthesis and internal conductance to CO2: results from two independent approaches. J. Exp. Bot. 57, 3057–3067 (2006).
#' @details Equation:
#' \deqn{rate = R_{\text{max}} \cdot \exp{\left[-0.5 \cdot \left(\frac{\ln{\frac{T}{T_{\text{opt}}}}}{a}\right)^2\right]}}{%
#' rate = Rmax . e^[-0.5 . (ln(T/Topt)/a)^2]}
#'
#' Start values in \code{get_start_vals} are derived from the data or sensible values from the literature.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are derived from the data or based extreme values that are unlikely to occur in ecological settings.
#'
#' @note Generally we found this model easy to fit.
#' @concept model
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
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'warrendreyer_2006')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~warrendreyer_2006(temp = temp, rmax, topt, a),
#' data = d,
#' iter = c(3,3,3),
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'warrendreyer_2006'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'warrendreyer_2006'),
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
#' }
#' @export warrendreyer_2006

warrendreyer_2006 <- function(temp, rmax, topt, a){
  est <- rmax * exp(- 0.5 * (log(temp/topt) / a )^2)
  return(est)

}

warrendreyer_2006.starting_vals <- function(d){
  rmax = max(d$y, na.rm = TRUE)
  topt = mean(d$x[d$y == rmax])
  a = 1
  return(c(rmax=rmax, topt=topt, a=a))
}

warrendreyer_2006.lower_lims <- function(d){
  rmax = 0
  topt = 0
  a = 0
  return(c(rmax=rmax, topt=topt, a=a))
}

warrendreyer_2006.upper_lims <- function(d){
  rmax = Inf
  topt = 150
  a = Inf
  return(c(rmax=rmax, topt=topt, a=a))
}
