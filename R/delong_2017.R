#' deLong enzyme-assisted Arrhenius model
#'
#' @param temp_k temperature in degrees Kelvin
#' @param c potential reaction rate
#' @param eb baseline energy needed for the reaction to occur (eV)
#' @param ef temperature dependence of folding the enzymes used in the metabolic reaction, relative to the melting temperature
#' @param tm melting temperature in degrees Kelvin
#' @param ehc temperature dependence of the heat capacity between the folded and unfolded state of the enzymes, relative to the melting temperature
#' @author Daniel Padfield
#' @references DeLong, John P., et al. "The combined effects of reactant kinetics and enzyme stability explain the temperature dependence of metabolic rates." Ecology and evolution 7.11 (2017): 3940-3950.
#' @examples
#' \dontrun{# load in data
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'delong_2017')
#' mod <- minpack.lm::nlsLM(rate~delong_2017(temp = temp, c, eb, ef, tm, ehc),
#' data = d,
#' start = start_vals,
#' control = minpack.lm::nls.lm.control(maxiter = 100))
#'
#' # look at model
#' summary(mod)
#' est_params(mod)}
#' @export delong_2017

delong_2017 <- function(temp_k, c, eb, ef, tm, ehc){
  k <- 8.62e-05
  return( c*exp(-(eb-(ef*(1-(temp_k/tm))+ehc*(temp_k-tm-(temp_k*log(temp_k/tm))))))/(k*temp_k))
}

