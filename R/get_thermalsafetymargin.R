#' Estimate thermal safety margin of a thermal performance curve
#'
#' @param model nls model object that contains a model of a thermal performance curve
#' @details Thermal safety margin is calculated as: CTmax - Topt. This is calculated using the functions \code{get_ctmax} and \code{get_topt}.
#' @return Numeric estimate of thermal safety margin (in ºC)
#'
#' @export get_thermalsafetymargin

get_thermalsafetymargin <- function(model){

  ctmax <- rTPC::get_ctmax(model)
  topt <- rTPC::get_topt(model)
  return(ctmax - topt)
}

