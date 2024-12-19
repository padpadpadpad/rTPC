# do not run the test on CRAN as they take too long
testthat::skip_on_cran()

# method: fit model and get predictions. Check these against others.

# load in ggplot
library(ggplot2)

# subset for the first TPC curve
data('chlorella_tpc')
d <- subset(chlorella_tpc, curve_id == 1)

# get start values and fit model
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'taylorsexton_1972')

# fit model
mod <- nls.multstart::nls_multstart(rate~taylorsexton_1972(temp = temp, rmax, tmin, topt),
                                    data = d,
                                    iter = c(3,3,3),
                                    start_lower = start_vals - 10,
                                    start_upper = start_vals + 10,
                                    lower = get_lower_lims(d$temp, d$rate, model_name = 'taylorsexton_1972'),
                                    upper = get_upper_lims(d$temp, d$rate, model_name = 'taylorsexton_1972'),
                                    supp_errors = 'Y',
                                    convergence_count = FALSE)

# get predictions
preds <- broom::augment(mod)
# dput(round(preds$.fitted, 1))

# plot
ggplot(preds) +
  geom_point(aes(temp, rate)) +
  geom_line(aes(temp, .fitted)) +
  theme_bw()

# run test
testthat::test_that("taylorsexton_1972 function works", {
  testthat::expect_equal(
    round(preds$.fitted, 1),
    c(0.1, 0.2, 0.4, 0.6, 0.8, 1.1, 1.3, 1.4, 1.4, 1.1, 0.7, -0.1))
})
