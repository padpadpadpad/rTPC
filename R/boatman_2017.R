#' Boatman model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param rmax the rate at optimum temperature
#' @param tmin low temperature (ºC) at which rates become negative
#' @param tmax high temperature (ºC) at which rates become negative
#' @param a shape parameter to adjust the asymmetry of the skewness
#' @param b is a shape determining parameter, which alters the kurtosis
#' @author Daniel Padfield
#' @references Boatman, T. G., Lawson, T., & Geider, R. J. A key marine diazotroph in a changing ocean: The interacting effects of temperature, CO2 and light on the growth of Trichodesmium erythraeum IMS101. PLoS ONE, 12, e0168796 (2017)
#'
#' @examples
#' \dontrun{
#' # load in data
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'boatman_2017')
#' mod <- minpack.lm::nlsLM(rate~boatman_2017(temp = temp, rmax, tmin, tmax, a, b),
#' data = d,
#' start = start_vals,
#' control = minpack.lm::nls.lm.control(maxiter = 1000))
#'
#' # look at model
#' summary(mod)
#' est_params(mod)}
#'
#' @export boatman_2017

boatman_2017 <- function(temp, rmax, tmin, tmax, a, b){
  est <- rmax * (sin(pi * ((temp - tmin)/(tmax - tmin))^a))^b
  return(est)
}

