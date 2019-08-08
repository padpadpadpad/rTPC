#' Johnson-Lewin model
#'
#'
#' @param temp_k temperature in degrees Kelvin
#' @param e activation energy (eV)
#' @param eh high temperature de-activation energy (eV)
#' @param topt optimum temperature (K)
#' @param r0 scaling parameter
#' @author Daniel Padfield
#' @references Johnson, Frank H., and Isaac Lewin. "The growth rate of E. coli in relation to temperature, quinine and coenzyme." Journal of Cellular and Comparative Physiology 28.1 (1946): 47-75.
#'
#' @export johnsonlewin_1946

johnsonlewin_1946 <- function(temp_k, r0, e, eh, topt){
  k <- 8.62e-05
  boltzmann.term <- r0*exp(-e/(k*temp_k))
  inactivation.term <- 1/(1 + exp((-1/(k*temp_k))* (eh - ((eh/topt) + k*log(e/(eh - e)))*temp_k)))
  return(boltzmann.term * inactivation.term)
}

