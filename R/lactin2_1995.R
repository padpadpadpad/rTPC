#' Lactin2 model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param a constant that determines the steepness of the rising portion of the curve
#' @param b constant that determines the height of the overall curve
#' @param tmax the temperature at which the curve begins to decelerate beyond the optimum (ºC)
#' @param delta_t thermal safety margin (ºC)
#' @references Lactin, D.J., Holliday, N.J., Johnson, D.L. & Craigen, R. Improved rate models of temperature-dependent development by arthropods. Environmental Entomology 24, 69-75 (1995)
#' @details Equation:
#' \deqn{rate= = exp^{a \cdot temp} - exp^{a \cdot t_{max} - \bigg(\frac{t_{max} - temp}{\delta _{t}}\bigg)} + b}{%
#' rate =  exp(a.temp) - exp(a.tmax - ((tmax - temp) / delta_t)) + b}
#'
#' Start values in \code{get_start_vals} are derived from the data or sensible values from the literature.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are derived from the data or based extreme values that are unlikely to occur in ecological settings.
#'
#' @note Generally we found this model easy to fit.
#' @examples
#' # load in data
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'lactin2_1995')
#' mod <- minpack.lm::nlsLM(rate~lactin2_1995(temp = temp, a, b, tmax, delta_t),
#' data = d,
#' start = start_vals,
#' control = minpack.lm::nls.lm.control(maxiter = 100))
#'
#' # look at model
#' summary(mod)
#' est_params(mod)
#' @export lactin2_1995

lactin2_1995 <- function(temp, a, b, tmax, delta_t){
  est <- exp(a*temp) - exp(a*tmax - ((tmax - temp) / delta_t)) + b
  return(est)
}

