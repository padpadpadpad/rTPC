#' Flinn model for fitting thermal performance curves
#'
#' @param temp temperature in degrees centigrade
#' @param a parameter that controls the height of the curve
#' @param b parameter that controls the slope of the initial increase of the curve
#' @param c parameter that controls the position and steepness of the decline of the curve
#' @return a numeric vector of rate values based on the temperatures and parameter values provided to the function
#' @references Flinn PW Temperature-dependent functional response of the parasitoid Cephalonomia waterstoni (Gahan) (Hymenoptera, Bethylidae) attacking rusty grain beetle larvae (Coleoptera, Cucujidae). Environmental Entomology, 20, 872–876, (1991)
#' @details Equation:
#' \deqn{rate= \frac{1}{1+a+b \cdot temp+c \cdot temp^2}}{%
#' rate = 1 / (1 + a + b.temp + c.temp^2)}
#'
#' Start values in \code{get_start_vals} are derived from previous methods from the literature.
#'
#' Limits in \code{get_lower_lims} and \code{get_upper_lims} are based on extreme values that are unlikely to occur in ecological settings.
#'
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
#' start_vals <- get_start_vals(d$temp, d$rate, model_name = 'flinn_1991')
#' # fit model
#' mod <- nls.multstart::nls_multstart(rate~flinn_1991(temp = temp, a, b, c),
#' data = d,
#' iter = c(4,4,4),
#' start_lower = start_vals - 1,
#' start_upper = start_vals + 1,
#' lower = get_lower_lims(d$temp, d$rate, model_name = 'flinn_1991'),
#' upper = get_upper_lims(d$temp, d$rate, model_name = 'flinn_1991'),
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
#' @export flinn_1991

flinn_1991 <- function(temp, a, b, c){
  est <- 1/(1 + a + b * temp + c * temp^2)
  return(est)
}

flinn_1991.starting_vals <- function(d){
  b = (-2*0.005*d$x[d$y==max(d$y)])[1]
  a = -min(b*d$x +0.005*(d$x^2))
  c = 1
  return(c(a = a, b = b, c = c))
}

flinn_1991.lower_lims <- function(d){
  # do not really have a scooby
  b = -100
  a = -100
  c = 0
  return(c(a = a, b = b, c = c))
}

flinn_1991.upper_lims <- function(d){
  # do not really have a scooby
  b = 100
  a = 500
  c = 10
  return(c(a = a, b = b, c = c))
}
