#' deLong enzyme-assisted Arrhenius model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param c potential reaction rate
#' @param eb baseline energy needed for the reaction to occur (eV)
#' @param ef temperature dependence of folding the enzymes used in the metabolic reaction, relative to the melting temperature (eV)
#' @param tm melting temperature in degrees centigrade
#' @param ehc temperature dependence of the heat capacity between the folded and unfolded state of the enzymes, relative to the melting temperature (eV)
#' @references DeLong, John P., et al. "The combined effects of reactant kinetics and enzyme stability explain the temperature dependence of metabolic rates." Ecology and evolution 7.11 (2017): 3940-3950.
#' @details Equation:
#' \deqn{rate = c \cdot exp\frac{-(e_b-(e_f(1-\frac{temp - 273.15}{t_m})+e_{hc} \cdot ((temp - 273.15) - t_m - (temp - 273.15) \cdot ln(\frac{temp - 273.15}{t_m}))))}{k \cdot (temp - 273.15)}}{%
#' rate = c.exp(-(eb-(ef.(1-((temp + 273.15)/tm))+ehc.((temp + 273.15)-tm-((temp + 273.15).log((temp + 273.15)/tm)))))/(k.(temp + 273.15)))}
#'
#' where \code{k} is Boltzmann's constant with a value of 8.62e-05 and \code{tm} is actually \code{tm - 273.15}
#'
#' Start values in \code{get_start_vals} are derived from the data or sensible values from the literature.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are derived from the data or based extreme values that are unlikely to occur in ecological settings.
#'
#' @note Generally we found this model easy to fit.
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
  delong_2017 <- function(temp_k, c, eb, ef, tm, ehc){
    k <- 8.62e-05

    return( c*exp(-(eb-(ef*(1-((temp + 273.15)/(tm-273.15)))+ehc*((temp + 273.15)-(tm - 273.15)-((temp + 273.15)*log((temp + 273.15)/(tm - 273.15))))))/(k*(temp + 273.15))))
  }
}

