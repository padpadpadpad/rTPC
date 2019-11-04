#' Thomas 2017
#'
#' @param temp temperature in degrees centigrade
#' @param a birth rate at 0 ºC
#' @param b describes the exponential increase in birth rate with increasing temperature
#' @param c temperature-independent mortality term
#' @param d along with e controls the exponential increase in mortality rates with temperature
#' @param e along with d controls the exponential increase in mortality rates with temperature
#' @author Daniel Padfield
#' @references Thomas, Mridul K., et al. "Temperature–nutrient interactions exacerbate sensitivity to warming in phytoplankton." Global change biology 23.8 (2017): 3269-3280.
#' @examples
#' # load in data
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'thomas_2017')
#' mod <- minpack.lm::nlsLM(rate~thomas_2017(temp = temp, a, b, c, d, e),
#' data = d,
#' start = start_vals,
#' control = minpack.lm::nls.lm.control(maxiter = 100))
#'
#' # look at model
#' summary(mod)
#' est_params(mod)
#' @export thomas_2017

thomas_2017 <- function(temp, a, b, c, d, e){
  return(a * exp(b * temp) - (c + d*(exp(e*temp))))
}
