# Sharpe-Schoolfield model (low temperature inactivation only) for fitting thermal performance curves

Sharpe-Schoolfield model (low temperature inactivation only) for fitting
thermal performance curves

## Usage

``` r
sharpeschoollow_1981(temp, r_tref, e, el, tl, tref)
```

## Arguments

- temp:

  temperature in degrees centigrade

- r_tref:

  rate at the standardised temperature, tref

- e:

  activation energy (eV)

- el:

  low temperature de-activation energy (eV)

- tl:

  temperature (ºC) at which enzyme is 1/2 active and 1/2 suppressed due
  to low temperatures

- tref:

  standardisation temperature in degrees centigrade. Temperature at
  which rates are not inactivated by high temperatures

## Value

a numeric vector of rate values based on the temperatures and parameter
values provided to the function

## Details

Equation: \$\$rate= \frac{r\_{tref} \cdot exp^{\frac{-e}{k}
(\frac{1}{temp + 273.15}-\frac{1}{t\_{ref} + 273.15})}}{1 +
exp^{\frac{e_l}{k}(\frac{1}{t_l} - \frac{1}{temp + 273.15})}}\$\$

where `k` is Boltzmann's constant with a value of 8.62e-05.

Start values in `get_start_vals` are derived from the data.

Limits in `get_lower_lims` and `get_upper_lims` are derived from the
data or based extreme values that are unlikely to occur in ecological
settings.

## Note

Generally we found this model easy to fit.

## References

Schoolfield, R. M., Sharpe, P. J. & Magnuson, C. E. Non-linear
regression of biological temperature-dependent rate models based on
absolute reaction-rate theory. J. Theor. Biol. 88, 719-731 (1981)

## Author

Daniel Padfield

## Examples

``` r
# load in ggplot
library(ggplot2)
library(nls.multstart)

# subset for the first TPC curve
data('chlorella_tpc')
d <- subset(chlorella_tpc, curve_id == 1)

# get start values and fit model
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'sharpeschoollow_1981')
# fit model
mod <- nls_multstart(rate~sharpeschoollow_1981(temp = temp, r_tref, e, el, tl, tref = 20),
data = d,
iter = c(3,3,3,3),
start_lower = start_vals - 10,
start_upper = start_vals + 10,
lower = get_lower_lims(d$temp, d$rate, model_name = 'sharpeschoollow_1981'),
upper = get_upper_lims(d$temp, d$rate, model_name = 'sharpeschoollow_1981'),
supp_errors = 'Y',
convergence_count = FALSE)

# look at model fit
summary(mod)
#> 
#> Formula: rate ~ sharpeschoollow_1981(temp = temp, r_tref, e, el, tl, tref = 20)
#> 
#> Parameters:
#>        Estimate Std. Error t value Pr(>|t|)  
#> r_tref   0.9922     1.0461   0.948   0.3707  
#> e        0.0000     0.3799   0.000   1.0000  
#> el       3.0121     5.5512   0.543   0.6022  
#> tl      23.2575     6.9849   3.330   0.0104 *
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Residual standard error: 0.5702 on 8 degrees of freedom
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
