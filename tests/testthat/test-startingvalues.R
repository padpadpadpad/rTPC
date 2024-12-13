# do not run the test on CRAN as they take too long
testthat::skip_on_cran()

# Load data
data('chlorella_tpc')
d <- subset(chlorella_tpc, curve_id == 1)

# Load model names
mod_names <- get_model_names()

starting_count <- 0
starting_failed <- character()
lower_count <- 0
lower_failed <- character()
upper_count <- 0
upper_failed <- character()

# Test starting values
for (model in mod_names) {
  starting <- get_start_vals(d$temp, d$rate, model_name = model)
  lower <- get_lower_lims(d$temp, d$rate, model_name = model)
  upper <- get_upper_lims(d$temp, d$rate, model_name = model)
  if (!is.null(starting)) {
    starting_count <- starting_count + 1
  } else {
    starting_failed <- c(starting_failed, model)
  }
  if (!is.null(lower)) {
    lower_count <- lower_count + 1
  } else {
    lower_failed <- c(lower_failed, model)
  }
  if (!is.null(upper)) {
    upper_count <- upper_count + 1
  } else {
    upper_failed <- c(upper_failed, model)
  }
}

# run test
testthat::test_that("All models can generate starting values", {
  testthat::expect_equal(length(mod_names), starting_count, info={paste("No starting values for:", starting_failed, collapse = ", ")})
})

testthat::test_that("All models can generate lower limits", {
  testthat::expect_equal(length(mod_names), lower_count, info={paste("No lower limits for:", lower_failed, collapse = ", ")})
})

testthat::test_that("All models can generate upper limits", {
  testthat::expect_equal(length(mod_names), upper_count, info={paste("No upper limits for:", upper_failed, collapse = ", ")})
})
