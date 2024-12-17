#' Set broad upper limits on parameter values
#'
#' @description Sets wide upper limits on parameter values for each TPC model
#' @param x vector of temperature values
#' @param y vector of rate values
#' @param model_name the name of the model being fitted
#' @author Daniel Padfield
#' @author Francis Windram
#' @return Named list of upper limits given the data and model being fitted
#' @export get_upper_lims

get_upper_lims <- function(x, y, model_name) {

  mod_names <- get_model_names()
  model_name <- tryCatch(rlang::arg_match(model_name, mod_names), error = function(e){
    cli::cli_abort(c("x"="Supplied {.arg model_name} ({.val {model_name}}) is not an available model in rTPC.",
                     "!"="Please check the spelling of {.arg model_name}.",
                     " "="(run {.fn rTPC::get_model_names} to see all valid names.)",
                     ""), call=rlang::caller_env(n=4))
  })

  # make data frame
  d <- data.frame(x, y, stringsAsFactors = FALSE)
  d <- d[order(d$x),]

  upper_lims <- tryCatch(do.call(paste0(model_name, ".upper_lims"), list(d=d)),
                         error = function(e){NULL})

  return(upper_lims)
}
