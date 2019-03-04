#' Hinshelwood 1947 model
#'
#' @param temp_k temperature in degrees Kelvin
#' @param a pre-exponential factor
#' @param e activation energy (eV)
#' @param c pre-exponential factor
#' @param eh de-activation energy (eV)
#' @author Daniel Padfield
#' @references Hinshelwood C.N. The Chemical Kinetics of the Bacterial Cell. Oxford University Press. (1947)
#' @export hinshelwood_1947

hinshelwood_1947 <- function(temp_k, a, e, c, eh){
  est <- a * exp(-e/(8.62e-05 * temp_k)) - c * exp(-eh/(8.62e-05 * temp_k))
  return(est)
}

