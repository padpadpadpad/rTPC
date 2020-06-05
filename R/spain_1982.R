#' Spain model
#'
#' @param temp temperature in degrees centigrade
#' @param a constant that determines the steepness of the rising portion of the curve
#' @param b constant that determines the position of topt
#' @param c constant that determines the steepness of the decreasing part of the curve
#' @param r0 the apparent rate at 0 ºC
#' @references BASIC Microcomputer Models in Biology. Addison-Wesley, Reading, MA. 1982
#'
#' @details Equation:
#' \deqn{rate = r_0 \cdot exp^{a \cdot temp} \cdot (1-b \cdot exp^{c \cdot temp})}{%
#' rate = est = r0 . exp(a.temp) . (1 - b.exp(c.temp))}
#' 
#' Start values in \code{get_start_vals} are derived from the data.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are derived from the data or based on extreme values that are unlikely to occur in ecological settings.
#' @note Generally we found this model easy to fit.
#' @examples
#' # load in data
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'spain_1982')
#' mod <- minpack.lm::nlsLM(rate~spain_1982(temp = temp, a, b, c, r0),
#' data = d,
#' start = start_vals,
#' control = minpack.lm::nls.lm.control(maxiter = 100))
#'
#' # look at model
#' summary(mod)
#' @export spain_1982

spain_1982 <- function(temp, a, b, c, r0){
  est = r0 * exp(a*temp) * (1 - b*exp(c*temp))
  return(est)
}
