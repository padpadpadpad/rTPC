#' Lists or searches the models available in rTPC
#' @param model Optional string (or vector of strings) representing model/s to search for.
#' @param returnall Also return the names of deprecated functions
#' @author Daniel Padfield
#' @author Francis Windram
#' @return character vector of thermal performance curves available in rTPC
#' @examples
#' get_model_names()
#' get_model_names("briere")
#' @export get_model_names

get_model_names <- function(model, returnall=FALSE){
  mod_names <- c(
    'sharpeschoolhigh_1981',
    'sharpeschoollow_1981',
    'sharpeschoolfull_1981',
    'johnsonlewin_1946',
    'lactin2_1995',
    'oneill_1972',
    'quadratic_2008',
    'ratkowsky_1983',
    'rezende_2019',
    'spain_1982',
    'thomas_2012',
    'thomas_2017',
    'weibull_1995',
    'kamykowski_1985',
    'joehnk_2008',
    'hinshelwood_1947',
    'gaussian_1987',
    'flinn_1991',
    'delong_2017',
    'briere1_1999',
    'briere1simplified_1999',
    'briere2_1999',
    'briere2simplified_1999',
    'briereextended_2021',
    'briereextendedsimplified_2021',
    'boatman_2017',
    'beta_2012',
    'gaussianmodified_2006',
    'pawar_2018',
    'lrf_1991',
    'deutsch_2008',
    'ashrafi1_2018',
    'ashrafi2_2018'
    'flextpc_2024',
    'atkin_2005',
    'eubank_1973',
    'analytiskontodimas_2004',
    'taylorsexton_1972',
    'janisch1_1925',
    'janisch2_1925',
    'betatypesimplified_2008',
    'warrendreyer_2006',
    'tomlinsonphillips_2015'
  )

  mod_deprecated <- c('modifiedgaussian_2006')

  if (returnall) {
    mod_names <- c(mod_names, mod_deprecated)
  }

  if (missing(model)) {
    return(sort(mod_names))
  } else {
    # 0.05 seems about the sweet spot for correcting errors while not spitting out everything all the time
    return(sort(unique(agrep(paste(model, collapse = "|"), mod_names, max.distance = 0.05, value = TRUE, fixed = FALSE))))
  }
}

