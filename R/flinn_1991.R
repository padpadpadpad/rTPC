#' Flinn model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param a parameter that controls the height of the curve
#' @param b parameter that controls the slope of the initial increase of the curve
#' @param c parameter that controls the position and steepness of the decline of the curve
#' @references Flinn PW Temperature-dependent functional response of the parasitoid Cephalonomia waterstoni (Gahan) (Hymenoptera, Bethylidae) attacking rusty grain beetle larvae (Coleoptera, Cucujidae). Environmental Entomology, 20, 872–876, (1991)
#' @details Equation:
#' \deqn{rate= \frac{1}{1+a+b \cdot temp+c \cdot temp^2}}{%
#' rate = 1 / (1 + a + b.temp + c.temp^2)}
#'
#' Start values in \code{get_start_vals} are derived from previous methods from the literature.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are based on extreme values that are unlikely to occur in ecological settings.
#'
#' @note Generally we found this model easy to fit.
#'
#' @examples
#' \dontrun{
#' # load in data
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'flinn_1991')
#' mod <- minpack.lm::nlsLM(rate~flinn_1991(temp = temp, a, b, c),
#' data = d,
#' start = start_vals,
#' control = minpack.lm::nls.lm.control(maxiter = 100))
#'
#' # look at model
#' summary(mod)
#' est_params(mod)}
#' @export flinn_1991

flinn_1991 <- function(temp, a, b, c){
  est <- 1/(1 + a + b * temp + c * temp^2)
  return(est)
}

