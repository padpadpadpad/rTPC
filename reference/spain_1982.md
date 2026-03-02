# Spain model for fitting thermal performance curves

Spain model for fitting thermal performance curves

## Usage

``` r
spain_1982(temp, a, b, c, r0)
```

## Arguments

- temp:

  temperature in degrees centigrade

- a:

  constant that determines the steepness of the rising portion of the
  curve

- b:

  constant that determines the position of topt

- c:

  constant that determines the steepness of the decreasing part of the
  curve

- r0:

  the apparent rate at 0 ºC

## Value

a numeric vector of rate values based on the temperatures and parameter
values provided to the function

## Details

Equation: \$\$rate = r_0 \cdot exp^{a \cdot temp} \cdot (1-b \cdot
exp^{c \cdot temp})\$\$

Start values in `get_start_vals` are derived from the data or plucked
from thin air.

Limits in `get_lower_lims` and `get_upper_lims` are derived from the
data or plucked from thin air.

## Note

Generally we found this model easy to fit.

## References

BASIC Microcomputer Models in Biology. Addison-Wesley, Reading, MA. 1982

## Examples

``` r
# load in ggplot
library(ggplot2)

# subset for the first TPC curve
data('chlorella_tpc')
d <- subset(chlorella_tpc, curve_id == 1)

# get start values and fit model
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'spain_1982')
# fit model
mod <- nls.multstart::nls_multstart(rate~spain_1982(temp = temp, a, b, c, r0),
data = d,
iter = c(3,3,3,3),
start_lower = start_vals - 1,
start_upper = start_vals + 1,
lower = get_lower_lims(d$temp, d$rate, model_name = 'spain_1982'),
upper = get_upper_lims(d$temp, d$rate, model_name = 'spain_1982'),
supp_errors = 'Y',
convergence_count = FALSE)

# look at model fit
summary(mod)
#> 
#> Formula: rate ~ spain_1982(temp = temp, a, b, c, r0)
#> 
#> Parameters:
#>     Estimate Std. Error t value Pr(>|t|)
#> a  3.414e-02  3.032e-02   1.126    0.293
#> b  1.474e-12  7.972e-11   0.018    0.986
#> c  5.550e-01  1.104e+00   0.503    0.629
#> r0 2.833e-01  2.841e-01   0.997    0.348
#> 
#> Residual standard error: 0.5324 on 8 degrees of freedom
#> 
#> Number of iterations till stop: 97 
#> Achieved convergence tolerance: 1.49e-08
#> Reason stopped: Number of calls to `fcn' has reached or exceeded `maxfev' == 500.
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
