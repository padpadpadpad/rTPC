# Tomlinson-Phillips model for fitting thermal performance curves

Tomlinson-Phillips model for fitting thermal performance curves

## Usage

``` r
tomlinsonphillips_2015(temp, a, b, c)
```

## Arguments

- temp:

  temperature in degrees centigrade

- a:

  parameter similar to R at Tmin

- b:

  shape parameter indicating the slope of the upwards part of the curve

- c:

  peak position parameter, similar to Topt

## Value

a numeric vector of rate values based on the temperatures and parameter
values provided to the function

## Details

Equation: \$\$rate = a \cdot \[\exp{(b \cdot T) - \exp{(T-c)}}\]\$\$

Start values in `get_start_vals` are derived from the data or sensible
values from the literature.

Limits in `get_lower_lims` and `get_upper_lims` are derived from the
data or based extreme values that are unlikely to occur in ecological
settings.

## Note

Generally we found this model somewhat difficult to fit.

## References

Tomlinson, S. & Phillips, R. D. Differences in metabolic rate and
evaporative water loss associated with sexual dimorphism in thynnine
wasps. J. Insect Physiol. 78, 62–68 (2015).

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
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'tomlinsonphillips_2015')
# fit model
mod <- nls.multstart::nls_multstart(rate~tomlinsonphillips_2015(temp = temp, a, b, c),
data = d,
iter = c(3,3,3),
start_lower = start_vals - 10,
start_upper = start_vals + 10,
lower = get_lower_lims(d$temp, d$rate, model_name = 'tomlinsonphillips_2015'),
upper = get_upper_lims(d$temp, d$rate, model_name = 'tomlinsonphillips_2015'),
supp_errors = 'Y',
convergence_count = FALSE)

# look at model fit
summary(mod)
#> 
#> Formula: rate ~ tomlinsonphillips_2015(temp = temp, a, b, c)
#> 
#> Parameters:
#>   Estimate Std. Error t value Pr(>|t|)    
#> a  0.32024    0.26234   1.221    0.253    
#> b  0.02922    0.02230   1.310    0.223    
#> c 47.66374    1.21665  39.176 2.29e-11 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Residual standard error: 0.5378 on 9 degrees of freedom
#> 
#> Number of iterations to convergence: 81 
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
