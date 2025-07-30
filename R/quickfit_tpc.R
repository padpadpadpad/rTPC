#' Perform a quick tpc fit
#'
#' @description Performs a simple TPC fit using \code{\link[nls.multstart]{nls_multstart}}. This function tries to use a sensible default configuration, 
#' however if you need to use the more esoteric elements of \code{\link[nls.multstart]{nls_multstart}} then you will need to construct your own.
#' @param data the data to fit a model to
#' @param model_name the model name as a string
#' @param temp the column name (as a string) containing the temperature data
#' @param trait the column name (as a string) containing the temperature data
#' @param start_adjusts any adjustments to make to the lower and upper starting bounds. If \code{0 < start_adjusts < 1}, this will be interpreted as a proportion of the base starting values.
#' @param iter number of combinations of starting parameters which will be tried (as in \code{\link[nls.multstart]{nls_multstart}})
#' @param lhstype method to use for Latin Hypercube Sampling using \code{\link[lhs]{lhs}} (as in \code{\link[nls.multstart]{nls_multstart}})
#' @param gridstart whether to run a gridstart approach (interpreting iter as the number of samples to take across each parameter, 
#' so \code{3} will become \code{c(3,3,3)} for a 3-parameter model)
#' @param force whether to force a gridstart even with very large numbers of iterations
#' @author Francis Windram
#' @return The nls model object of the fit model
#' @concept helper
#' 
#' @examples
#' \dontrun{
#' data("chlorella_tpc")
#' subs <- subset(chlorella_tpc, curve_id == 1)
#' quickfit_tpc(subs, "briere1_1999", "temp", "rate")
#' 
#' quickfit_tpc(
#'   subs,
#'   "briere1_1999",
#'   "temp",
#'   "rate",
#'   start_adjusts = 10,
#'   iter = 150,
#'   lhstype = "maximin"
#' )
#' 
#' quickfit_tpc(
#'   subs,
#'   "briere1_1999",
#'   "temp",
#'   "rate",
#'   start_adjusts = 10,
#'   iter = 5,
#'   gridstart = TRUE
#' )
#' }
#' 
#' @export quickfit_tpc


quickfit_tpc <- function(data, model_name, temp, trait, start_adjusts = 0, iter = 150, lhstype = "none", gridstart=FALSE, force=FALSE) {
  
  rlang::check_installed("nls.multstart")
  
  # The form of column extraction used below only works properly on dfs.
  data <- as.data.frame(data)
  
  start_vals <- rTPC::get_start_vals(data[,temp], data[,trait], model_name = model_name)
  
  if (0 < start_adjusts && start_adjusts < 1) {
    start_adjusts <- start_vals * start_adjusts
  }
  
  if (gridstart){
    iter <- rep(iter, length(start_vals))
    total_iterations <- prod(iter)
    if (total_iterations > 1500 && !force) {
      cli::cli_abort(c(
        "x"="Massive gridstart detected! ({.val {total_iterations}} iterations)",
        "!"="If this is intended, set force={.val {TRUE}}, else set a lower {.arg iter} value such as {.val {3}}."))
    }
  }
  
  mod <- nls.multstart::nls_multstart(rTPC::get_tpc_as_formula(model_name, temp, trait),
                       data = data,
                       iter = iter,
                       start_lower = start_vals - start_adjusts,
                       start_upper = start_vals + start_adjusts,
                       lower = rTPC::get_lower_lims(data[, temp], data[, trait], model_name = model_name),
                       upper = rTPC::get_upper_lims(data[, temp], data[, trait], model_name = model_name),
                       supp_errors = 'Y',
                       lhstype = lhstype,
                       convergence_count = FALSE)
  return(mod)
}
