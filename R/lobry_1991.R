#' Lobry model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param rmax the maximum rate
#' @param topt optimum temperature (ºC) at which rates are maximal
#' @param tmin low temperature (ºC) at which rates become negative
#' @param tmax high temperature (ºC) at which rates become negative
#' @author Daniel Padfield
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @references Lobry, J. R., Rosso, L., & Flandrois, J. P. (1991). A FORTRAN subroutine for the determination of parameter confidence limits in non-linear models. Binary, 3(86-93), 25.
#' @details Equation:
#' \deqn{rate = rmax \cdot (1 - \frac{(temp - topt)^2)}{(temp - topt)^2 + temp \cdot (tmax + tmin - temp) - tmax \cdot tmin}}{%
#' rate = rmax.(1 - (temp - topt)^2/((temp - topt)^2 + temp.(tmax + tmin - temp) - tmax.tmin))}
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
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'lobry_1991')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~lobry_1991(temp = temp, rmax, topt, tmin, tmax),
#' data = d,
#' iter = c(4,4,4,4),
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'lobry_1991'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'lobry_1991'),
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
#' @export lobry_1991

lobry_1991 <- function(temp, rmax, topt, tmin, tmax){

  result <- rmax * (1 - (((temp - topt)^2) / (((temp - topt)^2) + temp * (tmax + tmin - temp) - tmax * tmin)))

  if (tmin >= tmax || topt <= tmin || topt >= tmax || any(temp < tmin) || any(temp > tmax) || any(result <= 0))
  {
    return(rep(1e10, length(temp)))
  } else
  {
    return(result)
  }

}

lobry_1991.starting_vals <- function(d){
  rmax = max(d$y, na.rm = TRUE)
  topt = mean(d$x[d$y == rmax])
  tmin = min(d$x, na.rm = TRUE)
  tmax = max(d$x, na.rm = TRUE)

  return(c(rmax = rmax, topt = topt, tmin = tmin, tmax = tmax))
}

lobry_1991.lower_lims <- function(d){
  rmax = min(d$y, na.rm = TRUE)
  topt = min(d$x, na.rm = TRUE)
  tmin = min(d$x, na.rm = TRUE) - 50
  tmax = min(d$x, na.rm = TRUE)

  return(c(rmax = rmax, topt = topt, tmin = tmin, tmax = tmax))
}

lobry_1991.upper_lims <- function(d){
  rmax = max(d$y, na.rm = TRUE) * 10
  topt = max(d$x, na.rm = TRUE) * 2
  tmin = max(d$x, na.rm = TRUE)
  tmax = max(d$x, na.rm = TRUE) * 5

  return(c(rmax = rmax, topt = topt, tmin = tmin, tmax = tmax))
}
