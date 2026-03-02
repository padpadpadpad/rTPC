# Weibull model for fitting thermal performance curves

Weibull model for fitting thermal performance curves

## Usage

``` r
weibull_1995(temp, a, topt, b, c)
```

## Arguments

- temp:

  temperature in degrees centigrade

- a:

  scale the height of the curve

- topt:

  optimum temperature

- b:

  defines the breadth of the curve

- c:

  defines the curve shape

## Value

a numeric vector of rate values based on the temperatures and parameter
values provided to the function

## Details

Equation: \$\$rate = a \cdot \bigg(
\frac{c-1}{c}\bigg)^{\frac{1-c}{c}}\bigg(\frac{temp-t\_{opt}}{b}+\bigg(\frac{c-1}{c}\bigg)^{\frac{1}{c}}\bigg)^{c-1}exp^{-\big(\frac{temp-t\_{opt}}{b}+\big(
\frac{c-1}{c}\big)^{\frac{1}{c}}\big)^c} + \frac{c-1}{c}\$\$

Start values in `get_start_vals` are derived from the data.

Limits in `get_lower_lims` and `get_upper_lims` are derived from the
data or based extreme values that are unlikely to occur in ecological
settings.

## Note

Generally we found this model easy to fit.

## References

Angilletta Jr, Michael J. Estimating and comparing thermal performance
curves. Journal of Thermal Biology 31.7 (2006): 541-545.

## Examples

``` r
# load in ggplot
library(ggplot2)

# subset for the first TPC curve
data('chlorella_tpc')
d <- subset(chlorella_tpc, curve_id == 1)

# get start values and fit model
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'weibull_1995')
# fit model
mod <- nls.multstart::nls_multstart(rate~weibull_1995(temp = temp, a, topt, b, c),
data = d,
iter = c(4,4,4,4),
start_lower = start_vals - 10,
start_upper = start_vals + 10,
lower = get_lower_lims(d$temp, d$rate, model_name = 'weibull_1995'),
upper = get_upper_lims(d$temp, d$rate, model_name = 'weibull_1995'),
supp_errors = 'Y',
convergence_count = FALSE)

# look at model fit
summary(mod)
#> 
#> Formula: rate ~ weibull_1995(temp = temp, a, topt, b, c)
#> 
#> Parameters:
#>       Estimate Std. Error t value Pr(>|t|)    
#> a    1.608e+00  1.833e-01   8.773 2.23e-05 ***
#> topt 3.820e+01  8.169e-01  46.761 4.84e-11 ***
#> b    6.332e+05  3.842e+08   0.002    0.999    
#> c    1.017e+05  6.169e+07   0.002    0.999    
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Residual standard error: 0.2681 on 8 degrees of freedom
#> 
#> Number of iterations to convergence: 43 
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
