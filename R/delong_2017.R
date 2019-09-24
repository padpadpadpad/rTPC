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
#'
#' @export delong_2017

delong_2017 <- function(temp_k, c, eb, ef, tm, ehc){
  k <- 8.62e-05
  return( c*exp(-(eb-(ef*(1-(temp_k/tm))+ehc*(temp_k-tm-(temp_k*log(temp_k/tm))))))/(k*temp_k))
}

