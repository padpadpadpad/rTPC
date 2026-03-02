# Taylor-Sexton model for fitting thermal performance curves

Taylor-Sexton model for fitting thermal performance curves

## Usage

``` r
taylorsexton_1972(temp, rmax, tmin, topt)
```

## Arguments

- temp:

  temperature in degrees centigrade

- rmax:

  maximum performance/value of the trait

- tmin:

  low temperature (ºC) at which rates become negative

- topt:

  optimum temperature (ºC)

## Value

a numeric vector of rate values based on the temperatures and parameter
values provided to the function

## Details

Equation: \$\$rate = R\_{\text{max}} \cdot
\frac{-(T-T\_{\text{min}})^4 + 2 \cdot (T - T\_{\text{min}})^2 \cdot
(T\_{\text{opt}}-T\_{\text{min}})^2}{(T\_{\text{opt}}-T\_{\text{min}})^4}\$\$

Start values in `get_start_vals` are derived from the data or sensible
values from the literature.

Limits in `get_lower_lims` and `get_upper_lims` are based on extreme
values that are unlikely to occur in ecological settings.

## Note

Generally we found this model easy to fit.

## References

Taylor, S. E. & Sexton, O. J. Some implications of leaf tearing in
Musaceae. Ecology 53, 143–149 (1972).

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
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'taylorsexton_1972')
# fit model
mod <- nls.multstart::nls_multstart(rate~taylorsexton_1972(temp = temp, rmax, tmin, topt),
data = d,
iter = 200,
start_lower = start_vals - 10,
start_upper = start_vals + 10,
lower = get_lower_lims(d$temp, d$rate, model_name = 'taylorsexton_1972'),
upper = get_upper_lims(d$temp, d$rate, model_name = 'taylorsexton_1972'),
supp_errors = 'Y',
convergence_count = FALSE)

# look at model fit
summary(mod)
#> 
#> Formula: rate ~ taylorsexton_1972(temp = temp, rmax, tmin, topt)
#> 
#> Parameters:
#>      Estimate Std. Error t value Pr(>|t|)    
#> rmax   1.3960     0.1510   9.248 6.83e-06 ***
#> tmin  12.2556     3.0717   3.990  0.00316 ** 
#> topt  38.0473     0.9169  41.495 1.37e-11 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Residual standard error: 0.3055 on 9 degrees of freedom
#> 
#> Number of iterations to convergence: 12 
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
