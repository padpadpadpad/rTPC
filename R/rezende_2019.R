#' Rezende 2019 model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param q10 defines the fold change in performance as a result of increasing the temperature by 10 ºC
#' @param a parameter describing shifts in rate
#' @param b parameter threshold temperature (ºC) beyond which the downward curve starts
#' @param c parameter controlling the rate of decline beyond the threshold temperature, b
#' @references Rezende, Enrico L., and Francisco Bozinovic. Thermal performance across levels of biological organization. Philosophical Transactions of the Royal Society B 374.1778 (2019): 20180549.
#' @details Equation:
#' \deqn{\textrm{if} \quad temp < t_{max}: rate = a \cdot 10 ^{\frac{\log_{10} (q_{10})}{(\frac{10}{temp})}}}{%
#' rate = (a.10^(log10(q10)/(10/temp)))}
#' \deqn{\textrm{if} \quad temp > t_{max}: rate = a \cdot 10 ^{\frac{\log_{10} (q_{10})}{(\frac{10}{temp})}} \cdot \bigg(1-d(temp-t_{max})^2 \bigg)}{%
#' rate = (a.10^(log10(q10)/(10/temp))).(1-c.(b - temp)^2))}
#'
#' Start values in \code{get_start_vals} are derived from the data and previous values in the literature.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are based on extreme values that are unlikely to occur in ecological settings.
#'
#' @note Generally we found this model easy to fit.
#' @examples
#' # load in data
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'rezende_2019')
#' mod <- minpack.lm::nlsLM(rate~rezende_2019(temp = temp, q10, a, b, c),
#' data = d,
#' start = start_vals,
#' control = minpack.lm::nls.lm.control(maxiter = 100))
#'
#' # look at model
#' summary(mod)
#' est_params(mod)
#' @export rezende_2019

rezende_2019 <- function(temp, q10, a, b, c){

  est <-{ifelse(temp < b, (a*10^(log10(q10)/(10/temp))), (a*10^(log10(q10)/(10/temp)))*(1-c*(b - temp)^2))}
  return(est)
}
