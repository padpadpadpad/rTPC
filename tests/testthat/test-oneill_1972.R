context("test-oneill_1972.R")

data('chlorella_tpc')
d <- subset(chlorella_tpc, curve_id == 1)

# get start values and fit model
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'oneill_1972')

# fit model
mod <- suppressWarnings(nls.multstart::nls_multstart(rate~oneill_1972(temp = temp, rmax, ctmax, topt, q10),
                                    data = d,
                                    iter = 500,
                                    start_lower = start_vals - 10,
                                    start_upper = start_vals + 10,
                                    lower = get_lower_lims(d$temp, d$rate, model_name = 'oneill_1972'),
                                    upper = get_upper_lims(d$temp, d$rate, model_name = 'oneill_1972'),
                                    supp_errors = 'Y'))

# run test for oneill function
testthat::test_that("oneill function works", {
  testthat::expect_equal(
    round(coef(mod)),
    c(rmax=2, ctmax=49, topt=38, q10=2))
})
