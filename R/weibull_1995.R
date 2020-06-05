#' Weibull model
#'
#'
#' @param temp temperature in degrees centigrade
#' @param a scale the height of the curve
#' @param topt optimum temperature
#' @param b defines the breadth of the curve
#' @param c defines the curve shape
#' @references Angilletta Jr, Michael J. "Estimating and comparing thermal performance curves." Journal of Thermal Biology 31.7 (2006): 541-545.
#' @details Equation:
#' \deqn{rate = a \cdot \bigg( \frac{c-1}{c}\bigg)^{\frac{1-c}{c}}\bigg[\frac{temp-t_{opt}}{b}+\bigg(\frac{c-1}{c}\bigg)^{\frac{1}{c}}\bigg]^{c-1}exp^{-\big[\frac{temp-t_{opt}}{b}+\big( \frac{c-1}{c}\big)^{\frac{1}{c}}\big]^c} + \frac{c-1}{c}}{%
#' rate = ((a.(((c-1)/c)^((1-c)/c)).((((temp-topt)/b)+(((c-1)/c)^(1/c)))^(c-1)).(exp(-((((temp-topt)/b)+(((c-1)/c)^(1/c)))^c)+((c-1)/c)))))}
#'
#' Start values in \code{get_start_vals} are derived from the data.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are derived from the data or based  extreme values that are unlikely to occur in ecological settings.
#' @note Generally we found this model easy to fit.
#' @examples
#' # load in data
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'weibull_1995')
#' mod <- minpack.lm::nlsLM(rate~weibull_1995(temp = temp, a, topt, b, c),
#' data = d,
#' start = start_vals,
#' control = minpack.lm::nls.lm.control(maxiter = 100))
#'
#' # look at model
#' summary(mod)
#' est_params(mod)
#' @export weibull_1995

weibull_1995 <- function(temp, a, topt, b, c){
  return((a*(((c-1)/c)^((1-c)/c))*((((temp-topt)/b)+(((c-1)/c)^(1/c)))^(c-1))*(exp(-((((temp-topt)/b)+(((c-1)/c)^(1/c)))^c)+((c-1)/c)))))
}


