# Quadratic model for fitting thermal performance curves

Quadratic model for fitting thermal performance curves

## Usage

``` r
quadratic_2008(temp, a, b, c)
```

## Arguments

- temp:

  temperature in degrees centigrade

- a:

  parameter that defines the rate at 0 ºC

- b:

  parameter with no biological meaning

- c:

  parameter with no biological meaning

## Value

a numeric vector of rate values based on the temperatures and parameter
values provided to the function

## Details

Equation: \$\$rate = a + b \cdot temp + c \cdot temp^2\$\$

Start values in `get_start_vals` are derived from the data using
previous methods in the literature

Limits in `get_lower_lims` and `get_upper_lims` are based on extreme
values that are unlikely to occur in ecological settings.

## Note

Generally we found this model easy to fit.

## References

Montagnes, David JS, et al. Short‐term temperature change may impact
freshwater carbon flux: a microbial perspective. Global Change Biology
14.12: 2823-2838. (2008)

## Examples

``` r
# load in ggplot
library(ggplot2)

# subset for the first TPC curve
data('chlorella_tpc')
d <- subset(chlorella_tpc, curve_id == 1)

# get start values and fit model
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'quadratic_2008')
# fit model
mod <- nls.multstart::nls_multstart(rate~quadratic_2008(temp = temp, a, b, c),
data = d,
iter = c(4,4,4),
start_lower = start_vals - 10,
start_upper = start_vals + 10,
lower = get_lower_lims(d$temp, d$rate, model_name = 'quadratic_2008'),
upper = get_upper_lims(d$temp, d$rate, model_name = 'quadratic_2008'),
supp_errors = 'Y',
convergence_count = FALSE)

# look at model fit
summary(mod)
#> 
#> Formula: rate ~ quadratic_2008(temp = temp, a, b, c)
#> 
#> Parameters:
#>    Estimate Std. Error t value Pr(>|t|)   
#> a -3.785505   1.240225  -3.052  0.01374 * 
#> b  0.291596   0.081480   3.579  0.00594 **
#> c -0.004248   0.001241  -3.423  0.00760 **
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Residual standard error: 0.4081 on 9 degrees of freedom
#> 
#> Number of iterations to convergence: 5 
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
