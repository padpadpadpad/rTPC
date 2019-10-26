#' O'Neill 1972 model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param rmax the rate at optimum temperature
#' @param ctmax high temperature (ºC) at which rates become negative
#' @param topt optimum temperature (ºC)
#' @param q10 defines the fold change in performance as a result of increasing the temperature by 10 ºC
#' @author Daniel Padfield
#' @references O’Neill, R.V., Goldstein, R.A., Shugart, H.H., Mankin, J.B. Terrestrial Ecosystem Energy Model. Eastern Deciduous Forest Biome Memo Report Oak Ridge ,. The Environmental Sciences Division of the Oak Ridge National Laboratory. (1972)
#' @examples
#' \dontrun{
#' # load in data
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'oneill_1972')
#' mod <- minpack.lm::nlsLM(rate~oneill_1972(temp = temp, rmax, ctmax, topt, q10),
#' data = d,
#' start = start_vals,
#' control = minpack.lm::nls.lm.control(maxiter = 100))
#'
#' # look at model
#' summary(mod)
#' est_params(mod)}
#' @export oneill_1972

oneill_1972 <- function(temp, rmax, ctmax, topt, q10){
  est <- rmax * ((ctmax - temp)/(ctmax - topt))^(1/400 * ((q10 - 1)*(ctmax - topt))^2 * (1 + sqrt(1+(40/((q10 - 1)*(ctmax - topt)))))^2) * exp((1/400 * ((q10 - 1)*(ctmax - topt))^2 * (1 + sqrt(1+(40/((q10 - 1)*(ctmax - topt)))))^2)*(temp - topt)/(ctmax-topt))
  return(est)
}
