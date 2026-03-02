# Flinn model for fitting thermal performance curves

Flinn model for fitting thermal performance curves

## Usage

``` r
flinn_1991(temp, a, b, c)
```

## Arguments

- temp:

  temperature in degrees centigrade

- a:

  parameter that controls the height of the curve

- b:

  parameter that controls the slope of the initial increase of the curve

- c:

  parameter that controls the position and steepness of the decline of
  the curve

## Value

a numeric vector of rate values based on the temperatures and parameter
values provided to the function

## Details

Equation: \$\$rate= \frac{1}{1+a+b \cdot temp+c \cdot temp^2}\$\$

Start values in `get_start_vals` are derived from previous methods from
the literature.

Limits in `get_lower_lims` and `get_upper_lims` are based on extreme
values that are unlikely to occur in ecological settings.

## Note

Generally we found this model easy to fit.

## References

Flinn PW Temperature-dependent functional response of the parasitoid
Cephalonomia waterstoni (Gahan) (Hymenoptera, Bethylidae) attacking
rusty grain beetle larvae (Coleoptera, Cucujidae). Environmental
Entomology, 20, 872–876, (1991)

## Examples

``` r
# load in ggplot
library(ggplot2)

# subset for the first TPC curve
data('chlorella_tpc')
d <- subset(chlorella_tpc, curve_id == 1)

# get start values and fit model
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'flinn_1991')
# fit model
mod <- nls.multstart::nls_multstart(rate~flinn_1991(temp = temp, a, b, c),
data = d,
iter = c(4,4,4),
start_lower = start_vals - 1,
start_upper = start_vals + 1,
lower = get_lower_lims(d$temp, d$rate, model_name = 'flinn_1991'),
upper = get_upper_lims(d$temp, d$rate, model_name = 'flinn_1991'),
supp_errors = 'Y',
convergence_count = FALSE)

# look at model fit
summary(mod)
#> 
#> Formula: rate ~ flinn_1991(temp = temp, a, b, c)
#> 
#> Parameters:
#>    Estimate Std. Error t value Pr(>|t|)  
#> a 15.736392   6.184659   2.544   0.0315 *
#> b -0.865546   0.333214  -2.598   0.0289 *
#> c  0.011626   0.004482   2.594   0.0290 *
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Residual standard error: 0.3336 on 9 degrees of freedom
#> 
#> Number of iterations to convergence: 45 
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
