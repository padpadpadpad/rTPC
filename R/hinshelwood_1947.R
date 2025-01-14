#' Hinshelwood model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param a pre-exponential constant for the activation energy
#' @param e activation energy (eV)
#' @param b pre-exponential constant for the deactivation energy
#' @param eh de-activation energy (eV)
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @references Hinshelwood C.N. The Chemical Kinetics of the Bacterial Cell. Oxford University Press. (1947)
#' @details Equation:
#' \deqn{rate=a \cdot exp^{\frac{-e}{k \cdot (temp + 273.15)}} - b \cdot exp^\frac{-e_h}{k \cdot (temp + 273.15)}}{%
#' rate = a.exp(-e/k.(temp + 273.15)) - b.exp(-eh/k.(temp + 273.15))}
#'
#' where \code{k} is Boltzmann's constant with a value of 8.62e-05
#'
#' Start values in \code{get_start_vals} are taken from the literature.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are based on extreme values that are unlikely to occur in ecological settings.
#'
#' @note Generally we found this model difficult to fit.
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
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'hinshelwood_1947')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~hinshelwood_1947(temp = temp,a, e, b, eh),
#' data = d,
#' iter = c(5,5,5,5),
#' start_lower = start_vals - 1,
#' start_upper = start_vals + 1,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'hinshelwood_1947'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'hinshelwood_1947'),
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
#' @export hinshelwood_1947

hinshelwood_1947 <- function(temp, a, e, b, eh){
  est <- a * exp(-e/(8.62e-05 * (temp + 273.15))) - b * exp(-eh/(8.62e-05 * (temp + 273.15)))
  return(est)
}

hinshelwood_1947.starting_vals <- function(d){
  a = 595892892
  b = 1.57e+30
  e = 0.5125673
  eh = 1.922022
  return(c(a=a, e=e, b=b, eh = eh))
}

hinshelwood_1947.lower_lims <- function(d){
  a = 0
  b = 0
  e = 0
  eh = 0
  return(c(a=a, e=e, b=b, eh = eh))
}

hinshelwood_1947.upper_lims <- function(d){
  a = 1e50
  b = 1e100
  e = 10
  eh = 30
  return(c(a=a, e=e, b=b, eh = eh))
}
