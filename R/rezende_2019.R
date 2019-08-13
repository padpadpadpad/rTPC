#' Rezende 2019 model
#'
#' @param temp temperature in degrees centigrade
#' @param q10 defines the fold change in performance as a result of increasing the temperature by 10 ºC
#' @param a parameter describing shifts in the vertical axis
#' @param b parameter threshold temperature beyond which the downward curve starts
#' @param c parameter controlling the rate of decline beyond the threshold temperature, b.
#' @author Daniel Padfield
#' @references Rezende, Enrico L., and Francisco Bozinovic. "Thermal performance across levels of biological organization." Philosophical Transactions of the Royal Society B 374.1778 (2019): 20180549.
#' @export rezende_2019

rezende_2019 <- function(temp, q10, a, b, c){

  est <-{ifelse(temp < b, (a*10^(log10(q10)/(10/temp))), (a*10^(log10(q10)/(10/temp)))*(1-c*(b - temp)^2))}
  return(est)
}
