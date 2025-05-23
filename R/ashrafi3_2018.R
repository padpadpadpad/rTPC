#' Ashrafi III model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param a dimensionless parameter
#' @param b dimensionless parameter
#' @param c dimensionless parameter
#' @author Daniel Padfield
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @references Ashrafi, R. et al. Broad thermal tolerance is negatively correlated with virulence in an opportunistic bacterial pathogen. Evolutionary Applications 11, 1700–1714 (2018).
#' @details Equation:
#' \deqn{rate = \frac{1}{(a + b \cdot exp^{temp} + d \cdot exp^{-temp})}}{%
#' 1 / ( a + b.exp(temp) + d.exp(-temp) )}
#'
#' Start values in \code{get_start_vals} are derived from the data or sensible values from the literature.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are derived from the data or based extreme values that are unlikely to occur in ecological settings.
#' @note Generally we found this model easy to fit.
#' @concept model
#' @examples
#' # load in ggplot
#' library(ggplot2)
#'
#' # subset for the first TPC curve
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'ashrafi3_2018')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~ashrafi3_2018(temp = temp, a, b, c),
#' data = d,
#' iter = c(4,4,4),
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'ashrafi3_2018'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'ashrafi3_2018'),
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
#' @export ashrafi3_2018

ashrafi3_2018 <- function(temp, a, b, c){
  est <- 1 / ( a + b * exp(temp) + c * exp(-temp) )

  if ( any(est <= 0) || b == 0 || c == 0 )
  {
    return(rep(1e10, length(temp)))
  } else
  {
    return(est)
  }

}

ashrafi3_2018.starting_vals <- function(d){
  a = min(d$y, na.rm = TRUE)
  b = 0.1
  c = 0.003

  return(c(a = a, b = b, c = c))
}

ashrafi3_2018.lower_lims <- function(d){
  a = -Inf
  b = 0
  c = 0

  return(c(a = a, b = b, c = c))
}

ashrafi3_2018.upper_lims <- function(d){
  a = Inf
  b = Inf
  c = Inf

  return(c(a = a, b = b, c = c))
}
