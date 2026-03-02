# Warren-Dreyer model for fitting thermal performance curves

Warren-Dreyer model for fitting thermal performance curves

## Usage

``` r
warrendreyer_2006(temp, rmax, topt, a)
```

## Arguments

- temp:

  temperature in degrees centigrade

- rmax:

  maximum performance/value of the trait

- topt:

  temperature of max performance (ºC)

- a:

  shape parameter

## Value

a numeric vector of rate values based on the temperatures and parameter
values provided to the function

## Details

Equation: \$\$rate = R\_{\text{max}} \cdot \exp{\left\[-0.5 \cdot
\left(\frac{\ln{\frac{T}{T\_{\text{opt}}}}}{a}\right)^2\right\]}\$\$

Start values in `get_start_vals` are derived from the data or sensible
values from the literature.

Limits in `get_lower_lims` and `get_upper_lims` are derived from the
data or based extreme values that are unlikely to occur in ecological
settings.

## Note

Generally we found this model easy to fit.

## References

Warren, C. R. & Dreyer, E. Temperature response of photosynthesis and
internal conductance to CO2: results from two independent approaches. J.
Exp. Bot. 57, 3057–3067 (2006).

## Author

Francis Windram

## Examples

``` r
# \donttest{
# load in ggplot
library(ggplot2)

# subset for the first TPC curve
data('chlorella_tpc')
d <- subset(chlorella_tpc, curve_id == 1)

# get start values and fit model
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'warrendreyer_2006')
# fit model
mod <- nls.multstart::nls_multstart(rate~warrendreyer_2006(temp = temp, rmax, topt, a),
data = d,
iter = c(3,3,3),
start_lower = start_vals - 10,
start_upper = start_vals + 10,
lower = get_lower_lims(d$temp, d$rate, model_name = 'warrendreyer_2006'),
upper = get_upper_lims(d$temp, d$rate, model_name = 'warrendreyer_2006'),
supp_errors = 'Y',
convergence_count = FALSE)

# look at model fit
summary(mod)
#> 
#> Formula: rate ~ warrendreyer_2006(temp = temp, rmax, topt, a)
#> 
#> Parameters:
#>      Estimate Std. Error t value Pr(>|t|)    
#> rmax  1.46485    0.22630   6.473 0.000115 ***
#> topt 35.35356    1.31116  26.963 6.43e-10 ***
#> a     0.20583    0.04062   5.068 0.000674 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Residual standard error: 0.3732 on 9 degrees of freedom
#> 
#> Number of iterations to convergence: 29 
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

# }
```
