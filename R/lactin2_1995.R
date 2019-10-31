#' Lactin2 function
#'
#' @param temp temperature in degrees centigrade
#' @param a constant that determines the steepness of the rising portion of the curve
#' @param b constant that determines the height of the overall curve
#' @param tmax changes the temperature at which the curve begins to decelerate beyond the optimum
#' @param delta_t thermal safety margin
#' @author Daniel Padfield
#' @references Lactin, D.J., Holliday, N.J., Johnson, D.L. & Craigen, R. Improved rate models of temperature-dependent development by arthropods. Environ. Entomol. 24, 69-75 (1995)
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

