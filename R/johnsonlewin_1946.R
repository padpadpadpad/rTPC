#' Johnson-Lewin model
#'
#'
#' @param temp temperature in degrees centigrade
#' @param e activation energy (eV)
#' @param eh high temperature de-activation energy (eV)
#' @param topt optimum temperature (ºC)
#' @param r0 scaling parameter
#' @author Daniel Padfield
#' @references Johnson, Frank H., and Isaac Lewin. "The growth rate of E. coli in relation to temperature, quinine and coenzyme." Journal of Cellular and Comparative Physiology 28.1 (1946): 47-75.
#' @examples
#' # load in data
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'johnsonlewin_1946')
#' mod <- minpack.lm::nlsLM(rate~johnsonlewin_1946(temp = temp, r0, e, eh, topt),
#' data = d,
#' start = start_vals,
#' control = minpack.lm::nls.lm.control(maxiter = 100))
#'
#' # look at model
#' summary(mod)
#' est_params(mod)
#' @export johnsonlewin_1946

johnsonlewin_1946 <- function(temp, r0, e, eh, topt){
  k <- 8.62e-05
  boltzmann.term <- r0*exp(-e/(k*(temp + 273.15)))
  inactivation.term <- 1/(1 + exp((-1/(k*(temp + 273.15)))* (eh - ((eh/(topt + 273.15)) + k*log(e/(eh - e)))*(temp + 273.15))))
  return(boltzmann.term * inactivation.term)
}

