#' Lists or searches the models available in rTPC
#' @param model Optional string (or vector of strings) representing model/s to search for.
#' @param returnall Also return the names of deprecated functions
#' @author Daniel Padfield
#' @author Francis Windram
#' @return character vector of thermal performance curves available in rTPC
#' @concept helper
#' @examples
#' get_model_names()
#' get_model_names("briere")
#' @export get_model_names

get_model_names <- function(model, returnall=FALSE){

  mod_names <- c("analytiskontodimas_2004",
                   "ashrafi1_2018",
                   "ashrafi2_2018",
                   "ashrafi3_2018",
                   "ashrafi4_2018",
                   "ashrafi5_2018",
                   "atkin_2005",
                   "beta_2012",
                   "betatypesimplified_2008",
                   "boatman_2017",
                   "briere1_1999",
                   "briere1simplified_1999",
                   "briere2_1999",
                   "briere2simplified_1999",
                   "briereextended_2021",
                   "briereextendedsimplified_2021",
                   "delong_2017",
                   "deutsch_2008",
                   "eubank_1973",
                   "flextpc_2024",
                   "flinn_1991",
                   "gaussian_1987",
                   "gaussianmodified_2006",
                   "hinshelwood_1947",
                   "janisch1_1925",
                   "janisch2_1925",
                   "joehnk_2008",
                   "johnsonlewin_1946",
                   "kamykowski_1985",
                   "lactin2_1995",
                   "lobry_1991",
                   "oneill_1972",
                   "pawar_2018",
                   "quadratic_2008",
                   "ratkowsky_1983",
                   "rezende_2019",
                   "rosso_1993",
                   "sharpeschoolfull_1981",
                   "sharpeschoolhigh_1981",
                   "sharpeschoollow_1981",
                   "spain_1982",
                   "stinner_1974",
                   "taylorsexton_1972",
                   "thomas_2012",
                   "thomas_2017",
                   "tomlinsonphillips_2015",
                   "warrendreyer_2006",
                   "weibull_1995")

  mod_deprecated <- c('modifiedgaussian_2006', 'lrf_1991')

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

