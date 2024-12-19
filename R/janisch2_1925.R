#' Janisch II model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param m scale parameter (controlling the height of the curve)
#' @param a shape parameter (controlling the shape of the rising part of the curve)
#' @param b shape parameter (controlling the shape of the falling part of the curve)
#' @param topt temperature of max performance (ºC)
#' @author Francis Windram
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @references Janisch, E. Über die Temperaturabhängigkeit biologischer Vorgänge und ihre kurvenmäßige Analyse. Pflüger's Arch. Physiol. 209, 414–436 (1925).
#' @details Equation:
#' \deqn{rate = \frac{1}{\frac{m}{2} \cdot \left[a^{T-T_{\text{opt}}}+b^{-(T-T_{\text{opt}})}\right]}}{%
#' rate = 1/((m/2) . [a^(T-Topt)+b^-(T-Topt)])}
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
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'janisch2_1925')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~janisch2_1925(temp = temp, m, a, b, topt),
#' data = d,
#' iter = 200,
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'janisch2_1925'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'janisch2_1925'),
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
#' @export janisch2_1925
janisch2_1925 <- function(temp, m, a, b, topt){
  est <- 1 / ((m/2) * (a^(temp - topt) + b^(-(temp - topt))))
  return(est)
}

janisch2_1925.starting_vals <- function(d){
  m = 3
  a = 0.3
  b = 0.3  # Not specified in Kontopoulos
  rmax = max(d$y, na.rm = TRUE)
  topt = mean(d$x[d$y == rmax])

  return(c(m=m, a=a, b=b, topt=topt))
}

janisch2_1925.lower_lims <- function(d){
  m = 0
  a = 0
  b = 0
  topt = 0

  return(c(m=m, a=a, b=b, topt=topt))
}

janisch2_1925.upper_lims <- function(d){
  m = Inf
  a = Inf
  b = Inf
  topt = 150

  return(c(m=m, a=a, b=b, topt=topt))
}
