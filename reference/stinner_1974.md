# Stinner model for fitting thermal performance curves

Stinner model for fitting thermal performance curves

## Usage

``` r
stinner_1974(temp, rmax, topt, a, b)
```

## Arguments

- temp:

  temperature in degrees centigrade

- rmax:

  the maximum rate

- topt:

  optimum temperature (ºC) at which rates are maximal

- a:

  dimensionless parameter

- b:

  dimensionless parameter

## Value

a numeric vector of rate values based on the temperatures and parameter
values provided to the function

## Details

Equation: \$\$\textrm{if} \quad temp \<= t\_{opt}: rate = rmax \cdot
\frac{1 + exp^{a + b \cdot t\_{opt}}}{(1 + exp^{a + b \cdot temp}}\$\$
\$\$\textrm{if} \quad temp \<= t\_{opt}: rate = rmax \cdot \frac{1 +
exp^{a + b \cdot t\_{opt}}}{(1 + exp^{a + b \cdot (2 \cdot t\_{opt} -
temp)}}\$\$

Start values in `get_start_vals` are derived from the data or sensible
values from the literature.

Limits in `get_lower_lims` and `get_upper_lims` are derived from the
data or based extreme values that are unlikely to occur in ecological
settings.

## Note

Generally we found this model easy to fit.

## References

Stinner, R. E., Gutierrez, A. P., & Butler Jr, G. D. (1974). An
algorithm for temperature-dependent growth rate simulation12. The
Canadian Entomologist, 106(5), 519-524.

## Author

Daniel Padfield

## Examples

``` r
# load in ggplot
library(ggplot2)

# subset for the first TPC curve
data('chlorella_tpc')
d <- subset(chlorella_tpc, curve_id == 1)

# get start values and fit model
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'stinner_1974')
# fit model
mod <- nls.multstart::nls_multstart(rate~stinner_1974(temp = temp, rmax, topt, a, b),
data = d,
iter = c(5,5,5,5),
start_lower = start_vals - 10,
start_upper = start_vals + 10,
lower = get_lower_lims(d$temp, d$rate, model_name = 'stinner_1974'),
upper = get_upper_lims(d$temp, d$rate, model_name = 'stinner_1974'),
supp_errors = 'Y',
convergence_count = FALSE)

# look at model fit
summary(mod)
#> 
#> Formula: rate ~ stinner_1974(temp = temp, rmax, topt, a, b)
#> 
#> Parameters:
#>      Estimate Std. Error t value Pr(>|t|)    
#> rmax   1.3561     0.1736   7.813 5.18e-05 ***
#> topt  35.8015     0.7858  45.558 5.95e-11 ***
#> a     25.1686    14.7144   1.710    0.126    
#> b     -0.9365     0.5479  -1.709    0.126    
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Residual standard error: 0.3192 on 8 degrees of freedom
#> 
#> Number of iterations till stop: 98 
#> Achieved convergence tolerance: 1.49e-08
#> Reason stopped: Number of calls to `fcn' has reached or exceeded `maxfev' == 500.
#> 

# get predictions
preds <- data.frame(temp = seq(min(d$temp), max(d$temp), length.out = 100))
preds <- broom::augment(mod, newdata = preds)

# plot
ggplot(preds) +
geom_point(aes(temp, rate), d) +
geom_line(aes(temp, .fitted), col = 'blue') +
theme_bw()
```
