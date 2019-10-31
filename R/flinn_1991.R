#' Flinn 1991 model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param a parameter that defines the height
#' @param b parameter that describes the slope of the increase
#' @param c parameter that describes the position and steepness of the decline
#' @author Daniel Padfield
#' @references Flinn PW Temperature-dependent functional response of the parasitoid Cephalonomia waterstoni (Gahan) (Hymenoptera, Bethylidae) attacking rusty grain beetle larvae (Coleoptera, Cucujidae). Environmental Entomology, 20, 872–876, (1991)
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

flinn_1991 <- function(temp, a, b, c) {
  est <- 1/(1 + a + b * temp + c * temp^2)
  return(est)
}

