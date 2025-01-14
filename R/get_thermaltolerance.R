#' Estimate thermal tolerance of a thermal performance curve
#'
#' @param model nls model object that contains a model of a thermal performance curve
#' @details Thermal tolerance is calculated as: CTmax - CTmin. This is calculated using the functions \code{get_ctmax} and \code{get_ctmin}.
#' @return Thermal tolerance (in ºC)
#' @concept params
#' @export get_thermaltolerance

get_thermaltolerance <- function(model){

  ctmax <- rTPC::get_ctmax(model)
  ctmin <- rTPC::get_ctmin(model)
  return(ctmax - ctmin)
}

