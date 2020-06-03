#' Hinshelwood model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param a pre-exponential constant for the activation energy
#' @param e activation energy (eV)
#' @param b pre-exponential constant for the deactivation energy
#' @param eh de-activation energy (eV)
#' @author Daniel Padfield
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
#' @examples
#' # load in data
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'hinshelwood_1947')
#' mod <- minpack.lm::nlsLM(rate~hinshelwood_1947(temp = temp, a, e, b, eh),
#' data = d,
#' start = start_vals,
#' control = minpack.lm::nls.lm.control(maxiter = 100))
#'
#' # look at model
#' summary(mod)
#' est_params(mod)
#' @export hinshelwood_1947

hinshelwood_1947 <- function(temp, a, e, b, eh){
  est <- a * exp(-e/(8.62e-05 * (temp + 273.15))) - b * exp(-eh/(8.62e-05 * (temp + 273.15)))
  return(est)
}
