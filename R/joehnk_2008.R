#' Jöhnk 2008 function
#'
#' @param temp temperature in degrees centigrade
#' @param rmax the rate at optimum temperature
#' @param topt optimum temperatutr
#' @param a parameter with no biological meaning
#' @param b parameter with no biological meaning
#' @param c parameter with no biological meaning
#' @author Daniel Padfield
#' @references Joehnk, Klaus D., et al. "Summer heatwaves promote blooms of harmful cyanobacteria." Global change biology 14.3: 495-512 (2008)
#'
#' @export joehnk_2008

joehnk_2008 <- function(temp, rmax, topt, a, b, c){
  est = rmax * (1 + a*((b^(temp - topt) -1) - (log(b)/log(c))*(c^(temp - topt) - 1)))
  return(est)
}
