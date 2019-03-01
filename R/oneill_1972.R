#' O'Neill 1972 function
#'
#' @param temp temperature in degrees centigrade
#' @param rmax the rate at optimum temperature
#' @param tmax high temperature at which rates become negative
#' @param topt optimum temperature
#' @param a shape parameter to adjust the asymmetry of the skewness
#' @author Daniel Padfield
#' @references O’Neill, R.V., Goldstein, R.A., Shugart, H.H., Mankin, J.B. Terrestrial Ecosystem Energy Model. Eastern Deciduous Forest Biome Memo Report Oak Ridge ,. The Environmental Sciences Division of the Oak Ridge National Laboratory. (1972)
#'
#' @export oneill_1972

oneill_1972 <- function(temp, rmax, tmax, topt, a){
  est <- rmax * ((tmax - temp)/(tmax - topt))^a * exp(a*(temp - topt)/(tmax-topt))
  return(est)
}
