#' Quadratic model
#'
#' @param temp temperature in degrees centigrade
#' @param a parameter that defines the rate at 0 ºC
#' @param b parameter with no biological meaning
#' @param c parameter with no biological meaning
#' @author Daniel Padfield
#' @references Montagnes, David JS, et al. "Short‐term temperature change may impact freshwater carbon flux: a microbial perspective." Global Change Biology 14.12: 2823-2838. (2008)
#' @examples
#' # load in data
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'quadratic_2008')
#' mod <- minpack.lm::nlsLM(rate~quadratic_2008(temp = temp, a, b, c),
#' data = d,
#' start = start_vals,
#' control = minpack.lm::nls.lm.control(maxiter = 100))
#'
#' # look at model
#' summary(mod)
#' est_params(mod)
#' @export quadratic_2008

quadratic_2008 <- function(temp, a, b, c) {
  est <- a + b * temp + c * temp^2
  return(est)
}

