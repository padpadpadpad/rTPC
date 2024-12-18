#' Eubank model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param topt optimum temperature (ºC)
#' @param a scale parameter defining the height of the curve
#' @param b shape parameter of the curve
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @author Francis Windram
#' @references Eubank, W. P., Atmar, J. W. & Ellington, J. J. The significance and thermodynamics of fluctuating versus static thermal environments on Heliothis zea egg development rates. Environ. Entomol. 2, 491–496 (1973).
#' @details Equation:
#' \deqn{rate = \frac{a}{(T-T_{\text{opt}})^2+b}}{%
#' rate = a/((temp-topt)^2)+b}
#'
#' Start values in \code{get_start_vals} are derived from the data or sensible values from the literature.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are based on extreme values that are unlikely to occur in ecological settings.
#'
#' @note Generally we found this model easy to fit.
#' @examples
#' # load in ggplot
#' library(ggplot2)
#'
#' # subset for the first TPC curve
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'eubank_1973')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~eubank_1973(temp = temp, topt, a, b),
#' data = d,
#' iter = 200,
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'eubank_1973'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'eubank_1973'),
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
#' @export eubank_1973
eubank_1973 <- function(temp, topt, a, b){
  est <- a / ((temp - topt)^2 + b)
  return(est)
}

eubank_1973.starting_vals <- function(d){
  rmax = max(d$y, na.rm = TRUE)
  topt = mean(d$x[d$y == rmax])
  a = 300
  b = 50
  return(c(topt=topt, a=a, b=b))
}

eubank_1973.lower_lims <- function(d){
  topt = 0
  a = 0
  b = 0

  return(c(topt=topt, a=a, b=b))
}

eubank_1973.upper_lims <- function(d){
  topt = 150
  a = Inf
  b = Inf

  return(c(topt=topt, a=a, b=b))
}
