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

  # make data frame
  d <- data.frame(x, y, stringsAsFactors = FALSE)
  d <- d[order(d$x),]

  # split data into post topt and pre topt
  post_topt <- d[d$x >= d[d$y == max(d$y, na.rm = TRUE),'x'],]
  pre_topt <- d[d$x <= d[d$y == max(d$y, na.rm = TRUE),'x'],]

  if(model_name == 'rezende_2019'){
    b = max(d$x, na.rm = TRUE)
    q10 = 15
    a = 5 # max of data from paper was 1.7
    c = 0.05 # max of data from paper was 0.03034

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


}
