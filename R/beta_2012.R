#' Beta model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param a dimensionless parameter
#' @param b dimensionless parameter
#' @param c dimensionless parameter
#' @param d dimensionless parameter
#' @param e dimensionless parameter
#' @author Daniel Padfield
#' @references Niehaus, Amanda C., et al. Predicting the physiological performance of ectotherms in fluctuating thermal environments. Journal of Experimental Biology 215.4: 694-701 (2012)
#' @examples
#' \dontrun{
#' #' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'beta_2012')
#' mod <- minpack.lm::nlsLM(rate~beta_2012(temp = temp, a, b, c, d, e),
#' data = d,
#' start = start_vals,
#' control = minpack.lm::nls.lm.control(maxiter = 1000))
#'
#' # look at model
#' summary(mod)
#' est_params(mod)}
#' @export beta_2012

beta_2012 <- function(temp, a, b, c, d, e){
  est <- (a*((temp - b + ((c*(d-1))/(d + e - 2)))/c)^(d-1) * (1 - ((temp - b + ((c*(d-1))/(d + e - 2)))/c))^(e-1)) / (((d-1)/(d + e - 2))^(d-1) * ((e-1)/(d + e - 2))^(e-1))
  return(est)
}
