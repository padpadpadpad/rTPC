# flexTPC model for fitting thermal performance curves

flexTPC model for fitting thermal performance curves

## Usage

``` r
flextpc_2024(temp, tmin, tmax, rmax, alpha, beta)
```

## Arguments

- temp:

  temperature in degrees centigrade

- tmin:

  low temperature (ºC) at which rates become negative

- tmax:

  high temperature (ºC) at which rates become negative

- rmax:

  maximum performance/value of the trait

- alpha:

  shape parameter to adjust the asymmetry and direction of skew of the
  curve

- beta:

  shape parameter to adjust the breadth of the curve

## Value

a numeric vector of rate values based on the temperatures and parameter
values provided to the function

## Details

Equation: \$\$rate=r\_{\text{max}}\left\[\left(\frac{T -
T\_{\text{min}}}{\alpha}\right)^\alpha\left(\frac{T\_{\text{max}}-T}{1-\alpha}\right)^{1-\alpha}\left(\frac{1}{T\_{\text{max}}-T\_{\text{min}}}\right)\right\]^{\frac{\alpha(1-\alpha)}{\beta^2}}\$\$

Start values in `get_start_vals` are derived from the data or sensible
values from the literature.

Limits in `get_lower_lims` and `get_upper_lims` are derived from the
data or based extreme values that are unlikely to occur in ecological
settings.

## Note

Generally this model requires larger iter values in nls_multstart to fit
reliably.

## References

Cruz-Loya M, Mordecai EA, Savage VM. A flexible model for thermal
performance curves. bioRxiv \[Preprint\]. 2024

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
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'flextpc_2024')
# fit model
mod <- nls.multstart::nls_multstart(rate~flextpc_2024(temp = temp, tmin, tmax, rmax, alpha, beta),
data = d,
iter = c(5,5,5,5,5),
start_lower = start_vals - 10,
start_upper = start_vals + 10,
lower = get_lower_lims(d$temp, d$rate, model_name = 'flextpc_2024'),
upper = get_upper_lims(d$temp, d$rate, model_name = 'flextpc_2024'),
supp_errors = 'Y',
convergence_count = FALSE)

# look at model fit
summary(mod)
#> 
#> Formula: rate ~ flextpc_2024(temp = temp, tmin, tmax, rmax, alpha, beta)
#> 
#> Parameters:
#>       Estimate Std. Error t value Pr(>|t|)    
#> tmin   -9.2463   157.0209  -0.059 0.954689    
#> tmax   49.0000    10.0356   4.883 0.001788 ** 
#> rmax    1.5386     0.2002   7.686 0.000118 ***
#> alpha   0.8077     0.4131   1.955 0.091478 .  
#> beta    0.1239     0.3873   0.320 0.758420    
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Residual standard error: 0.2895 on 7 degrees of freedom
#> 
#> Number of iterations to convergence: 58 
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
