# Thomas model (2017) for fitting thermal performance curves

Thomas model (2017) for fitting thermal performance curves

## Usage

``` r
thomas_2017(temp, a, b, c, d, e)
```

## Arguments

- temp:

  temperature in degrees centigrade

- a:

  birth rate at 0 ºC

- b:

  describes the exponential increase in birth rate with increasing
  temperature

- c:

  temperature-independent mortality term

- d:

  along with e controls the exponential increase in mortality rates with
  temperature

- e:

  along with d controls the exponential increase in mortality rates with
  temperature

## Value

a numeric vector of rate values based on the temperatures and parameter
values provided to the function

## Details

Equation: \$\$rate = a \cdot exp^{b \cdot temp} - (c + d \cdot exp^{e
\cdot temp})\$\$

Start values in `get_start_vals` are derived from the data.

Limits in `get_lower_lims` and `get_upper_lims` are derived from the
data or based on extreme values that are unlikely to occur in ecological
settings.

## Note

Generally we found this model easy to fit.

## References

Thomas, Mridul K., et al. Temperature–nutrient interactions exacerbate
sensitivity to warming in phytoplankton. Global change biology 23.8
(2017): 3269-3280.

## Examples

``` r
# load in ggplot
library(ggplot2)

# subset for the first TPC curve
data('chlorella_tpc')
d <- subset(chlorella_tpc, curve_id == 1)

# get start values and fit model
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'thomas_2017')
# fit model
mod <- nls.multstart::nls_multstart(rate~thomas_2017(temp = temp, a, b, c, d, e),
data = d,
iter = c(3,3,3,3,3),
start_lower = start_vals - 10,
start_upper = start_vals + 10,
lower = get_lower_lims(d$temp, d$rate, model_name = 'thomas_2017'),
upper = get_upper_lims(d$temp, d$rate, model_name = 'thomas_2017'),
supp_errors = 'Y',
convergence_count = FALSE)

# look at model fit
summary(mod)
#> 
#> Formula: rate ~ thomas_2017(temp = temp, a, b, c, d, e)
#> 
#> Parameters:
#>     Estimate Std. Error t value Pr(>|t|)
#> a -1.046e+01  6.740e+05   0.000    1.000
#> b  7.477e-02  3.390e+01   0.002    0.998
#> c  1.342e+00  1.285e+01   0.104    0.920
#> d -1.106e+01  6.740e+05   0.000    1.000
#> e  7.369e-02  3.379e+01   0.002    0.998
#> 
#> Residual standard error: 0.3609 on 7 degrees of freedom
#> 
#> Number of iterations till stop: 96 
#> Achieved convergence tolerance: 1.49e-08
#> Reason stopped: Number of calls to `fcn' has reached or exceeded `maxfev' == 600.
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
