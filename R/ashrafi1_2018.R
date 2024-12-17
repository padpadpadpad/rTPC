#' Ashrafi1 model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param a dimensionless parameter
#' @param b dimensionless parameter
#' @param c dimensionless parameter
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @references Ashrafi, R. et al. Broad thermal tolerance is negatively correlated with virulence in an opportunistic bacterial pathogen. Evolutionary Applications 11, 1700–1714 (2018).
#' @details Equation:
#' \deqn{rate=a + b \cdot temp^{2} + log(temp) + c \cdot temp^{3}}{%
#' rate = a + b.temp^2 + log(temp) + c.temp^3}
#'
#' Start values in \code{get_start_vals} are derived from the data or sensible values from the literature.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are derived from the data or based extreme values that are unlikely to occur in ecological settings.
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
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'ashrafi1_2018')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~ashrafi1_2018(temp = temp, a, b, c),
#' data = d,
#' iter = c(4,4,4),
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'ashrafi1_2018'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'ashrafi1_2018'),
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
#' @export ashrafi1_2018

ashrafi1_2018 <- function(temp, a, b, c){
  est <- a + b*temp + log(temp) + c*temp^3
  return(est)
}

ashrafi1_2018.starting_vals <- function(d){
  a = min(d$y, na.rm = TRUE)
  b = 0.1
  c = 0.003

  return(c(a = a, b = b, c = c))
}

ashrafi1_2018.lower_lims <- function(d){
  a = -Inf
  b = -Inf
  c = -Inf

  return(c(a = a, b = b, c = c))
}

ashrafi1_2018.upper_lims <- function(d){
  a = Inf
  b = Inf
  c = Inf

  return(c(a = a, b = b, c = c))
}
