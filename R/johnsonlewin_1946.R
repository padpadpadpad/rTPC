#' Johnson-Lewin model for fitting thermal performance curves
#'
#'
#' @param temp temperature in degrees centigrade
#' @param e activation energy (eV)
#' @param eh high temperature de-activation energy (eV)
#' @param topt optimum temperature (ºC)
#' @param r0 scaling parameter
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @references Johnson, Frank H., and Isaac Lewin. The growth rate of E. coli in relation to temperature, quinine and coenzyme. Journal of Cellular and Comparative Physiology 28.1 (1946): 47-75.
#' @details Equation:
#' \deqn{rate= \frac{r_0 \cdot exp^{\frac{-e}{k\cdot (temp + 273.15)}}}{1 + exp^{-\frac{e_h -\big(\frac{e_h}{(t_{opt} + 273.15)} + k \cdot ln\big(\frac{e}{e_h - e}\big) \big) \cdot (temp + 273.15)}{k \cdot (temp + 273.15)}}}}{%
#' rate = (r0.exp(-e/(k.(temp + 273.15)))) / ((1 + exp((-1/(k.(temp + 273.15)))* (eh - ((eh/(topt + 273.15)) + k.log(e/(eh - e))).(temp + 273.15)))))}
#'
#' where \code{k} is Boltzmann's constant with a value of 8.62e-05.
#'
#' Start values in \code{get_start_vals} are derived from the data.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are derived from the data or based  extreme values that are unlikely to occur in ecological settings.
#' @note Generally we found this model difficult to fit.
#' @examples
#' \donttest{
#' # load in ggplot
#' library(ggplot2)
#'
#' # subset for the first TPC curve
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'johnsonlewin_1946')
#' # fit model
#' mod <- suppressWarnings(
#' nls.multstart::nls_multstart(rate~johnsonlewin_1946(temp = temp, r0, e, eh, topt),
#' data = d,
#' iter = c(5,5,5,5),
#' start_lower = start_vals - 1,
#' start_upper = start_vals + 1,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'johnsonlewin_1946'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'johnsonlewin_1946'),
#' supp_errors = 'Y',
#' convergence_count = FALSE)
#' )
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
#'}
#' @export johnsonlewin_1946

johnsonlewin_1946 <- function(temp, r0, e, eh, topt){
  k <- 8.62e-05
  boltzmann.term <- r0*exp(-e/(k*(temp + 273.15)))
  inactivation.term <- 1/(1 + exp((-1/(k*(temp + 273.15))) * (eh - ((eh/(topt + 273.15)) + k*log(e/(eh - e)))*(temp + 273.15))))
  return(boltzmann.term * inactivation.term)
}

johnsonlewin_1946.starting_vals <- function(d){
  # split data into post topt and pre topt
  post_topt <- d[d$x >= mean(d[d$y == max(d$y, na.rm = TRUE),'x']),]
  pre_topt <- d[d$x <= mean(d[d$y == max(d$y, na.rm = TRUE),'x']),]

  r0 = min(d$y, na.rm = TRUE)
  pre_topt$x2 <- 1/(8.62e-05*(pre_topt$x + 273.15))
  post_topt$x2 <- 1/(8.62e-05*(post_topt$x + 273.15))
  e <- suppressWarnings(tryCatch(stats::coef(stats::lm(log(y) ~ x2, pre_topt))[2][[1]] * -1, error = function(err) 0.6))
  eh = suppressWarnings(tryCatch(stats::coef(stats::lm(log(y) ~ x2, post_topt))[2][[1]], error = function(err) 5))
  topt = mean(d$x[d$y == max(d$y, na.rm = TRUE)])
  return(c(r0 = r0, e = e, eh = eh, topt = topt))
}

johnsonlewin_1946.lower_lims <- function(d){
  r0 = min(d$y, na.rm = TRUE) / 100
  e = 0
  eh = 0
  topt = min(d$x, na.rm = TRUE)
  return(c(r0 = r0, e = e, eh = eh, topt = topt))
}

johnsonlewin_1946.upper_lims <- function(d){
  r0 = Inf
  e = 20
  eh = 40
  topt = max(d$x, na.rm = TRUE) * 10
  return(c(r0 = r0, e = e, eh = eh, topt = topt))
}
