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

}
