# Lobry model for fitting thermal performance curves

Lobry model for fitting thermal performance curves

## Usage

``` r
lobry_1991(temp, rmax, topt, tmin, tmax)
```

## Arguments

- temp:

  temperature in degrees centigrade

- rmax:

  the maximum rate

- topt:

  optimum temperature (ºC) at which rates are maximal

- tmin:

  low temperature (ºC) at which rates become negative

- tmax:

  high temperature (ºC) at which rates become negative

## Value

a numeric vector of rate values based on the temperatures and parameter
values provided to the function

## Details

Equation: \$\$rate = rmax \cdot (1 - \frac{(temp - topt)^2)}{(temp -
topt)^2 + temp \cdot (tmax + tmin - temp) - tmax \cdot tmin}\$\$

Start values in `get_start_vals` are derived from the data or sensible
values from the literature.

Limits in `get_lower_lims` and `get_upper_lims` are derived from the
data or based extreme values that are unlikely to occur in ecological
settings.

## Note

Generally we found this model easy to fit.

## References

Lobry, J. R., Rosso, L., & Flandrois, J. P. (1991). A FORTRAN subroutine
for the determination of parameter confidence limits in non-linear
models. Binary, 3(86-93), 25.

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
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'lobry_1991')
# fit model
mod <- nls.multstart::nls_multstart(rate~lobry_1991(temp = temp, rmax, topt, tmin, tmax),
data = d,
iter = c(4,4,4,4),
start_lower = start_vals - 10,
start_upper = start_vals + 10,
lower = get_lower_lims(d$temp, d$rate, model_name = 'lobry_1991'),
upper = get_upper_lims(d$temp, d$rate, model_name = 'lobry_1991'),
supp_errors = 'Y',
convergence_count = FALSE)

# look at model fit
summary(mod)
#> 
#> Formula: rate ~ lobry_1991(temp = temp, rmax, topt, tmin, tmax)
#> 
#> Parameters:
#>       Estimate Std. Error   t value Pr(>|t|)    
#> rmax 1.272e+00  3.462e-01 3.675e+00  0.00626 ** 
#> topt 3.803e+01  2.721e+00 1.398e+01 6.65e-07 ***
#> tmin 1.600e+01  6.369e-18 2.512e+18  < 2e-16 ***
#> tmax 4.902e+01  1.331e+00 3.684e+01 3.23e-10 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Residual standard error: 0.3619 on 8 degrees of freedom
#> 
#> Number of iterations to convergence: 27 
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
