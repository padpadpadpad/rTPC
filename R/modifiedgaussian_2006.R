#' Modified gaussian function for TPC
#'
#' @param temp temperature in degrees centigrade
#' @param rmax maximum rate at optimum temperature
#' @param topt optimum temperature
#' @param a related to full curve width
#' @param b allows for asymmetry in the curve fit
#' @author Daniel Padfield
#' @examples
# load in data
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'modifiedgaussian_2006')
#' mod <- minpack.lm::nlsLM(rate~modifiedgaussian_2006(temp = temp, rmax, topt, a, b),
#' data = d,
#' start = start_vals,
#' control = minpack.lm::nls.lm.control(maxiter = 1000))
#'
#' # look at model
#' summary(mod)
#' est_params(mod)
#' @export modifiedgaussian_2006

modifiedgaussian_2006 <- function(temp, rmax, topt, a, b){
  est <- rmax * exp(-0.5 * (abs(temp - topt)/a)^b)
  return(est)
}
