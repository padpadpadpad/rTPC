#' Get a formula object for calling a TPC
#'
#' @param model_name the name of the model being fitted
#' @param temp the name of the temperature column
#' @param trait the name of the trait column
#' @param explicit whether to return the formula constructed using the explicit form of the tpc function (e.g. \code{rTPC::briere1_1999()})
#' 
#' @author Francis Windram
#' @return A formula calling the expected TPC
#' @concept helper
#' 
#' @examples
#' get_tpc_as_formula("briere1_1999", "temperature", "rate")
#' # > rate ~ briere1_1999(temp = temperature, tmin, tmax, a)
#' 
#' @export get_tpc_as_formula

get_tpc_as_formula <- function(model_name, temp, trait, explicit = FALSE){
  
  if (length(temp) != 1) {
    cli::cli_abort(c("x"="Supplied {.arg temp} is not a column name (contains {.val {length(temp)}} element{?s})"))
  }
  
  if (length(trait) != 1) {
    cli::cli_abort(c("x"="Supplied {.arg trait} is not a column name (contains {.val {length(trait)}} element{?s})"))
  }
  
  mod_names <- rTPC::get_model_names(returnall = TRUE)
  model_name <- tryCatch(rlang::arg_match(model_name, mod_names), error = function(e){
    cli::cli_abort(c("x"="Supplied {.arg model_name} ({.val {model_name}}) is not an available model in rTPC.",
                     "!"="Please check the spelling of {.arg model_name}.",
                     " "="(run {.fn rTPC::get_model_names} to see all valid names.)",
                     ""), call=rlang::caller_env(n=4))
  })
  
  tpcfunc <- get(model_name, envir = asNamespace("rTPC"))
  tpcargs <- names(formals(tpcfunc))
  
  if (explicit) {
    model <- paste0("rTPC::", model_name) 
  } else {
    model <- model_name
  }
  
  formulastr <- glue::glue("{trait}~{model}(temp = {temp}, {paste(tpcargs[tpcargs != 'temp'], collapse = ', ')})")
  return(stats::as.formula(formulastr))
}
