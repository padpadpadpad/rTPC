# Boatman model for fitting thermal performance curves

Boatman model for fitting thermal performance curves

## Usage

``` r
boatman_2017(temp, rmax, tmin, tmax, a, b)
```

## Arguments

- temp:

  temperature in degrees centigrade

- rmax:

  the rate at optimum temperature

- tmin:

  low temperature (ºC) at which rates become negative

- tmax:

  high temperature (ºC) at which rates become negative

- a:

  shape parameter to adjust the skewness of the curve

- b:

  shape parameter to adjust the kurtosis of the curve

## Value

a numeric vector of rate values based on the temperatures and parameter
values provided to the function

## Details

Equation: \$\$rate= r\_{max} \cdot
\left(sin\bigg(\pi\left(\frac{temp-t\_{min}}{t\_{max} -
t\_{min}}\right)^{a}\bigg)\right)^{b}\$\$

Start values in `get_start_vals` are derived from the data or sensible
values from the literature.

Limits in `get_lower_lims` and `get_upper_lims` are derived from the
data or based extreme values that are unlikely to occur in ecological
settings.

## Note

Generally we found this model easy to fit.

## References

Boatman, T. G., Lawson, T., & Geider, R. J. A key marine diazotroph in a
changing ocean: The interacting effects of temperature, CO2 and light on
the growth of Trichodesmium erythraeum IMS101. PLoS ONE, 12, e0168796
(2017)

## Examples

``` r
# load in ggplot
library(ggplot2)

# subset for the first TPC curve
data('chlorella_tpc')
d <- subset(chlorella_tpc, curve_id == 1)

# get start values and fit model
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'boatman_2017')
# fit model
mod <- nls.multstart::nls_multstart(rate~boatman_2017(temp = temp, rmax, tmin, tmax, a, b),
data = d,
iter = c(4,4,4,4,4),
start_lower = start_vals - 10,
start_upper = start_vals + 10,
lower = get_lower_lims(d$temp, d$rate, model_name = 'boatman_2017'),
upper = get_upper_lims(d$temp, d$rate, model_name = 'boatman_2017'),
supp_errors = 'Y',
convergence_count = FALSE)

# look at model fit
summary(mod)
#> 
#> Formula: rate ~ boatman_2017(temp = temp, rmax, tmin, tmax, a, b)
#> 
#> Parameters:
#>      Estimate Std. Error t value Pr(>|t|)    
#> rmax   1.5830     0.1968   8.043 8.81e-05 ***
#> tmin -50.0000   835.2422  -0.060  0.95394    
#> tmax  49.0001    11.8441   4.137  0.00436 ** 
#> a      6.1124    48.7078   0.125  0.90366    
#> b      1.9269     7.0552   0.273  0.79265    
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Residual standard error: 0.2739 on 7 degrees of freedom
#> 
#> Number of iterations to convergence: 75 
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
