#' Jöhnk 2008 function
#'
#' @param temp temperature in degrees centigrade
#' @param rmax the rate at optimum temperature
#' @param topt optimum temperatute
#' @param a parameter with no biological meaning
#' @param b parameter with no biological meaning
#' @param c parameter with no biological meaning
#' @author Daniel Padfield
#' @references Joehnk, Klaus D., et al. "Summer heatwaves promote blooms of harmful cyanobacteria." Global change biology 14.3: 495-512 (2008)
#' @examples
#' # load in data
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'joehnk_2008')
#' mod <- minpack.lm::nlsLM(rate~joehnk_2008(temp = temp, rmax, topt, a, b, c),
#' data = d,
#' start = start_vals,
#' control = minpack.lm::nls.lm.control(maxiter = 100))
#'
#' # look at model
#' summary(mod)
#' est_params(mod)
#' @export joehnk_2008

joehnk_2008 <- function(temp, rmax, topt, a, b, c){
  est = rmax * (1 + a*((b^(temp - topt) -1) - (log(b)/log(c))*(c^(temp - topt) - 1)))
  return(est)
}
