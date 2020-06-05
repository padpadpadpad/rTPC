context("test-briere2_1999.R")

# do not run the test on CRAN as they take too long
testthat::skip_on_cran()

# method: fit model and get predictions. Check these are consistent.

# load in ggplot
library(ggplot2)

# laod in data
data('chlorella_tpc')
d <- subset(chlorella_tpc, curve_id == 1)

# get start values and fit model
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'briere2_1999')

# fit model
mod <- suppressWarnings(nls.multstart::nls_multstart(rate~briere2_1999(temp = temp, tmin, tmax, a, b),
                                                     data = d,
                                                     iter = c(5,5,5,5),
                                                     start_lower = start_vals - 10,
                                                     start_upper = start_vals + 10,
                                                     lower = get_lower_lims(d$temp, d$rate, model_name = 'briere2_1999'),
                                                     upper = get_upper_lims(d$temp, d$rate, model_name = 'briere2_1999'),
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
testthat::test_that("briere2_1999 function works", {
  testthat::expect_equal(
    round(preds$.fitted, 1),
    c(-0.1,  0.2,  0.4,  0.7,  0.9,  1.1,  1.3,  1.3,  1.3,  1.1,  0.7,  0.0))
})
