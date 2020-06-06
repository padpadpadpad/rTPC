context("test-quadratic_2008.R")

# do not run the test on CRAN as they take too long
testthat::skip_on_cran()

# method: fit model and get predictions. Check these are consistent.

# load in ggplot
library(ggplot2)

# laod in data
data('chlorella_tpc')
d <- subset(chlorella_tpc, curve_id == 1)

# get start values and fit model
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'quadratic_2008')

# fit model
mod <- nls.multstart::nls_multstart(rate~quadratic_2008(temp = temp, a, b, c),
                                                     data = d,
                                                     iter = 500,
                                                     start_lower = start_vals - 0.5,
                                                     start_upper = start_vals + 0.5,
                                                     lower = get_lower_lims(d$temp, d$rate, model_name = 'quadratic_2008'),
                                                     upper = get_upper_lims(d$temp, d$rate, model_name = 'quadratic_2008'),
                                                     supp_errors = 'Y',
                                                     convergence_count = TRUE)

# get predictions
preds <- broom::augment(mod)

# plot
ggplot(preds) +
  geom_point(aes(temp, rate)) +
  geom_line(aes(temp, .fitted)) +
  theme_bw()

# run test
testthat::test_that("quadratic_2008 function works", {
  testthat::expect_equal(
    round(preds$.fitted, 1),
    c(-0.2,  0.2,  0.6  ,0.8,  1.0,  1.2,  1.2,  1.2,  1.1,  0.9,  0.6,  0.3))
})
