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
  d <- d[order(d$x),]

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

  if(model_name == 'sharpeschoolfull_1981'){
    r_tref = mean(d$y, na.rm = TRUE)
    pre_topt$x2 <- 1/(8.62e-05*pre_topt$x)
    post_topt$x2 <- 1/(8.62e-05*post_topt$x)
    e <- stats::coef(stats::lm(log(y) ~ x2, pre_topt))[2][[1]] * -1
    el <- stats::coef(stats::lm(log(y) ~ x2, pre_topt[1:3,]))[2][[1]] * -1
    tl <- pre_topt$x[2]
    eh = stats::coef(stats::lm(log(y) ~ x2, post_topt))[2][[1]]
    th = mean(d[d$x >= d[d$y == max(d$y, na.rm = TRUE),'x'], 'x'])
    return(c(r_tref = r_tref, e = e, el = el, tl = tl, eh = eh, th = th))
  }

  if(model_name == 'sharpeschoollow_1981'){
    r_tref = mean(d$y, na.rm = TRUE)
    pre_topt$x2 <- 1/(8.62e-05*pre_topt$x)
    post_topt$x2 <- 1/(8.62e-05*post_topt$x)
    e <- stats::coef(stats::lm(log(y) ~ x2, pre_topt))[2][[1]] * -1
    el <- stats::coef(stats::lm(log(y) ~ x2, pre_topt[1:3,]))[2][[1]] * -1
    tl <- pre_topt$x[2]
    return(c(r_tref = r_tref, e = e, el = el, tl = tl))
  }

  if(model_name == 'briere2_1999'){
    tmin = min(d$x, na.rm = TRUE)
    tmax = max(d$x, na.rm = TRUE)
    b = 2
    a = 1 * 10^-4
    return(c(tmin = tmin, tmax = tmax, a = a, b = b))
  }

  if(model_name == 'thomas_2012'){
    c = max(d$x, na.rm = TRUE) - min(d$x, na.rm = TRUE)
    b = 0
    topt = d$x[d$y==max(d$y, na.rm = TRUE)]
    a = max(d$y)/max(exp(b*d$x)*(1-((d$x-topt)/(c/2))^2))
    return(c(a = a, b = b, c = c, topt = topt))
  }

}
