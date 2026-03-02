# Ashrafi V model for fitting thermal performance curves

Ashrafi V model for fitting thermal performance curves

## Usage

``` r
ashrafi5_2018(temp, a, b, c, d)
```

## Arguments

- temp:

  temperature in degrees centigrade

- a:

  dimensionless parameter

- b:

  dimensionless parameter

- c:

  dimensionless parameter

- d:

  dimensionless parameter

## Value

a numeric vector of rate values based on the temperatures and parameter
values provided to the function

## Details

Equation: \$\$rate = a + b \cdot log(temp + 273.15)^2 + c \cdot
log(temp + 273.15) + \frac{d \cdot log(temp + 273.15)}{temp +
273.15}\$\$

Start values in `get_start_vals` are derived from the data or sensible
values from the literature.

Limits in `get_lower_lims` and `get_upper_lims` are derived from the
data or based extreme values that are unlikely to occur in ecological
settings.

## Note

Generally we found this model easy to fit.

## References

Ashrafi, R. et al. Broad thermal tolerance is negatively correlated with
virulence in an opportunistic bacterial pathogen. Evolutionary
Applications 11, 1700–1714 (2018).

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
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'ashrafi5_2018')
# fit model
mod <- nls.multstart::nls_multstart(rate~ashrafi5_2018(temp = temp, a, b, c, d),
data = d,
iter = c(4,4,4,4),
start_lower = start_vals - 10,
start_upper = start_vals + 10,
lower = get_lower_lims(d$temp, d$rate, model_name = 'ashrafi5_2018'),
upper = get_upper_lims(d$temp, d$rate, model_name = 'ashrafi5_2018'),
supp_errors = 'Y',
convergence_count = FALSE)

# look at model fit
summary(mod)
#> 
#> Formula: rate ~ ashrafi5_2018(temp = temp, a, b, c, d)
#> 
#> Parameters:
#>    Estimate Std. Error t value Pr(>|t|)   
#> a -39560.72   11353.74  -3.484  0.00827 **
#> b  -1184.91     341.14  -3.473  0.00840 **
#> c  13645.10    3935.71   3.467  0.00848 **
#> d     40.81      16.74   2.437  0.04073 * 
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Residual standard error: 0.3351 on 8 degrees of freedom
#> 
#> Number of iterations to convergence: 9 
#> Achieved convergence tolerance: 1.49e-08
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
