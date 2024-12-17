#' Pawar model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param r_tref rate at the standardised temperature, tref
#' @param e activation energy (eV)
#' @param eh high temperature de-activation energy (eV)
#' @param topt optimum temperature (ºC)
#' @param tref standardisation temperature in degrees centigrade. Temperature at which rates are not inactivated by high temperatures
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @author Daniel Padfield
#' @references Kontopoulos, Dimitrios - Georgios, Bernardo García-Carreras, Sofía Sal, Thomas P. Smith, and Samraat Pawar. Use and Misuse of Temperature Normalisation in Meta-Analyses of Thermal Responses of Biological Traits. PeerJ. 6 (2018),
#' @details This model is a modified version of \code{sharpeschoolhigh_1981} that explicitly models the optimum temperature.
#' Equation:
#' \deqn{rate= \frac{r_{tref} \cdot exp^{\frac{-e}{k} (\frac{1}{temp + 273.15}-\frac{1}{t_{ref} + 273.15})}}{1 + (\frac{e}{eh - e}) \cdot exp^{\frac{e_h}{k}(\frac{1}{t_opt + 273.15}-\frac{1}{temp + 273.15})}}}{%
#' rate = r_tref.exp(e/k.(1/tref - 1/(temp + 273.15))) / (1 + (e / (eh-e)) * exp(eh/k.(1/(topt + 273.15) - 1/(temp + 273.15))))}
#'
#' where \code{k} is Boltzmann's constant with a value of 8.62e-05.
#'
#' Start values in \code{get_start_vals} are derived from the data.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are derived from the data or based  extreme values that are unlikely to occur in ecological settings.
#' @note Generally we found this model easy to fit.
#' @examples
#' # load in ggplot
#' library(ggplot2)
#' library(nls.multstart)
#'
#' # subset for the first TPC curve
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'pawar_2018')
#' # fit model
#' mod <- nls_multstart(rate~pawar_2018(temp = temp, r_tref, e, eh, topt, tref = 20),
#' data = d,
#' iter = c(3,3,3,3),
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'pawar_2018'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'pawar_2018'),
#' supp_errors = 'Y',
#' convergence_count = FALSE)
#'
#' # look at model fit
#' summary(mod)
#'
#' # get predictions
#' preds <- data.frame(temp = seq(min(d$temp), max(d$temp), length.out = 100))
#' preds <- broom::augment(mod, newdata = preds)
#'
#' # plot
#' ggplot(preds) +
#' geom_point(aes(temp, rate), d) +
#' geom_line(aes(temp, .fitted), col = 'blue') +
#' theme_bw()
#'
#' @export pawar_2018

pawar_2018 <- function(temp, r_tref, e, eh, topt, tref){
  tref <- 273.15 + tref
  k <- 8.62e-05
  boltzmann.term <- r_tref*exp(e/k * (1/tref - 1/(temp + 273.15)))
  inactivation.term <- 1/(1 + (e/(eh-e)) * exp(eh/k * (1/(topt + 273.15) - 1/(temp + 273.15))))
  return(boltzmann.term * inactivation.term)
}

pawar_2018.starting_vals <- function(d){
  # split data into post topt and pre topt
  post_topt <- d[d$x >= mean(d[d$y == max(d$y, na.rm = TRUE),'x']),]
  pre_topt <- d[d$x <= mean(d[d$y == max(d$y, na.rm = TRUE),'x']),]

  r_tref = mean(d$y, na.rm = TRUE)
  pre_topt$x2 <- 1/(8.62e-05*(pre_topt$x + 273.15))
  post_topt$x2 <- 1/(8.62e-05*(post_topt$x + 273.15))
  e <- suppressWarnings(tryCatch(stats::coef(stats::lm(log(y) ~ x2, pre_topt))[2][[1]] * -1, error = function(err) 0.6))
  eh = suppressWarnings(tryCatch(stats::coef(stats::lm(log(y) ~ x2, post_topt))[2][[1]], error = function(err) 5))
  topt = mean(d$x[d$y == max(d$y, na.rm = TRUE)])
  return(c(r_tref = r_tref, e = e, eh = eh, topt = topt))
}

pawar_2018.lower_lims <- function(d){
  r_tref = 0
  e = 0
  eh = 0
  topt = min(d$x, na.rm = TRUE)
  return(c(r_tref = r_tref, e = e, eh = eh, topt = topt))
}

pawar_2018.upper_lims <- function(d){
  r_tref = max(d$y, na.rm = TRUE)
  e = 10
  eh = 40
  topt = max(d$x)
  return(c(r_tref = r_tref, e = e, eh = eh, topt = topt))
}
