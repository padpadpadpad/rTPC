#' Perform an automated quick tpc fit across models and curves
#'
#' @description Performs a TPC fit using \code{\link[nls.multstart]{nls_multstart}} and \code{\link[purrr]{map}}. This function tries to use a sensible default configuration,
#' however if you need to to use the more custom elements of \code{\link[nls.multstart]{nls_multstart}} then you will need to construct your own.
#' @param d the data to fit a model to
#' @param model_names a vector of model names to fit as strings
#' @param temp the column name (as a string) containing the temperature data
#' @param trait the column name (as a string) containing the temperature data
#' @param start_adjusts any adjustments to make to the lower and upper starting bounds. If \code{0 < start_adjusts < 1}, this will be interpreted as a proportion of the base starting values. If above 1, it will add and substract that value from the base starting values.
#' @param iter number of combinations of starting parameters which will be tried . If a single value is provided, then a shotgun/random-search/lhs approach will be used to sample starting parameters from a uniform distribution within the starting parameter bounds. If a vector of the same length as the number of parameters is provided, then a gridstart approach will be used to define each combination of that number of equally spaced intervals across each of the starting parameter bounds respectively. Thus, c(5,5,5) for three fitted parameters yields 125 model fits. Supplying a vector for iter will override convergence_count.
#' @param ... additional arguments to pass to \code{\link[nls.multstart]{nls_multstart}}.
#' @note The parameters \code{temp}, \code{trait}, \code{start_adjusts}, \code{iter}, \code{lhstype}, \code{gridstart}, or \code{force} can be specified per-model
#'  by providing a vector of values of a length equal to the number of models to be fit.
#'
#' @author Francis Windram
#' @author Daniel Padfield
#' @return A tibble of model fits
#' @concept helper
#'
#' @examples
#' \dontrun{
#' # load example data
#' data("chlorella_tpc")
#'
#' # subset for just the first 5 curves
#' d <- subset(chlorella_tpc, curve_id <= 5)
#'
#'
#' quickfit_tpc_multi(d, c("briere1_1999", "briere2_1999"), "temp", "rate")
#'
#' quickfit_tpc_multi(d, c("briere1_1999", "briere2_1999"), "temp", "rate", start_adjusts = 10)
#'
#' quickfit_tpc_multi(d, c("briere1_1999", "briere2_1999"), "temp", "rate", iter = c(100, 150))
#'}
#' @export quickfit_tpc_multi

quickfit_tpc_multi <- function(
  data,
  model_names,
  temp,
  trait,
  start_adjusts = 0,
  iter,
  ...
) {
  # capture additional args
  args <- list(...)

  # if not supplied, set default
  if (is.null(args$supp_errors)) {
    args$supp_errors <- "Y"
  }

  # check lengths of all elements of args
  extra_args_lengths <- sapply(args, length)
  extra_args_bad <- names(extra_args_lengths[
    extra_args_lengths != 1 & extra_args_lengths != length(model_names)
  ])

  if (
    any(extra_args_lengths != 1 & extra_args_lengths != length(model_names))
  ) {
    cli::cli_abort(c(
      "x" = "Some of the arguments have the wrong number of values.",
      "!" = "Please check the number of values for {.val {extra_args_bad}}. They need to be either of length one or the length equal to the number of models being fit ({length(model_names)})."
    ))
  }

  # Coerce args (basically make df of params)
  df <- tibble::tibble(
    model = model_names,
    temp,
    trait,
    start_adjusts,
    iter,
    !!!args
  )

  # Map tpcs using quickfit
  out <- purrr::pmap(df, \(...) list(rTPC::quickfit_tpc(data, ...)))

  # Get some lovely names
  names(out) <- model_names

  # Cast to tibble and return
  return(tibble::as_tibble(out))
}
