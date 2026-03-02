# Atkin model for fitting thermal performance curves

Atkin model for fitting thermal performance curves

## Usage

``` r
atkin_2005(temp, r0, a, b)
```

## Arguments

- temp:

  temperature in degrees centigrade

- r0:

  scaling parameter, the minimum trait value

- a:

  arbitrary scaling parameter

- b:

  arbitrary scaling parameter

## Value

a numeric vector of rate values based on the temperatures and parameter
values provided to the function

## Details

Equation: \$\$rate = B_0 \cdot (a - b \cdot T)^{\frac{T}{10}}\$\$

Start values in `get_start_vals` are derived from the data or sensible
values from the literature.

Limits in `get_lower_lims` and `get_upper_lims` are derived from the
data or based extreme values that are unlikely to occur in ecological
settings.

## Note

Generally we found this model easy to fit.

## References

Atkin, OK, Bruhn D, Tjoelker MG. Response of Plant Respiration to
Changes in Temperature: Mechanisms and Consequences of Variations in Q10
Values and Acclimation. In Plant Respiration. 2005.

## Author

Francis Windram

## Examples

``` r
# load in ggplot
library(ggplot2)

# subset for the first TPC curve
data('chlorella_tpc')
d <- subset(chlorella_tpc, curve_id == 1)

# get start values and fit model
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'atkin_2005')
# fit model
mod <- nls.multstart::nls_multstart(rate~atkin_2005(temp = temp, r0, a, b),
data = d,
iter = 200,
start_lower = start_vals - 10,
start_upper = start_vals + 10,
lower = get_lower_lims(d$temp, d$rate, model_name = 'atkin_2005'),
upper = get_upper_lims(d$temp, d$rate, model_name = 'atkin_2005'),
supp_errors = 'Y',
convergence_count = FALSE)

# look at model fit
summary(mod)
#> 
#> Formula: rate ~ atkin_2005(temp = temp, r0, a, b)
#> 
#> Parameters:
#>     Estimate Std. Error t value Pr(>|t|)  
#> r0 7.332e-04  9.598e-04   0.764   0.4644  
#> a  2.352e+01  1.086e+01   2.166   0.0585 .
#> b  4.212e-01  2.152e-01   1.957   0.0820 .
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Residual standard error: 0.2769 on 9 degrees of freedom
#> 
#> Number of iterations to convergence: 20 
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
