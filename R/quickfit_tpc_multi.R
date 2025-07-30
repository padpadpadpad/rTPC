#' Perform a parallelised quick tpc fit across models and curves
#'
#' @description Performs a parallelised TPC fit using \code{\link[nls.multstart]{nls_multstart}} and \code{\link[purrr]{map}}. This function tries to use a sensible default configuration, 
#' however if you need to use the more esoteric elements of \code{\link[nls.multstart]{nls_multstart}} then you may need to construct your own running script.
#' @param d the data to fit a model to
#' @param model_names a vector of model names to fit as strings
#' @param temp the column name (as a string) containing the temperature data
#' @param trait the column name (as a string) containing the temperature data
#' @param start_adjusts any adjustments to make to the lower and upper starting bounds. If \code{0 < start_adjusts < 1}, this will be interpreted as a proportion of the base starting values.
#' @param iter number of combinations of starting parameters which will be tried (as in \code{\link[nls.multstart]{nls_multstart}})
#' @param lhstype method to use for Latin Hypercube Sampling using \code{\link[lhs]{lhs}} (as in \code{\link[nls.multstart]{nls_multstart}})
#' @param gridstart whether to run a gridstart approach (interpreting iter as the number of samples to take across each parameter, 
#' so \code{3} will become \code{c(3,3,3)} for a 3-parameter model)
#' @param force whether to force a gridstart even with very large numbers of iterations
#' 
#' @note The parameters \code{temp}, \code{trait}, \code{start_adjusts}, \code{iter}, \code{lhstype}, \code{gridstart}, or \code{force} can be specified per-model
#'  by providing a vector of values of a length equal to the number of models to be fit.
#' 
#' @author Francis Windram
#' @return A tibble of model fits
#' @concept helper
#' 
#' @examples
#' \dontrun{
#' data("chlorella_tpc")
#' d2 <- subset(chlorella_tpc, curve_id <= 60)
#' 
#' # Set up daemons for parallelism
#' mirai::daemons(2)
#' 
#' quickfit_tpc_multi(d2, c("briere1_1999", "briere2_1999"), "temp", "rate")
#' 
#' quickfit_tpc_multi(d2, c("briere1_1999", "briere2_1999"), "temp", "rate", start_adjusts = 10)
#' 
#' quickfit_tpc_multi(d2, c("briere1_1999", "briere2_1999"), "temp", "rate", iter = c(100, 150))
#' 
#' mirai::daemons(0)
#' }
#' @export quickfit_tpc_multi

quickfit_tpc_multi <- function(d, model_names, temp, trait, start_adjusts = 0, iter = 150, lhstype = "none", gridstart=FALSE, force=FALSE) {
  
  rlang::check_installed(c("purrr", "mirai", "dplyr", "tidyr"), version = c("1.1.0", NA, NA, NA))
  
  if (!mirai::daemons_set()) {
    cli::cli_abort(c(
      "x" = "To perform parallel fitting, you must initialise mirai daemons.",
      ">" = "Please run {.fn mirai::daemons} with the number of cores you wish to use.",
      ""))
  }
  
  rlang::check_installed(c("nls.multstart", "mirai", "carrier"))
  
  # Check model_names to make sure models are in the list (rather than doing this on each process)
  mod_names <- rTPC::get_model_names(returnall = TRUE)
  to_fit <- intersect(model_names, mod_names)
  unknown <- setdiff(model_names, mod_names)
  
  if (length(to_fit) < 1) {
    cli::cli_abort(c("x" = "No valid models found! Got: {.val {model_names}}",
                     "!"="Please check the spellings within {.arg model_names}.",
                     " "="(run {.fn rTPC::get_model_names} to see all valid names.)",
                     ""))
  } else if (length(unknown) > 0) {
    cli::cli_warn(c("!" = "Unknown models specified. Ignoring {.val {unknown}}"))
  }
  
  nesting_cols <- c(temp, trait)
  
  fit_models <- d |> 
    tidyr::nest(data = dplyr::all_of(nesting_cols)) |> 
    dplyr::mutate(
      mods = purrr::map(
        data,
        purrr::in_parallel(
          \(x) .quickfit_multi(x, 
                               model_names = to_fit,
                               temp = temp,
                               trait = trait,
                               start_adjusts = start_adjusts,
                               iter = iter,
                               lhstype = lhstype,
                               gridstart = gridstart,
                               force = force
          ),
          .quickfit_multi = .quickfit_multi,
          to_fit = to_fit,
          temp = temp,
          trait = trait,
          start_adjusts = start_adjusts,
          iter = iter,
          lhstype = lhstype,
          gridstart = gridstart,
          force = force
        ),
        .progress = TRUE
      )
    ) |>
    tidyr::unnest(mods)
  
  return(fit_models)
  
}

.quickfit_multi <- function(data, model_names, temp, trait, start_adjusts=0, iter=150, lhstype="none", gridstart=FALSE, force=FALSE) {
  # Coerce args (basically make df of params)
  df <- tibble::tibble(model=model_names, temp, trait, start_adjusts, iter, lhstype , gridstart, force)
  
  # Map tpcs using quickfit
  out <- purrr::pmap(df, \(...) list(rTPC::quickfit_tpc(data, ...)))
  
  # Get some lovely names
  names(out) <- model_names
  
  # Cast to tibble and return
  return(tibble::as.tibble(out))
}