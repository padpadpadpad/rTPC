#' Lists the models available in rTPC
#'
#' @return character vector of thermal performance curves available in rTPC
#' @examples
#' get_model_names()
#' @export get_model_names

get_model_names <- function(){
  # Currently disabled: "mitchellangilletta_2009"
  mod_names <- c('sharpeschoolhigh_1981', 'sharpeschoollow_1981', 'sharpeschoolfull_1981', 'johnsonlewin_1946', 'lactin2_1995', 'oneill_1972', 'quadratic_2008', 'ratkowsky_1983', 'rezende_2019', 'spain_1982', 'thomas_2012', 'thomas_2017', 'weibull_1995', 'kamykowski_1985', 'joehnk_2008', 'hinshelwood_1947', 'gaussian_1987', 'flinn_1991', 'delong_2017', 'briere2_1999', 'boatman_2017', 'beta_2012', 'modifiedgaussian_2006', 'pawar_2018', 'lrf_1991', 'deutsch_2008', 'ashrafi1_2018', 'flextpc_2024', "atkin_2005")


  return(sort(mod_names))
}

