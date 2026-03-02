# Simplified Beta-type model for fitting thermal performance curves

Simplified Beta-type model for fitting thermal performance curves

## Usage

``` r
betatypesimplified_2008(temp, rho, alpha, beta)
```

## Arguments

- temp:

  temperature in degrees centigrade

- rho:

  dimensionless parameter

- alpha:

  dimensionless parameter

- beta:

  dimensionless parameter

## Value

a numeric vector of rate values based on the temperatures and parameter
values provided to the function

## Details

Equation: \$\$rate = \rho \cdot \left(a - \frac{T}{10}\right) \cdot
\left(\frac{T}{10}\right)^b\$\$

Start values in `get_start_vals` are derived from the data or sensible
values from the literature.

Limits in `get_lower_lims` and `get_upper_lims` are derived from the
data or based extreme values that are unlikely to occur in ecological
settings.

## Note

Generally we found this model easy to fit.

## References

Damos, P. & Savopoulou-Soultani, M. Temperature-dependent bionomics and
modeling of Anarsia lineatella (Lepidoptera: Gelechiidae) in the
laboratory. J. Econ. Entomol. 101, 1557–1567 (2008).

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
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'betatypesimplified_2008')
# fit model
mod <- nls.multstart::nls_multstart(rate~betatypesimplified_2008(temp = temp, rho, alpha, beta),
data = d,
iter = c(7,7,7),
start_lower = start_vals - 10,
start_upper = start_vals + 10,
lower = get_lower_lims(d$temp, d$rate, model_name = 'betatypesimplified_2008'),
upper = get_upper_lims(d$temp, d$rate, model_name = 'betatypesimplified_2008'),
supp_errors = 'Y',
convergence_count = FALSE)

# look at model fit
summary(mod)
#> 
#> Formula: rate ~ betatypesimplified_2008(temp = temp, rho, alpha, beta)
#> 
#> Parameters:
#>       Estimate Std. Error t value Pr(>|t|)    
#> rho   0.007730   0.005718   1.352 0.209431    
#> alpha 4.868080   0.077947  62.454 3.49e-13 ***
#> beta  3.834485   0.595151   6.443 0.000119 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Residual standard error: 0.3108 on 9 degrees of freedom
#> 
#> Number of iterations to convergence: 57 
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
