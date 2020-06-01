#' Briere2 et al. model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param tmin low temperature (ºC) at which rates become negative
#' @param tmax high temperature (ºC) at which rates become negative
#' @param a scale parameter to adjust maximum rate of the curve
#' @param b shape parameter to adjust the asymmetry of the curve
#' @author Daniel Padfield
#' @references Brière, J.F., Pracros, P., Le Roux, A.Y., Pierre, J.S.,  A novel rate model of temperature-dependent development for arthropods. Environmental Entomololgy, 28, 22–29 (1999)
#' @details Equation:
#' \deqn{rate=a\cdot temp \cdot(temp - t_{min}) \cdot (t_{max} - T)^{\frac{1}{b}}}{%
#' rate = a.temp.(temp - tmin).(tmax - temp)^(1/b)}
#'
#' @examples
#' # load in data
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'briere2_1999')
#' mod <- minpack.lm::nlsLM(rate~briere2_1999(temp = temp, tmin, tmax, a, b),
#' data = d,
#' start = start_vals,
#' control = minpack.lm::nls.lm.control(maxiter = 100))
#'
#' # look at model
#' summary(mod)
#' est_params(mod)
#' @export briere2_1999

briere2_1999 <- function(temp, tmin, tmax, a, b){
  est <- a*temp * (temp - tmin) * (tmax - temp)^(1/b)
  return(est)
}

