#' Analytis-Kontodimas model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param tmin low temperature (ºC) at which rates become negative
#' @param tmax high temperature (ºC) at which rates become negative
#' @param a scale parameter defining the height of the curve
#' @author Francis Windram
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @references Kontodimas, D. C., Eliopoulos, P. A., Stathas, G. J. & Economou, L. P.
#' Comparative temperature-dependent development of Nephus includens (Kirsch) and Nephus bisignatus (Boheman) (Coleoptera: Coccinellidae)
#' preying on Planococcus citri (Risso) (Homoptera: Pseudococcidae): evaluation of a linear and various nonlinear models using specific
#' criteria. Environ. Entomol. 33, 1–11 (2004).
#' @details Equation:
#' \deqn{rate = a \cdot \left(T - T_{\text{min}}\right)^2 \cdot \left(T_{\text{max}} - T\right)}{%
#' rate = a . (T-Tmin)^2 . (Tmax-T)}
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
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'analytiskontodimas_2004')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~analytiskontodimas_2004(temp = temp, a, tmin, tmax),
#' data = d,
#' iter = 200,
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'analytiskontodimas_2004'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'analytiskontodimas_2004'),
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
#' @export analytiskontodimas_2004
analytiskontodimas_2004 <- function(temp, a, tmin, tmax){
  # FW: This restriction may not be needed
  if ( tmin >= tmax || any(temp <= tmin) || any(temp >= tmax) ) {
    return(rep(1e10, length(temp)))
  } else {
    est <- a * ( (temp - tmin)^2 ) * (tmax - temp)
  }
  return(est)
}

analytiskontodimas_2004.starting_vals <- function(d){
  a = 1
  tmin = min(d$x, na.rm = TRUE) - 1
  tmax = max(d$x, na.rm = TRUE) + 1

  return(c(a=a, tmin=tmin, tmax=tmax))
}

analytiskontodimas_2004.lower_lims <- function(d){
  a = 0
  tmin = -20
  tmax = 0

  return(c(a=a, tmin=tmin, tmax=tmax))
}

analytiskontodimas_2004.upper_lims <- function(d){
  a = Inf
  tmin = 150
  tmax = 150

  return(c(a=a, tmin=tmin, tmax=tmax))
}
