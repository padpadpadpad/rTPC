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

  mod_names <- c('sharpeschoolhigh_1981', 'sharpeschoollow_1981', 'sharpeschoolfull_1981', 'johnsonlewin_1946', 'lactin2_1995', 'oneill_1972', 'quadratic_2008', 'ratkowsky_1983', 'rezende_2019', 'spain_1982', 'thomas_2012', 'thomas_2017', 'weibull_1995', 'kamykowski_1985', 'joehnk_2008', 'hinshelwood_1947', 'gaussian_1987', 'flinn_1991', 'delong_2017', 'briere2_1999', 'boatman_2017', 'beta_2012', 'modifiedgaussian_2006', 'pawar_2018', 'lrf_1991', 'deutsch_2008')

  if (model_name %in% mod_names == FALSE){
    stop("supplied model_name is not an available model in rTPC. Please check the spelling of model_name.")
  }

  # make data frame
  d <- data.frame(x, y, stringsAsFactors = FALSE)
  d <- d[order(d$x),]

  # split data into post topt and pre topt
  post_topt <- d[d$x >= mean(d[d$y == max(d$y, na.rm = TRUE),'x']),]
  pre_topt <- d[d$x <= mean(d[d$y == max(d$y, na.rm = TRUE),'x']),]

  if(model_name == 'sharpeschoolhigh_1981'){
    r_tref = mean(d$y, na.rm = TRUE)
    pre_topt$x2 <- 1/(8.62e-05*(pre_topt$x + 273.15))
    post_topt$x2 <- 1/(8.62e-05*(post_topt$x + 273.15))
    e <- suppressWarnings(tryCatch(stats::coef(stats::lm(log(y) ~ x2, pre_topt))[2][[1]] * -1, error = function(err) 0.6))
    eh = suppressWarnings(tryCatch(stats::coef(stats::lm(log(y) ~ x2, post_topt))[2][[1]], error = function(err) 5))
    th = mean(d[d$x >= mean(d[d$y == max(d$y, na.rm = TRUE),'x']), 'x'])
    return(c(r_tref = r_tref, e = e, eh = eh, th = th))
  }

  if(model_name == 'sharpeschoolfull_1981'){
    r_tref = mean(d$y, na.rm = TRUE)
    pre_topt$x2 <- 1/(8.62e-05*(pre_topt$x + 273.15))
    post_topt$x2 <- 1/(8.62e-05*(post_topt$x + 273.15))
    tl <- pre_topt$x[2]
    e <- suppressWarnings(tryCatch(stats::coef(stats::lm(log(y) ~ x2, pre_topt))[2][[1]] * -1, error = function(err) 0.6))
    eh = suppressWarnings(tryCatch(stats::coef(stats::lm(log(y) ~ x2, post_topt))[2][[1]], error = function(err) 5))
    el <- suppressWarnings(tryCatch(stats::coef(stats::lm(log(y) ~ x2, pre_topt[1:3,]))[2][[1]] * -1, error = function(err) 5))
    th = mean(d[d$x >= mean(d[d$y == max(d$y, na.rm = TRUE),'x']), 'x'])
    return(c(r_tref = r_tref, e = e, el = el, tl = tl, eh = eh, th = th))
  }

  if(model_name == 'sharpeschoollow_1981'){
    r_tref = mean(d$y, na.rm = TRUE)
    pre_topt$x2 <- 1/(8.62e-05*(pre_topt$x + 273.15))
    post_topt$x2 <- 1/(8.62e-05*(post_topt$x + 273.15))
    e <- suppressWarnings(tryCatch(stats::coef(stats::lm(log(y) ~ x2, pre_topt))[2][[1]] * -1, error = function(err) 0.6))
    el <- suppressWarnings(tryCatch(stats::coef(stats::lm(log(y) ~ x2, pre_topt[1:3,]))[2][[1]] * -1, error = function(err) 5))
    tl <- pre_topt$x[2]
    return(c(r_tref = r_tref, e = e, el = el, tl = tl))
  }

  if(model_name == 'briere2_1999'){
    tmin = min(d$x, na.rm = TRUE)
    tmax = max(d$x, na.rm = TRUE)
    b = 3
    a = 2 * 10^-4
    return(c(tmin = tmin, tmax = tmax, a = a, b = b))
  }

  if(model_name == 'thomas_2012'){
    c = max(d$x, na.rm = TRUE) - min(d$x, na.rm = TRUE)
    b = 0
    topt = mean(d$x[d$y==max(d$y, na.rm = TRUE)])
    a = max(d$y)/max(exp(b*d$x)*(1-((d$x-topt)/(c/2))^2))
    return(c(a = a, b = b, c = c, topt = topt))
  }

  if(model_name == 'ratkowsky_1983'){
    tmin = min(d$x, na.rm = TRUE)
    tmax = max(d$x, na.rm = TRUE)
    a = 1
    b = 0.1
    return(c(tmin = tmin, tmax = tmax, a = a, b = b))
  }

  if(model_name == 'quadratic_2008'){
    b = (-2*-0.005*max(d$y, na.rm = TRUE))
    a = max(d$y, na.rm = TRUE) - max(b*d$x - 0.005*(d$x^2), na.rm = TRUE)
    c = -2
    return(c(a = a, b = b, c = c))
  }

  if(model_name == 'lactin2_1995'){
    tmax = max(d$x, na.rm = TRUE)
    delta_t = mean(tmax - d$x[d$y == max(d$y, na.rm = TRUE)])
    a = 0.1194843
    b = -0.254008

    return(c(a = a, b = b, tmax = tmax, delta_t = delta_t))
  }


  if(model_name == 'gaussian_1987'){
    rmax = max(d$y, na.rm = TRUE)
    topt = mean(d$x[d$y == rmax])
    a = max(d$x, na.rm = TRUE) - min(d$x, na.rm = TRUE)

    return(c(rmax = rmax, topt = topt, a = a))
  }


  if(model_name == 'rezende_2019'){
    b = mean(d[d$x == mean(d[d$y == max(d$y, na.rm = TRUE),'x']),]$x)
    q10 = 2.77
    a = 0.0577
    c = 0.003

    return(c(q10 = q10, a = a, b = b, c = c))
  }

  if(model_name == 'delong_2017'){
    c =  14.45
    eb = 0.58
    ef = 2.215
    fit <- suppressWarnings(stats::lm(log(y) ~ x+I(x^2), post_topt))
    roots <- suppressWarnings(polyroot(stats::coef(fit)))
    tm = suppressWarnings(as.numeric(max(Re(roots))))
    ehc = 0.085

    return(c(c = c, eb = eb, ef = ef, tm = tm, ehc = ehc))
  }

  if(model_name == 'thomas_2017'){
    a = 1.174
    b = 0.064
    c = 1.119
    d = 0.267
    e = 0.103
    return(c(a=a, b=b, c=c, d=d, e=e))
  }


  if(model_name == 'boatman_2017'){
    rmax = max(d$y, na.rm = TRUE)
    tmin = min(d$x, na.rm = TRUE)
    tmax = max(d$x, na.rm = TRUE)
    a = 1.1
    b = 0.4
    return(c(rmax = rmax, tmin = tmin, tmax = tmax, a = a, b = b))
  }

  if(model_name == 'flinn_1991'){

    b = (-2*0.005*d$x[d$y==max(d$y)])[1]
    a = -min(b*d$x +0.005*(d$x^2))
    c = 1
    return(c(a = a, b = b, c = c))
  }

  if(model_name == 'joehnk_2008'){

    rmax = max(d$y, na.rm = TRUE)
    topt = mean(d$x[d$y == rmax])
    a = mean(c(5.77, 4.68, 18.61))
    b = mean(c(1.30,1.02,1.02))
    c = mean(c(1.37,1.15,1.04))

    return(c(rmax = rmax, topt = topt, a = a, b = b, c = c))
  }

  if(model_name == 'oneill_1972'){

    rmax = max(d$y, na.rm = TRUE)
    topt = mean(d$x[d$y == rmax])
    ctmax = max(d$x, na.rm = TRUE)
    q10 = 1.7

    return(c(rmax = rmax, ctmax = ctmax, topt = topt, q10 = q10))
  }

  if(model_name == 'kamykowski_1985'){

    tmin = min(d$x, na.rm = TRUE)
    tmax = max(d$x, na.rm = TRUE)
    a = 1.242143
    b = 0.5882857
    c = 1.238821

    return(c(tmin = tmin, tmax = tmax, a=a, b=b, c=c))
  }


  if(model_name == 'hinshelwood_1947'){
    a = 595892892
    b = 1.57e+30
    e = 0.5125673
    eh = 1.922022
    return(c(a=a, e=e, b=b, eh = eh))}

  if(model_name == 'beta_2012'){
    a = max(d$y, na.rm = TRUE)
    b = mean(d$x[d$y == max(d$y, na.rm = TRUE)])
    c = mean(d$x[d$y == max(d$y, na.rm = TRUE)])
    d = 2
    e = 2
    return(c(a=a, b=b, c=c, d=d, e=e))}

  if(model_name == 'modifiedgaussian_2006'){
    rmax = max(d$y, na.rm = TRUE)
    topt = mean(d$x[d$y == rmax])
    a = (max(d$x, na.rm = TRUE) - min(d$x, na.rm = TRUE))/2
    b = 2

    return(c(rmax = rmax, topt = topt, a = a, b=b))
  }

  if(model_name == 'weibull_1995'){
    a = mean(d$y, na.rm = TRUE)
    topt = mean(d$x[d$y == max(d$y, na.rm = TRUE)])
    b = max(d$x, na.rm = TRUE) - min(d$x, na.rm = TRUE)
    c = 4

    return(c(a = a, topt = topt, b=b,c=c))
  }

  if(model_name == 'johnsonlewin_1946'){
    r0 = min(d$y, na.rm = TRUE)
    pre_topt$x2 <- 1/(8.62e-05*(pre_topt$x + 273.15))
    post_topt$x2 <- 1/(8.62e-05*(post_topt$x + 273.15))
    e <- suppressWarnings(tryCatch(stats::coef(stats::lm(log(y) ~ x2, pre_topt))[2][[1]] * -1, error = function(err) 0.6))
    eh = suppressWarnings(tryCatch(stats::coef(stats::lm(log(y) ~ x2, post_topt))[2][[1]], error = function(err) 5))
    topt = mean(d$x[d$y == max(d$y, na.rm = TRUE)])
    return(c(r0 = r0, e = e, eh = eh, topt = topt))
  }

  if(model_name == 'spain_1982'){
    r0 = min(d$y, na.rm = TRUE)
    a = 0
    b = 0
    c = 0
    return(c(a = a, b = b, c = c, r0 = r0))
  }

  if(model_name == 'pawar_2018'){
    r_tref = mean(d$y, na.rm = TRUE)
    pre_topt$x2 <- 1/(8.62e-05*(pre_topt$x + 273.15))
    post_topt$x2 <- 1/(8.62e-05*(post_topt$x + 273.15))
    e <- suppressWarnings(tryCatch(stats::coef(stats::lm(log(y) ~ x2, pre_topt))[2][[1]] * -1, error = function(err) 0.6))
    eh = suppressWarnings(tryCatch(stats::coef(stats::lm(log(y) ~ x2, post_topt))[2][[1]], error = function(err) 5))
    topt = mean(d$x[d$y == max(d$y, na.rm = TRUE)])
    return(c(r_tref = r_tref, e = e, eh = eh, topt = topt))
  }

  if(model_name == 'lrf_1991'){
    rmax = max(d$y, na.rm = TRUE)
    topt = mean(d$x[d$y == rmax])
    tmin = min(d$x, na.rm = TRUE)
    tmax = max(d$x, na.rm = TRUE)

    return(c(rmax = rmax, topt = topt, tmin = tmin, tmax = tmax))
  }

  if(model_name == 'deutsch_2008'){
    rmax = max(d$y, na.rm = TRUE)
    topt = mean(d$x[d$y == rmax])
    ctmax = max(d$x, na.rm = TRUE)
    # use the width of the temperatures measured divided by 5. Somewhat arbritary
    a = (max(d$x, na.rm = TRUE) - min(d$x, na.rm = TRUE))/5

    return(c(rmax = rmax, topt = topt, ctmax = ctmax, a = a))
  }


}
