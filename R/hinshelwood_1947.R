#' Hinshelwood 1947 model
#'
#' @param temp temperature in degrees centigrade
#' @param a pre-exponential factor
#' @param e activation energy (eV)
#' @param b pre-exponential factor
#' @param eh de-activation energy (eV)
#' @author Daniel Padfield
#' @references Hinshelwood C.N. The Chemical Kinetics of the Bacterial Cell. Oxford University Press. (1947)
#' @export hinshelwood_1947

hinshelwood_1947 <- function(temp, a, e, b, eh){
  est <- a * exp(-e/(8.62e-05 * (temp + 273.15))) - b * exp(-eh/(8.62e-05 * (temp + 273.15)))
  return(est)
}
