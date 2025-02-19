#' Rosso model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param rmax maximum rate at optimum temperature
#' @param topt optimum temperature (ºC)
#' @param tmin low temperature (ºC) at which rates become negative
#' @param tmax high temperature (ºC) at which rates become negative
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @author Daniel Padfield
#' @references Rosso, L., Lobry, J. R., & Flandrois, J. P.  An unexpected correlation between cardinal temperatures of microbial growth highlighted by a new model. Journal of Theoretical Biology, 162(4), 447-463. (1993)
#' @details Equation:
#' \deqn{rate=  rmax \cdot \frac{(temp - t_{max}) \cdot (temp - t_{min})^2}{(t_{opt} - t_{min}) \cdot ((t_{opt} - t_{min}) \cdot (temp - t_{opt}) - (t_{opt} - t_{max}) \cdot (t_{opt} + t_{min} - 2 \cdot temp))}}{%
#' rate = rmax * ((temp - tmax)(temp - tmin))^2 / ((topt - tmin)((topt - tmin)(temp - topt) - (topt - tmax)(topt + tmin - 2.temp)))}
#'
#' Start values in \code{get_start_vals} are derived from the data.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are derived from the data or based  extreme values that are unlikely to occur in ecological settings.
#' @note Generally we found this model easy to fit.
#' @concept model
#' @examples
#' # load in ggplot
#' library(ggplot2)
#' library(nls.multstart)
#'
#' # subset for the first TPC curve
#' data('chlorella_tpc')
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' # get start values and fit model
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'rosso_1993')
#' # fit model
#' mod <- nls_multstart(rate~lrf_1991(temp = temp, rmax, topt, tmin, tmax),
#' data = d,
#' iter = c(3,3,3,3),
#' start_lower = start_vals - 10,
#' start_upper = start_vals + 10,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'rosso_1993'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'rosso_1993'),
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
#' @export rosso_1993 lrf_1991
#' @aliases lrf_1991

rosso_1993 <- function(temp, rmax, topt, tmin, tmax){
  return(rmax*((temp - tmax)*(temp - tmin)^2) / ((topt - tmin) * (((topt - tmin)*(temp - topt))-((topt-tmax)*(topt+tmin-2*temp)))))
  }

rosso_1993.starting_vals <- function(d){
  rmax = max(d$y, na.rm = TRUE)
  topt = mean(d$x[d$y == rmax])
  tmin = min(d$x, na.rm = TRUE)
  tmax = max(d$x, na.rm = TRUE)

  return(c(rmax = rmax, topt = topt, tmin = tmin, tmax = tmax))
}

rosso_1993.lower_lims <- function(d){
  rmax = min(d$y, na.rm = TRUE)
  topt = min(d$x, na.rm = TRUE)
  tmin = min(d$x, na.rm = TRUE) - 50
  tmax = min(d$x, na.rm = TRUE)

  return(c(rmax = rmax, topt = topt, tmin = tmin, tmax = tmax))
}

rosso_1993.upper_lims <- function(d){
  rmax = max(d$y, na.rm = TRUE) * 10
  topt = max(d$x, na.rm = TRUE)
  tmin = max(d$x, na.rm = TRUE)
  tmax = max(d$x, na.rm = TRUE) * 10

  return(c(rmax = rmax, topt = topt, tmin = tmin, tmax = tmax))
}


# deprecated function name



lrf_1991 <- function(temp, rmax, topt, tmin, tmax){
  return(rmax*((temp - tmax)*(temp - tmin)^2) / ((topt - tmin) * (((topt - tmin)*(temp - topt))-((topt-tmax)*(topt+tmin-2*temp)))))
}

lrf_1991.starting_vals <- function(d){
  rmax = max(d$y, na.rm = TRUE)
  topt = mean(d$x[d$y == rmax])
  tmin = min(d$x, na.rm = TRUE)
  tmax = max(d$x, na.rm = TRUE)

  # Warn every 8 hours here so it doesn't slow down fitting too much
  cli::cli_warn(c("{.fn lrf_1991} has been replaced with {.fn rosso_1993} and will be removed.", "!"="Please modify your code accordingly"), .frequency="regularly", .frequency_id="lrf_rosso")
  return(rosso_1993.starting_vals(d=d))

}

lrf_1991.lower_lims <- function(d){
  rmax = min(d$y, na.rm = TRUE)
  topt = min(d$x, na.rm = TRUE)
  tmin = min(d$x, na.rm = TRUE) - 50
  tmax = min(d$x, na.rm = TRUE)

  return(c(rmax = rmax, topt = topt, tmin = tmin, tmax = tmax))
}

lrf_1991.upper_lims <- function(d){
  rmax = max(d$y, na.rm = TRUE) * 10
  topt = max(d$x, na.rm = TRUE)
  tmin = max(d$x, na.rm = TRUE)
  tmax = max(d$x, na.rm = TRUE) * 10

  return(c(rmax = rmax, topt = topt, tmin = tmin, tmax = tmax))
}
