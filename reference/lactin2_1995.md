# Lactin2 model for fitting thermal performance curves

Lactin2 model for fitting thermal performance curves

## Usage

``` r
lactin2_1995(temp, a, b, tmax, delta_t)
```

## Arguments

- temp:

  temperature in degrees centigrade

- a:

  constant that determines the steepness of the rising portion of the
  curve

- b:

  constant that determines the height of the overall curve

- tmax:

  the temperature at which the curve begins to decelerate beyond the
  optimum (ºC)

- delta_t:

  thermal safety margin (ºC)

## Value

a numeric vector of rate values based on the temperatures and parameter
values provided to the function

## Details

Equation: \$\$rate= = exp^{a \cdot temp} - exp^{a \cdot t\_{max} -
\bigg(\frac{t\_{max} - temp}{\delta \_{t}}\bigg)} + b\$\$

Start values in `get_start_vals` are derived from the data or sensible
values from the literature.

Limits in `get_lower_lims` and `get_upper_lims` are derived from the
data or based extreme values that are unlikely to occur in ecological
settings.

## Note

Generally we found this model easy to fit.

## References

Lactin, D.J., Holliday, N.J., Johnson, D.L. & Craigen, R. Improved rate
models of temperature-dependent development by arthropods. Environmental
Entomology 24, 69-75 (1995)

## Examples

``` r
# load in ggplot
library(ggplot2)

# subset for the first TPC curve
data('chlorella_tpc')
d <- subset(chlorella_tpc, curve_id == 1)

# get start values and fit model
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'lactin2_1995')
# fit model
mod <- nls.multstart::nls_multstart(rate~lactin2_1995(temp = temp, a, b, tmax, delta_t),
data = d,
iter = c(3,3,3,3),
start_lower = start_vals - 10,
start_upper = start_vals + 10,
lower = get_lower_lims(d$temp, d$rate, model_name = 'lactin2_1995'),
upper = get_upper_lims(d$temp, d$rate, model_name = 'lactin2_1995'),
supp_errors = 'Y',
convergence_count = FALSE)

# look at model fit
summary(mod)
#> 
#> Formula: rate ~ lactin2_1995(temp = temp, a, b, tmax, delta_t)
#> 
#> Parameters:
#>         Estimate Std. Error t value Pr(>|t|)    
#> a        0.06598    0.06421   1.027    0.334    
#> b       -1.33668    2.12052  -0.630    0.546    
#> tmax    51.81297    5.02660  10.308 6.77e-06 ***
#> delta_t 11.91689    0.92791  12.843 1.28e-06 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Residual standard error: 0.3378 on 8 degrees of freedom
#> 
#> Number of iterations to convergence: 42 
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
