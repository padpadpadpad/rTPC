# Ashrafi I model for fitting thermal performance curves

Ashrafi I model for fitting thermal performance curves

## Usage

``` r
ashrafi1_2018(temp, a, b, c)
```

## Arguments

- temp:

  temperature in degrees centigrade

- a:

  dimensionless parameter

- b:

  dimensionless parameter

- c:

  dimensionless parameter

## Value

a numeric vector of rate values based on the temperatures and parameter
values provided to the function

## Details

Equation: \$\$rate=a + b \cdot temp^{2} + log(temp) + c \cdot
temp^{3}\$\$

Start values in `get_start_vals` are derived from the data or sensible
values from the literature.

Limits in `get_lower_lims` and `get_upper_lims` are derived from the
data or based extreme values that are unlikely to occur in ecological
settings.

## Note

Generally we found this model easy to fit.

## References

Ashrafi, R. et al. Broad thermal tolerance is negatively correlated with
virulence in an opportunistic bacterial pathogen. Evolutionary
Applications 11, 1700–1714 (2018).

## Author

Daniel Padfield

## Examples

``` r
# load in ggplot
library(ggplot2)

# subset for the first TPC curve
data('chlorella_tpc')
d <- subset(chlorella_tpc, curve_id == 1)

# get start values and fit model
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'ashrafi1_2018')
# fit model
mod <- nls.multstart::nls_multstart(rate~ashrafi1_2018(temp = temp, a, b, c),
data = d,
iter = c(4,4,4),
start_lower = start_vals - 10,
start_upper = start_vals + 10,
lower = get_lower_lims(d$temp, d$rate, model_name = 'ashrafi1_2018'),
upper = get_upper_lims(d$temp, d$rate, model_name = 'ashrafi2_2018'),
supp_errors = 'Y',
convergence_count = FALSE)

# look at model fit
summary(mod)
#> 
#> Formula: rate ~ ashrafi1_2018(temp = temp, a, b, c)
#> 
#> Parameters:
#>     Estimate Std. Error t value Pr(>|t|)    
#> a -4.691e+00  8.661e-01  -5.417 0.000424 ***
#> b  1.172e-01  4.223e-02   2.776 0.021552 *  
#> c -4.008e-05  1.214e-05  -3.301 0.009221 ** 
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Residual standard error: 0.3909 on 9 degrees of freedom
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
