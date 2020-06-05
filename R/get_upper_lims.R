#' Set uninformed upper limits on parameter values
#'
#' @description Sets wide upper limits on parameter values for each TPC model
#' @param x vector of temperature values
#' @param y vector of rate values
#' @param model_name the name of the model being fitted
#' @author Daniel Padfield
#'
#' @export get_upper_lims

get_upper_lims <- function(x, y, model_name) {

  # error message for wrong spelling of model name
  mod_names <- c('sharpeschoolhigh_1981', 'sharpeschoollow_1981', 'sharpeschoolfull_1981', 'johnsonlewin_1946', 'lactin2_1995', 'oneill_1972', 'quadratic_2008', 'ratkowsky_1983', 'rezende_2019', 'spain_1982', 'thomas_2012', 'thomas_2017', 'weibull_1995', 'kamykowski_1985', 'joehnk_2008', 'hinshelwood_1947', 'gaussian_1987', 'flinn_1991', 'delong_2017', 'briere2_1999', 'boatman_2017', 'beta_2012', 'modifiedgaussian_2006')

  if (model_name %in% mod_names == FALSE){
    stop("supplied model_name is not an available model in rTPC. Please check the spelling of model_name.")
  }

  # make data frame
  d <- data.frame(x, y, stringsAsFactors = FALSE)
  d <- d[order(d$x),]

  # split data into post topt and pre topt
  post_topt <- d[d$x >= d[d$y == max(d$y, na.rm = TRUE),'x'],]
  pre_topt <- d[d$x <= d[d$y == max(d$y, na.rm = TRUE),'x'],]

  if(model_name == 'rezende_2019'){
    b = max(d$x, na.rm = TRUE)
    q10 = 15
    a = 10 # max of data from paper was 1.7
    c = 1 # max of data from paper was 0.03034

    return(c(q10 = q10, a = a, b = b, c = c))
  }

  if(model_name == 'sharpeschoolhigh_1981'){
    r_tref = max(d$y, na.rm = TRUE)
    e = 10
    eh = 20
    th = max(d$x)
    return(c(r_tref = r_tref, e = e, eh = eh, th = th))
  }

  if(model_name == 'sharpeschoolfull_1981'){
    r_tref = max(d$y, na.rm = TRUE)
    e = 10
    eh = 20
    th = max(d$x, na.rm = TRUE)
    tl = d[d$y == max(d$y, na.rm = TRUE),]$x
    el = 20

    return(c(r_tref = r_tref, e = e, el = el, tl = tl, eh = eh, th = th))
  }

  if(model_name == 'sharpeschoollow_1981'){
    r_tref = max(d$y, na.rm = TRUE)
    e = 10
    tl = d[d$y == max(d$y, na.rm = TRUE),]$x
    el = 20
    return(c(r_tref = r_tref, e = e, el = el, tl = tl))
  }

  if(model_name == 'boatman_2017'){
    rmax = max(d$y, na.rm = TRUE) * 10
    tmin = max(d$x, na.rm = TRUE)
    tmax = max(d$x, na.rm = TRUE) * 10
    a = 10
    b = 10
    return(c(rmax = rmax, tmin = tmin, tmax = tmax, a = a, b = b))
  }

  if(model_name == 'thomas_2012'){
    topt = max(d$x, na.rm = TRUE) * 10
    c = max(d$x, na.rm = TRUE) - max(d$x, na.rm = TRUE) * 10
    a = 10
    b = 10
    return(c(a = a, b = b, c = c, topt = topt))
  }

  if(model_name == 'briere2_1999'){
    tmin = max(d$x, na.rm = TRUE)
    tmax = max(d$x, na.rm = TRUE) * 10
    b = 10
    a = 10^-2
    return(c(tmin = tmin, tmax = tmax, a = a, b = b))
  }

  if(model_name == 'lactin2_1995'){
    tmax = max(d$x, na.rm = TRUE) *10
    delta_t = tmax - d$x[d$y == max(d$y, na.rm = TRUE)] *10
    a = 1
    b = 1

    return(c(a = a, b = b, tmax = tmax, delta_t = delta_t))
  }

  # do not really have a scooby
  if(model_name == 'flinn_1991'){

    b = 100
    a = 100
    c = 10
    return(c(a = a, b = b, c = c))
  }

  if(model_name == 'gaussian_1987'){
    rmax = max(d$y, na.rm = TRUE) * 10
    topt = max(d$x, na.rm = TRUE)
    a = (max(d$x, na.rm = TRUE) - min(d$x, na.rm = TRUE)) * 10

    return(c(rmax = rmax, topt = topt, a = a))
  }

  if(model_name == 'modifiedgaussian_2006'){
    rmax = max(d$y, na.rm = TRUE) * 10
    topt = max(d$x, na.rm = TRUE)
    a = (max(d$x, na.rm = TRUE) - min(d$x, na.rm = TRUE)) * 10
    b = 10

    return(c(rmax = rmax, topt = topt, a = a, b=b))
  }

  if(model_name == 'joehnk_2008'){

    rmax = max(d$y, na.rm = TRUE) * 10
    topt = max(d$x, na.rm = TRUE)
    a = 100
    b = 10
    c = 10

    return(c(rmax = rmax, topt = topt, a = a, b = b, c = c))
  }

  if(model_name == 'oneill_1972'){

    rmax = max(d$y, na.rm = TRUE) * 10
    topt = max(d$x, na.rm = TRUE)
    ctmax = max(d$x, na.rm = TRUE) * 10
    q10 = 10

    return(c(rmax = rmax, ctmax = ctmax, topt = topt, q10 = q10))
  }

  if(model_name == 'ratkowsky_1983'){
    tmin = max(d$x, na.rm = TRUE)
    tmax = max(d$x, na.rm = TRUE) * 10
    a = 1 *100
    b = 0.1 * 100
    return(c(tmin = tmin, tmax = tmax, a = a, b = b))
  }

  if(model_name == 'kamykowski_1985'){

    tmin = max(d$x, na.rm = TRUE)
    tmax = max(d$x, na.rm = TRUE) * 10
    a = 20
    b = 20
    c = 20

    return(c(tmin = tmin, tmax = tmax, a=a, b=b, c=c))
  }

  if(model_name == 'hinshelwood_1947'){
    a = 1e50
    b = 1e100
    e = 10
    eh = 30
    return(c(a=a, e=e, b=b, eh = eh))}

  if(model_name == 'beta_2012'){
    a = a = max(d$y, na.rm = TRUE) *100
    b = d$x[d$y == max(d$y, na.rm = TRUE)]*10
    c = d$x[d$y == max(d$y, na.rm = TRUE)]*10
    d = 100
    e = 100
    return(c(a=a, b=b, c=c, d=d, e=e))}

  if(model_name == 'weibull_1995'){
    a = max(d$y, na.rm = TRUE) * 100
    topt = max(d$x, na.rm = TRUE)
    b = max(d$x, na.rm = TRUE) - min(d$x, na.rm = TRUE) * 100
    c = 100
    return(c(a=a, topt = topt, b=b, c=c))}

  if(model_name == 'delong_2017'){
    c =  14.45 * 100
    eb = 0.58 * 100
    ef = 2.215 * 100
    ehc = 0.085 * 100
    tm = max(d$x, na.rm = TRUE) * 100

    return(c(c = c, eb = eb, ef = ef, tm = tm, ehc = ehc))
  }

  if(model_name == 'johnsonlewin_1946'){
    r0 = max(d$y, na.rm = TRUE) / 100
    e = 20
    eh = 40
    topt = max(d$x, na.rm = TRUE) * 10
    return(c(r0 = r0, e = e, eh = eh, topt = topt))
  }

  if(model_name == 'quadratic_2008'){
    b = (-2*-0.005*max(d$y, na.rm = TRUE)) * 100
    a = max(d$y, na.rm = TRUE) - max(b*d$x - 0.005*(d$x^2), na.rm = TRUE) * 100
    c = 10
    return(c(a = a, b = b, c = c))
  }

  if(model_name == 'spain_1982'){
    r0 = max(d$y, na.rm = TRUE)
    a = 2
    b = 2
    c = 2
    return(c(a = a, b = b, c = c, r0 = r0))
  }
}
