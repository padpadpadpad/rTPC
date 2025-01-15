#' Sharpe-Schoolfield model (high temperature inactivation only) for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param r_tref rate at the standardised temperature, tref
#' @param e activation energy (eV)
#' @param eh high temperature de-activation energy (eV)
#' @param th temperature (ºC) at which enzyme is 1/2 active and 1/2 suppressed due to high temperatures
#' @param tref standardisation temperature in degrees centigrade. Temperature at which rates are not inactivated by high temperatures
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @author Daniel Padfield
#' @references Schoolfield, R. M., Sharpe, P. J. & Magnuson, C. E. Non-linear regression of biological temperature-dependent rate models based on absolute reaction-rate theory. J. Theor. Biol. 88, 719-731 (1981)
#' @details Equation:
#' \deqn{rate= \frac{r_{tref} \cdot exp^{\frac{-e}{k} (\frac{1}{temp + 273.15}-\frac{1}{t_{ref} + 273.15})}}{1 + exp^{\frac{e_h}{k}(\frac{1}{t_h}-\frac{1}{temp + 273.15})}}}{%
#' rate = r_tref.exp(e/k.(1/tref - 1/(temp + 273.15))) / (1 + exp(eh/k.(1/(th + 273.15) - 1/(temp + 273.15))))}
#'
#' where \code{k} is Boltzmann's constant with a value of 8.62e-05.
#'
#' Start values in \code{get_start_vals} are derived from the data.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are derived from the data or based  extreme values that are unlikely to occur in ecological settings.
#' @note Generally we found this model easy to fit.
#' @concept model
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
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'sharpeschoolhigh_1981')
#' # fit model
#' mod <- nls_multstart(rate~sharpeschoolhigh_1981(temp = temp, r_tref, e, eh, th, tref = 20),
#' data = d,
#' iter = c(3,3,3,3),
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'sharpeschoolhigh_1981'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'sharpeschoolhigh_1981'),
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
#' @export sharpeschoolhigh_1981

sharpeschoolhigh_1981 <- function(temp, r_tref, e, eh, th, tref){
  tref <- 273.15 + tref
  k <- 8.62e-05
  boltzmann.term <- r_tref*exp(e/k * (1/tref - 1/(temp + 273.15)))
  inactivation.term <- 1/(1 + exp(eh/k * (1/(th + 273.15) - 1/(temp + 273.15))))
  return(boltzmann.term * inactivation.term)
}

sharpeschoolhigh_1981.starting_vals <- function(d){
  # split data into post topt and pre topt
  post_topt <- d[d$x >= mean(d[d$y == max(d$y, na.rm = TRUE),'x']),]
  pre_topt <- d[d$x <= mean(d[d$y == max(d$y, na.rm = TRUE),'x']),]

  r_tref = mean(d$y, na.rm = TRUE)
  pre_topt$x2 <- 1/(8.62e-05*(pre_topt$x + 273.15))
  post_topt$x2 <- 1/(8.62e-05*(post_topt$x + 273.15))
  e <- suppressWarnings(tryCatch(stats::coef(stats::lm(log(y) ~ x2, pre_topt))[2][[1]] * -1, error = function(err) 0.6))
  eh = suppressWarnings(tryCatch(stats::coef(stats::lm(log(y) ~ x2, post_topt))[2][[1]], error = function(err) 5))
  th = mean(d[d$x >= mean(d[d$y == max(d$y, na.rm = TRUE),'x']), 'x'])
  return(c(r_tref = r_tref, e = e, eh = eh, th = th))
}

sharpeschoolhigh_1981.lower_lims <- function(d){
  r_tref = 0
  e = 0
  eh = 0
  th = min(d$x, na.rn = TRUE)
  return(c(r_tref = r_tref, e = e, eh = eh, th = th))
}

sharpeschoolhigh_1981.upper_lims <- function(d){
  r_tref = max(d$y, na.rm = TRUE)
  e = 10
  eh = 40
  th = max(d$x)
  return(c(r_tref = r_tref, e = e, eh = eh, th = th))
}
