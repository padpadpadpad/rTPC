context("test-boatman_2017.R")

# do not run the test on CRAN as they take too long
testthat::skip_on_cran()

# method: fit model and get predictions. Check these are consistent.

# load in ggplot
library(ggplot2)

# laod in data
data('chlorella_tpc')
d <- subset(chlorella_tpc, curve_id == 1)

# get start values and fit model
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'boatman_2017')

# fit model
mod <- suppressWarnings(nls.multstart::nls_multstart(rate~boatman_2017(temp = temp, rmax, tmin, tmax, a,b),
                                                     data = d,
                                                     iter = c(5,5,5,5,5),
                                                     start_lower = start_vals - 10,
                                                     start_upper = start_vals + 10,
                                                     lower = get_lower_lims(d$temp, d$rate, model_name = 'boatman_2017'),
                                                     upper = get_upper_lims(d$temp, d$rate, model_name = 'boatman_2017'),
                                                     supp_errors = 'Y',
                                                     convergence_count = FALSE))

# get predictions
preds <- broom::augment(mod)

# plot
ggplot(preds) +
  geom_point(aes(temp, rate)) +
  geom_line(aes(temp, .fitted)) +
  theme_bw()

# run test for boatman function
testthat::test_that("boatman_2017 function works", {
  testthat::expect_equal(
    round(preds$.fitted, 1),
    c(0.1, 0.2, 0.3, 0.5, 0.7, 1.1, 1.4, 1.5, 1.5, 1.1, 0.5, 0.0))
})
