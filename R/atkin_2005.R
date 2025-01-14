#' Atkin model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param r0 scaling parameter, the minimum trait value
#' @param a arbitrary scaling parameter
#' @param b arbitrary scaling parameter
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @author Francis Windram
#' @references Atkin, OK, Bruhn D, Tjoelker MG. Response of Plant Respiration to Changes in Temperature: Mechanisms and Consequences of Variations in Q10 Values and Acclimation. In Plant Respiration. 2005.
#' @details Equation:
#' \deqn{rate = B_0 \cdot (a - b \cdot T)^{\frac{T}{10}}}{%
#' rate = B0.(a-b.T)^(T/10)}
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
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'atkin_2005')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~atkin_2005(temp = temp, r0, a, b),
#' data = d,
#' iter = 200,
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'atkin_2005'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'atkin_2005'),
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
#' @export atkin_2005

atkin_2005 <- function(temp, r0, a, b){
  est <-  r0 * (a - b * temp)^(temp/10)
  # FW: Slightly unsure why this is needed, but it at least forces better fits.
  # Technically it makes NAs return absurd values meaning that it's just a bad
  # fit, so the fitter runs away from it.
  if (any(is.na(est))) {
    return(rep(1e10, length(temp)))
  }
  return(est)
}

atkin_2005.starting_vals <- function(d){
  r0 = min(d$y, na.rm = TRUE)
  a = 3
  b = 0.05
  return(c(r0 = r0, a = a, b = b))
}

atkin_2005.lower_lims <- function(d){
  r0 = 0
  a = 0
  b = 0
  return(c(r0 = r0, a = a, b = b))
}

atkin_2005.upper_lims <- function(d){
  r0 = Inf
  a = Inf
  b = Inf
  return(c(r0 = r0, a = a, b = b))
}
