#' Modified gaussian function for TPC
#'
#' @param temp temperature in degrees centigrade
#' @param rmax maximum rate at optimum temperature
#' @param topt optimum temperature
#' @param a related to full curve width
#' @param b allows for asymmetry in the curve fit
#' @details Equation:
#' \deqn{rate = r_{max} \cdot exp^{\bigg[-0.5 \left(\frac{|temp-t_{opt}|}{a}\right)^b\bigg]}}{%
#' rate = rmax.exp(-0.5.(abs(temp - topt)/a)^b)}
#'
#' Start values in \code{get_start_vals} are derived from the data and \code{gaussian_1987}
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are based on extreme values that are unlikely to occur in ecological settings.
#'
#' @note Generally we found this model difficult to fit.
#' @references Angilletta Jr, M. J. (2006). Estimating and comparing thermal performance curves. Journal of Thermal Biology, 31(7), 541-545.
#' @examples
#' \dontrun{ #load in data
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
#' est_params(mod)}
#' @export modifiedgaussian_2006

modifiedgaussian_2006 <- function(temp, rmax, topt, a, b){
  est <- rmax * exp(-0.5 * (abs(temp - topt)/a)^b)
  return(est)
}
