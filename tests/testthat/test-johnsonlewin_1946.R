context("test-johnsonlewin_1946.R")

# do not run the test on CRAN as they take too long
testthat::skip_on_cran()
testthat::skip('test being developed')

# method: fit model and get predictions. Check these are consistent.

# load in ggplot
library(ggplot2)

# laod in data
data('chlorella_tpc')
d <- subset(chlorella_tpc, curve_id == 1)

# get start values and fit model
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'johnsonlewin_1946')

# fit model
mod <- nls.multstart::nls_multstart(rate~johnsonlewin_1946(temp = temp, r0, e, eh, topt),
                                                     data = d,
                                                     iter = 500,
                                                     start_lower = start_vals -5,
                                                     start_upper = start_vals + 5,
                                                     lower = get_lower_lims(d$temp, d$rate, model_name = 'johnsonlewin_1946'),
                                                     upper = get_upper_lims(d$temp, d$rate, model_name = 'johnsonlewin_1946'),
                                                     supp_errors = 'Y')

# get predictions
preds <- broom::augment(mod)

# plot
ggplot(preds) +
  geom_point(aes(temp, rate)) +
  geom_line(aes(temp, .fitted)) +
  theme_bw()

# run test
testthat::test_that("johnsonlewin_1946 function works", {
  testthat::expect_equal(
    round(preds$.fitted, 1),
    c(0.0,  0.2,  0.4,  0.7,  0.9,  1.1,  1.2,  1.3,  1.3,  1.2,  0.7, -0.1))
})

