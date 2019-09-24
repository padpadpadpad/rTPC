#' Set uninformed lower limits on parameter values
#'
#' @description Sets wide lower limits on parameter values for each TPC model
#' @param x vector of temperature values
#' @param y vector of rate values
#' @param model_name the name of the model being fitted
#' @author Daniel Padfield
#'
#' @export get_lower_lims

get_lower_lims <- function(x, y, model_name) {

  # error message for wrong spelling of model name
  mod_names <- c('sharpeschoolhigh_1981', 'sharpeschoollow_1981', 'sharpeschoolfull_1981', 'johnsonlewin_1946', 'lactin2_1995', 'oneill_1972', 'quadratic_2008', 'ratkowsky_1983', 'rezende_2019', 'spain_1982', 'thomas_2012', 'thomas_2017', 'weibull_1995', 'kamykowski_1985', 'joehnk_2008', 'hinshelwood_1947', 'gaussian_1987', 'flinn_1991', 'delong_2017', 'briere2_1999', 'boatman_2017')

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
    b = 0
    q10 = 0
    a = 0
    c = 0

    return(c(q10 = q10, a = a, b = b, c = c))
  }

  if(model_name == 'sharpeschoolhigh_1981'){
    r_tref = 0
    e = 0
    eh = 0
    th = min(d$x, na.rn = TRUE)
    return(c(r_tref = r_tref, e = e, eh = eh, th = th))
  }

  if(model_name == 'sharpeschoolfull_1981'){
    r_tref = 0
    e = 0
    eh = 0
    th = min(d$x, na.rm = TRUE)
    tl = min(d$x, na.rm = TRUE)
    el = 0

    return(c(r_tref = r_tref, e = e, el = el, tl = tl, eh = eh, th = th))
  }

  if(model_name == 'sharpeschoollow_1981'){
    r_tref = 0
    e = 0
    tl = min(d$x, na.rm = TRUE)
    el = 0
    return(c(r_tref = r_tref, e = e, el = el, tl = tl))
  }

  if(model_name == 'boatman_2017'){
    rmax = min(d$y, na.rm = TRUE)
    tmin = 0
    tmax = min(d$x, na.rm = TRUE)
    a = 0
    b = 0
    return(c(rmax = rmax, tmin = tmin, tmax = tmax, a = a, b = b))
  }

}
