context("test-thomas_2012.R")

# do not run the test on CRAN as they take too long
testthat::skip_on_cran()

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
                                                     iter = rep(4, times = length(start_vals)),
                                                     start_lower = start_vals - 1,
                                                     start_upper = start_vals + 2,
                                                     lower = get_lower_lims(d$temp, d$rate, model_name = 'thomas_2012'),
                                                     upper = get_upper_lims(d$temp, d$rate, model_name = 'thomas_2012'),

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
    c(0.0,  0.2,  0.4,  0.6,  0.9,  1.1,  1.2,  1.4,  1.3,  1.2,  0.7, -0.1))
})
