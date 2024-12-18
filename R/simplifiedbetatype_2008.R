#' Simplified Beta-type model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param rho dimensionless parameter
#' @param alpha dimensionless parameter
#' @param beta dimensionless parameter
#' @author Francis Windram
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @references Damos, P. & Savopoulou-Soultani, M. Temperature-dependent bionomics and modeling of Anarsia lineatella (Lepidoptera: Gelechiidae) in the laboratory. J. Econ. Entomol. 101, 1557–1567 (2008).
#' @details Equation:
#' \deqn{rate = \rho \cdot \left(a - \frac{T}{10}\right) \cdot \left(\frac{T}{10}\right)^b}{%
#' rate = rho . (a - (T/10) . (T/10)^b)}
#'
#' Start values in \code{get_start_vals} are derived from the data or sensible values from the literature.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are derived from the data or based extreme values that are unlikely to occur in ecological settings.
#'
#' @note Generally we found this model easy to fit.
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
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'simplifiedbetatype_2008')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~simplifiedbetatype_2008(temp = temp, rho, alpha, beta),
#' data = d,
#' iter = c(7,7,7),
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'simplifiedbetatype_2008'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'simplifiedbetatype_2008'),
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
#' @export simplifiedbetatype_2008

simplifiedbetatype_2008 <- function(temp, rho, alpha, beta){
  est <- rho * (alpha - temp/10) * (temp/10)^beta
  return(est)

}

simplifiedbetatype_2008.starting_vals <- function(d){
  rho = 0.0012
  alpha = 4
  beta = 5
  return(c(rho=rho, alpha=alpha, beta=beta))
}

simplifiedbetatype_2008.lower_lims <- function(d){
  rho = 0
  alpha = 0
  beta = -Inf
  return(c(rho=rho, alpha=alpha, beta=beta))
}

simplifiedbetatype_2008.upper_lims <- function(d){
  rho = Inf
  alpha = Inf
  beta = Inf
  return(c(rho=rho, alpha=alpha, beta=beta))
}
