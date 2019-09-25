#' O'Neill 1972 function
#'
#' @param temp temperature in degrees centigrade
#' @param rmax the rate at optimum temperature
#' @param ctmax high temperature at which rates become negative
#' @param topt optimum temperature
#' @param q10 defines the fold change in performance as a result of increasing the temperature by 10 ºC
#' @author Daniel Padfield
#' @references O’Neill, R.V., Goldstein, R.A., Shugart, H.H., Mankin, J.B. Terrestrial Ecosystem Energy Model. Eastern Deciduous Forest Biome Memo Report Oak Ridge ,. The Environmental Sciences Division of the Oak Ridge National Laboratory. (1972)
#'
#' @export oneill_1972

oneill_1972 <- function(temp, rmax, ctmax, topt, q10){
  est <- rmax * ((ctmax - temp)/(ctmax - topt))^(1/400 * ((q10 - 1)*(ctmax - topt))^2 * (1 + sqrt(1+(40/((q10 - 1)*(ctmax - topt)))))^2) * exp((1/400 * ((q10 - 1)*(ctmax - topt))^2 * (1 + sqrt(1+(40/((q10 - 1)*(ctmax - topt)))))^2)*(temp - topt)/(ctmax-topt))
  return(est)
}
