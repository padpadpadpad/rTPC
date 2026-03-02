# Janisch I model for fitting thermal performance curves

Janisch I model for fitting thermal performance curves

## Usage

``` r
janisch1_1925(temp, m, a, topt)
```

## Arguments

- temp:

  temperature in degrees centigrade

- m:

  scale parameter (controlling the height of the curve)

- a:

  shape parameter (controlling the shape of the curve)

- topt:

  temperature of max performance (ºC)

## Value

a numeric vector of rate values based on the temperatures and parameter
values provided to the function

## Details

Equation: \$\$rate = \frac{1}{\frac{m}{2} \cdot
\left\[a^{T-T\_{\text{opt}}}+a^{-(T-T\_{\text{opt}})}\right\]}\$\$

Start values in `get_start_vals` are derived from the data or sensible
values from the literature.

Limits in `get_lower_lims` and `get_upper_lims` are based on extreme
values that are unlikely to occur in ecological settings.

## Note

Generally we found this model easy to fit.

## References

Janisch, E. Über die Temperaturabhängigkeit biologischer Vorgänge und
ihre kurvenmäßige Analyse. Pflüger's Arch. Physiol. 209, 414–436 (1925).

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
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'janisch1_1925')
# fit model
mod <- nls.multstart::nls_multstart(rate~janisch1_1925(temp = temp, m, a, topt),
data = d,
iter = 200,
start_lower = start_vals - 10,
start_upper = start_vals + 10,
lower = get_lower_lims(d$temp, d$rate, model_name = 'janisch1_1925'),
upper = get_upper_lims(d$temp, d$rate, model_name = 'janisch1_1925'),
supp_errors = 'Y',
convergence_count = FALSE)

# look at model fit
summary(mod)
#> 
#> Formula: rate ~ janisch1_1925(temp = temp, m, a, topt)
#> 
#> Parameters:
#>      Estimate Std. Error t value Pr(>|t|)    
#> m     0.64569    0.09142   7.063 5.90e-05 ***
#> a     0.84671    0.02766  30.614 2.07e-10 ***
#> topt 36.81111    1.12499  32.721 1.14e-10 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Residual standard error: 0.329 on 9 degrees of freedom
#> 
#> Number of iterations to convergence: 51 
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
