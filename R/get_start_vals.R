#' Estimate start values for TPC fitting
#'
#' @description Estimates sensible start values for fitting thermal performance curves
#' @param x vector of temperature values
#' @param y vector of rate values
#' @param model_name the name of the model being fitted
#' @author Daniel Padfield
#'
#' @export get_start_vals

get_start_vals <- function(x, y, model_name) {

  # make data frame
  d <- data.frame(x, y, stringsAsFactors = FALSE)

  # split data into post topt and pre topt
  post_topt <- d[d$x >= d[d$y == max(d$y, na.rm = TRUE),'x'],]
  pre_topt <- d[d$x <= d[d$y == max(d$y, na.rm = TRUE),'x'],]

  if(model_name == 'sharpeschoolhigh_1981'){
    r_tref = mean(d$y, na.rm = TRUE)
    pre_topt$x2 <- 1/(8.62e-05*pre_topt$x)
    post_topt$x2 <- 1/(8.62e-05*post_topt$x)
    e <- stats::coef(stats::lm(log(y) ~ x2, pre_topt))[2][[1]] * -1
    eh = stats::coef(stats::lm(log(y) ~ x2, post_topt))[2][[1]]
    th = mean(d[d$x >= d[d$y == max(d$y, na.rm = TRUE),'x'], 'x'])
    return(c(r_tref = r_tref, e = e, eh = eh, th = th))
    }
}
