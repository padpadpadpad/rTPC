#' Lobry-Rosso-Flandros (LRF) model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param rmax maximum rate at optimum temperature
#' @param topt optimum temperature (ºC)
#' @param tmin low temperature (ºC) at which rates become negative
#' @param tmax high temperature (ºC) at which rates become negative
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @author Daniel Padfield
#' @references Rosso, L., Lobry, J. R., & Flandrois, J. P.  An unexpected correlation between cardinal temperatures of microbial growth highlighted by a new model. Journal of Theoretical Biology, 162(4), 447-463. (1993)
#' @details Equation:
#' \deqn{rate=  rmax \cdot \frac{(temp - t_{max}) \cdot (temp - t_{min})^2}{(t_{opt} - t_{min}) \cdot ((t_{opt} - t_{min}) \cdot (temp - t_{opt}) - (t_{opt} - t_{max}) \cdot (t_{opt} + t_{min} - 2 \cdot temp))}}{%
#' rate = rmax * ((temp - tmax)(temp - tmin))^2 / ((topt - tmin)((topt - tmin)(temp - topt) - (topt - tmax)(topt + tmin - 2.temp)))}
#'
#' Start values in \code{get_start_vals} are derived from the data.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are derived from the data or based  extreme values that are unlikely to occur in ecological settings.
#' @note Generally we found this model easy to fit.
#' @examples
#' # load in ggplot
#' library(ggplot2)
#' library(nls.multstart)
#'
#' # subset for the first TPC curve
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'sharpeschoolhigh_1981')
#' # fit model
#' mod <- nls_multstart(rate~lrf_1991(temp = temp, rmax, topt, tmin, tmax),
#' data = d,
#' iter = c(3,3,3,3),
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'lrf_1991'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'lrf_1991'),
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
#' @export lrf_1991

lrf_1991 <- function(temp, rmax, topt, tmin, tmax){
  return(rmax*((temp - tmax)*(temp - tmin)^2) / ((topt - tmin) * (((topt - tmin)*(temp - topt))-((topt-tmax)*(topt+tmin-2*temp)))))
  }

