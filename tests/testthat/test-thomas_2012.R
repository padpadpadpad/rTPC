context("test-thomas_2012.R")

# do not run the test on CRAN as they take too long
testthat::skip_on_cran()
testthat::skip('thomas_2012 needs to be tested with different limits')

# method: fit model and get predictions. Check these are consistent.

# load in ggplot
library(ggplot2)

# laod in data
data('chlorella_tpc')
d <- subset(chlorella_tpc, curve_id == 1)

# get start values and fit model
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'thomas_2012')

# fit model
mod <- suppressWarnings(nls.multstart::nls_multstart(rate~thomas_2012(temp = temp, a, b, c, topt),
                                                     data = d,
                                                     iter = 500,
                                                     start_lower = start_vals - 1,
                                                     start_upper = start_vals + 2,
                                                     lower = get_lower_lims(d$temp, d$rate, model_name = 'thomas_2012'),

                                                     supp_errors = 'Y',
                                                     convergence_count = FALSE))

# get predictions
preds <- broom::augment(mod)

# plot
ggplot(preds) +
  geom_point(aes(temp, rate)) +
  geom_line(aes(temp, .fitted)) +
  theme_bw()

# run test
testthat::test_that("thomas_2012 function works", {
  testthat::expect_equal(
    round(preds$.fitted, 1),
    c(0.3, 0.4, 0.5, 0.6, 0.8, 1.0, 1.1, 1.3, 1.3, 1.2, 0.8, -0.1))
})
