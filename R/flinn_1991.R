#' Flinn 1991 model
#'
#' @param temp temperature in degrees centigrade
#' @param a parameter that defines the height
#' @param b parameter that describes the slope of the increase
#' @param c parameter that describes the position and steepness of the decline
#' @author Daniel Padfield
#' @references Flinn PW Temperature-dependent functional response of the parasitoid Cephalonomia waterstoni (Gahan) (Hymenoptera, Bethylidae) attacking rusty grain beetle larvae (Coleoptera, Cucujidae). Environmental Entomology, 20, 872–876, (1991)
#'
#' @export flinn_1991

flinn_1991 <- function(temp, a, b, c) {
  est <- 1/(1 + a + b * temp + c * temp^2)
  return(est)
}

