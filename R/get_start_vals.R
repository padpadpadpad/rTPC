#' Estimate start values for TPC fitting
#'
#' @description Estimates sensible start values for fitting thermal performance curves
#' @param x vector of temperature values
#' @param y vector of rate values
#' @param model_name the name of the model being fitted
#' @author Daniel Padfield
#' @author Francis Windram
#' @return Named list of start parameters given the data and model being fitted
#' @concept helper
#' @export get_start_vals

get_start_vals <- function(x, y, model_name) {

  mod_names <- get_model_names(returnall = TRUE)
  model_name <- tryCatch(rlang::arg_match(model_name, mod_names), error = function(e){
    cli::cli_abort(c("x"="Supplied {.arg model_name} ({.val {model_name}}) is not an available model in rTPC.",
                     "!"="Please check the spelling of {.arg model_name}.",
                     " "="(run {.fn rTPC::get_model_names} to see all valid names.)",
                     ""), call=rlang::caller_env(n=4))
  })

  # make data frame
  d <- data.frame(x, y, stringsAsFactors = FALSE)
  d <- d[order(d$x),]

  start_vals <- tryCatch(do.call(paste0(model_name, ".starting_vals"), list(d=d)),
                         error = function(e){NULL})

  return(start_vals)
}
