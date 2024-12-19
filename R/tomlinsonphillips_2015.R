#' Tomlinson-Phillips model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param a parameter similar to R at Tmin
#' @param b shape parameter indicating the slope of the upwards part of the curve
#' @param c peak position parameter, similar to Topt
#' @author Francis Windram
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @references Tomlinson, S. & Phillips, R. D. Differences in metabolic rate and evaporative water loss associated with sexual dimorphism in thynnine wasps. J. Insect Physiol. 78, 62–68 (2015).
#' @details Equation:
#' \deqn{rate = a \cdot [\exp{(b \cdot T) - \exp{(T-c)}}]}{%
#' rate = a . [e^(b . T) - e^(T-c)]}
#'
#' Start values in \code{get_start_vals} are derived from the data or sensible values from the literature.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are derived from the data or based extreme values that are unlikely to occur in ecological settings.
#'
#' @note Generally we found this model somewhat difficult to fit.
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
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'tomlinsonphillips_2015')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~tomlinsonphillips_2015(temp = temp, a, b, c),
#' data = d,
#' iter = c(3,3,3),
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'tomlinsonphillips_2015'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'tomlinsonphillips_2015'),
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
#' }
#' @export tomlinsonphillips_2015

tomlinsonphillips_2015 <- function(temp, a, b, c){
  est <- a * (exp((b * temp)) - exp((temp-c)))
  return(est)

}

tomlinsonphillips_2015.starting_vals <- function(d){
  # FW: This feels like it could be a bit fragile
  a =  min(d$y[d$x == min(d$x, na.rm = TRUE)], na.rm = TRUE)
  # FW: Kontopoulos derives a more complex estimate for b, but this seems more general
  b = 0.6
  rmax = max(d$y, na.rm = TRUE)
  topt = mean(d$x[d$y == rmax])
  c = topt
  return(c(a=a, b=b, c=c))
}

tomlinsonphillips_2015.lower_lims <- function(d){
  a = 0
  b = 0
  c = 0
  return(c(a=a, b=b, c=c))
}

tomlinsonphillips_2015.upper_lims <- function(d){
  a = Inf
  b = Inf
  c = 150
  return(c(a=a, b=b, c=c))
}
