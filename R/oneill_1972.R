#' O'Neill model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param rmax maximum rate at optimum temperature
#' @param ctmax high temperature (ºC) at which rates become negative
#' @param topt optimum temperature (ºC)
#' @param q10 defines the fold change in performance as a result of increasing the temperature by 10 ºC
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @details Equation:
#' \deqn{rate = r_{max} \cdot \bigg(\frac{ct_{max} - temp}{ct_{max} - t_{opt}}\bigg)^{x} \cdot exp^{x \cdot \frac{temp - t_{opt}}{ct_{max} - t_{opt}}}}{%
#' rate = rmax.(ctmax - temp / ctmax - topt)^2.exp(x.(temp-topt/ctmax-topt))}
#' \deqn{where: x = \frac{w^{2}}{400}\cdot\bigg(1 + \sqrt{1 + \frac{40}{w}}\bigg)^{2}}{%
#' where x = (w^2/400).(1 + sqrt(1+(40/w))^2)}
#' \deqn{and:\ w = (q_{10} - 1)\cdot (ct_{max} - t_{opt})}{%
#' and: w = (q10 - 1)*(ctmax - topt)}
#'
#' Start values in \code{get_start_vals} are derived from the data and previous values in the literature
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are based on extreme values that are unlikely to occur in ecological settings.
#'
#' @note Generally we found this model easy to fit.
#' @concept model
#' @references O’Neill, R.V., Goldstein, R.A., Shugart, H.H., Mankin, J.B. Terrestrial Ecosystem Energy Model. Eastern Deciduous Forest Biome Memo Report Oak Ridge. The Environmental Sciences Division of the Oak Ridge National Laboratory. (1972)
#' @examples
#' # load in ggplot
#' library(ggplot2)
#'
#' # subset for the first TPC curve
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'oneill_1972')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~oneill_1972(temp = temp, rmax, ctmax, topt, q10),
#' data = d,
#' iter = c(4,4,4,4),
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'oneill_1972'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'oneill_1972'),
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
#' @export oneill_1972

oneill_1972 <- function(temp, rmax, ctmax, topt, q10){
  est <- rmax * ((ctmax - temp)/(ctmax - topt))^(1/400 * ((q10 - 1)*(ctmax - topt))^2 * (1 + sqrt(1+(40/((q10 - 1)*(ctmax - topt)))))^2) * exp((1/400 * ((q10 - 1)*(ctmax - topt))^2 * (1 + sqrt(1+(40/((q10 - 1)*(ctmax - topt)))))^2)*(temp - topt)/(ctmax-topt))
  return(est)
}

oneill_1972.starting_vals <- function(d){
  rmax = max(d$y, na.rm = TRUE)
  topt = mean(d$x[d$y == rmax])
  ctmax = max(d$x, na.rm = TRUE)
  q10 = 1.7

  return(c(rmax = rmax, ctmax = ctmax, topt = topt, q10 = q10))
}

oneill_1972.lower_lims <- function(d){
  rmax = min(d$y, na.rm = TRUE)
  topt = min(d$x, na.rm = TRUE)
  ctmax = min(d$x, na.rm = TRUE)
  q10 = 0

  return(c(rmax = rmax, ctmax = ctmax, topt = topt, q10 = q10))
}

oneill_1972.upper_lims <- function(d){
  rmax = max(d$y, na.rm = TRUE) * 10
  topt = max(d$x, na.rm = TRUE)
  ctmax = max(d$x, na.rm = TRUE) * 10
  q10 = 10

  return(c(rmax = rmax, ctmax = ctmax, topt = topt, q10 = q10))
}
