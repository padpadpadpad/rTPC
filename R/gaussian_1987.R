#' Gaussian model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param rmax maximum rate at optimum temperature
#' @param topt optimum temperature (ºC)
#' @param a related to the full curve width
#' @author Daniel Padfield
#' @references Lynch, M., Gabriel, W., Environmental tolerance. The American Naturalist. 129, 283–303. (1987)
#' @details Equation:
#' \deqn{rate=\mu _{max} \cdot exp^{\bigg[-0.5 \left(\frac{|T-T_{opt}|}{a}\right)^2\bigg]}}{%
#' rate = rmax.exp(-0.5.(abs(temp - topt)/a)^2)}
#'
#' @examples
#' # load in data
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'gaussian_1987')
#' mod <- minpack.lm::nlsLM(rate~gaussian_1987(temp = temp, rmax, topt, a),
#' data = d,
#' start = start_vals,
#' control = minpack.lm::nls.lm.control(maxiter = 100))
#'
#' # look at model
#' summary(mod)
#' est_params(mod)
#' @export gaussian_1987

gaussian_1987 <- function(temp, rmax, topt, a){
  est <- rmax * exp(-0.5 * (abs(temp - topt)/a)^2)
  return(est)
}
