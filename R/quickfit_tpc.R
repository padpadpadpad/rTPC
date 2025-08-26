#' Perform a quick, automated, TPC fit
#'
#' @description Performs a simple TPC fit using \code{\link[nls.multstart]{nls_multstart}}. This function tries to use a sensible default configuration,
#' however if you want to use the more custom elements of \code{\link[nls.multstart]{nls_multstart}} then you will need to construct your own.
#' @param data the data to fit a model to
#' @param model_name the model name as a string
#' @param temp the column name (as a string) containing the temperature data
#' @param trait the column name (as a string) containing the temperature data
#' @param start_adjusts any adjustments to make to the lower and upper starting bounds. If \code{0 < start_adjusts < 1}, this will be interpreted as a proportion of the base starting values.
#' @param iter number of combinations of starting parameters which will be tried . If a single value is provided, then a shotgun/random-search/lhs approach will be used to sample starting parameters from a uniform distribution within the starting parameter bounds. If a vector of the same length as the number of parameters is provided, then a gridstart approach will be used to define each combination of that number of equally spaced intervals across each of the starting parameter bounds respectively. Thus, c(5,5,5) for three fitted parameters yields 125 model fits. Supplying a vector for iter will override convergence_count.
#' @param ... additional arguments to pass to \code{\link[nls.multstart]{nls_multstart}}.
#' @author Francis Windram
#' @return The nls model object of the fit model
#' @concept helper
#'
#' @examples
#' \dontrun{
#' data("chlorella_tpc")
#'
#' d <- subset(chlorella_tpc, curve_id == 1)
#'
#' quickfit_tpc(
#'   d,
#'   "briere1_1999",
#'   "temp",
#'   "rate",
#'   start_adjusts = 10,
#'   iter = 150
#' )
#'
#' quickfit_tpc(
#'   d,
#'   "briere1_1999",
#'   "temp",
#'   "rate",
#'   start_adjusts = 0.8,
#'   iter = c(5,5,5)
#' )
#' }
#'
#' @export quickfit_tpc

quickfit_tpc <- function(
  data,
  model_name,
  temp,
  trait,
  start_adjusts = 0,
  iter,
  ...
) {
  rlang::check_installed("nls.multstart")

  args <- list(...)

  # if not supplied, set default
  if (is.null(args$supp_errors)) {
    args$supp_errors <- "Y"
  }

  # The form of column extraction used below only works properly on dfs.
  data <- as.data.frame(data)

  # compute needed values
  start_vals <- rTPC::get_start_vals(
    data[, temp],
    data[, trait],
    model_name = model_name
  )
  lower = rTPC::get_lower_lims(
    data[, temp],
    data[, trait],
    model_name = model_name
  )
  upper = rTPC::get_upper_lims(
    data[, temp],
    data[, trait],
    model_name = model_name
  )

  if (0 < start_adjusts && start_adjusts < 1) {
    start_adjusts <- start_vals * start_adjusts
  }

  mod <- do.call(
    nls.multstart::nls_multstart,
    c(
      list(
        formula = rTPC::get_tpc_as_formula(model_name, temp, trait),
        data = data,
        iter = iter,
        start_lower = start_vals - start_adjusts,
        start_upper = start_vals + start_adjusts,
        lower = lower,
        upper = upper
      ),
      args
    )
  )

  return(mod)
}
