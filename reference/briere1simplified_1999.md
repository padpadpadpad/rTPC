# Simplified Brière I model for fitting thermal performance curves

Simplified Brière I model for fitting thermal performance curves

## Usage

``` r
briere1simplified_1999(temp, tmin, tmax, a)
```

## Arguments

- temp:

  temperature in degrees centigrade

- tmin:

  low temperature (ºC) at which rates become negative

- tmax:

  high temperature (ºC) at which rates become negative

- a:

  scale parameter to adjust maximum rate of the curve

## Value

a numeric vector of rate values based on the temperatures and parameter
values provided to the function

## Details

Equation: \$\$rate=a \cdot (temp - t\_{min}) \cdot (t\_{max} -
temp)^{\frac{1}{2}}\$\$

Start values in `get_start_vals` are derived from the data or sensible
values from the literature.

Limits in `get_lower_lims` and `get_upper_lims` are derived from the
data or based extreme values that are unlikely to occur in ecological
settings.

## Note

Generally we found this model easy to fit.

## References

Brière, J.F., Pracros, P., Le Roux, A.Y., Pierre, J.S., A novel rate
model of temperature-dependent development for arthropods. Environmental
Entomololgy, 28, 22–29 (1999)

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
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'briere1simplified_1999')
# fit model
mod <- nls.multstart::nls_multstart(rate~briere1simplified_1999(temp = temp, tmin, tmax, a),
data = d,
iter = c(3,3,3),
start_lower = start_vals - 10,
start_upper = start_vals + 10,
lower = get_lower_lims(d$temp, d$rate, model_name = 'briere1simplified_1999'),
upper = get_upper_lims(d$temp, d$rate, model_name = 'briere1simplified_1999'),
supp_errors = 'Y',
convergence_count = FALSE)

# look at model fit
summary(mod)
#> 
#> Formula: rate ~ briere1simplified_1999(temp = temp, tmin, tmax, a)
#> 
#> Parameters:
#>       Estimate Std. Error t value Pr(>|t|)    
#> tmin 16.373534   2.443916   6.700 8.86e-05 ***
#> tmax 49.050436   0.304948 160.849  < 2e-16 ***
#> a     0.017105   0.003356   5.097 0.000648 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Residual standard error: 0.3776 on 9 degrees of freedom
#> 
#> Number of iterations to convergence: 23 
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
