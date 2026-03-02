# Rezende model for fitting thermal performance curves

Rezende model for fitting thermal performance curves

## Usage

``` r
rezende_2019(temp, q10, a, b, c)
```

## Arguments

- temp:

  temperature in degrees centigrade

- q10:

  defines the fold change in performance as a result of increasing the
  temperature by 10 ºC

- a:

  parameter describing shifts in rate

- b:

  parameter threshold temperature (ºC) beyond which the downward curve
  starts

- c:

  parameter controlling the rate of decline beyond the threshold
  temperature, b

## Value

a numeric vector of rate values based on the temperatures and parameter
values provided to the function

## Details

Equation: \$\$\textrm{if} \quad temp \< b: rate = a \cdot 10
^{\frac{\log\_{10} (q\_{10})}{(\frac{10}{temp})}}\$\$ \$\$\textrm{if}
\quad temp \> b: rate = a \cdot 10 ^{\frac{\log\_{10}
(q\_{10})}{(\frac{10}{temp})}} \cdot \bigg(1-c \cdot (b-temp)^2
\bigg)\$\$

Start values in `get_start_vals` are derived from the data and previous
values in the literature.

Limits in `get_lower_lims` and `get_upper_lims` are based on extreme
values that are unlikely to occur in ecological settings.

## Note

Generally we found this model easy to fit.

## References

Rezende, Enrico L., and Francisco Bozinovic. Thermal performance across
levels of biological organization. Philosophical Transactions of the
Royal Society B 374.1778 (2019): 20180549.

## Examples

``` r
# load in ggplot
library(ggplot2)

# subset for the first TPC curve
data('chlorella_tpc')
d <- subset(chlorella_tpc, curve_id == 1)

# get start values and fit model
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'rezende_2019')
# fit model
mod <- nls.multstart::nls_multstart(rate~rezende_2019(temp = temp, q10, a, b, c),
data = d,
iter = c(4,4,4,4),
start_lower = start_vals - 10,
start_upper = start_vals + 10,
lower = get_lower_lims(d$temp, d$rate, model_name = 'rezende_2019'),
upper = get_upper_lims(d$temp, d$rate, model_name = 'rezende_2019'),
supp_errors = 'Y',
convergence_count = FALSE)

# look at model fit
summary(mod)
#> 
#> Formula: rate ~ rezende_2019(temp = temp, q10, a, b, c)
#> 
#> Parameters:
#>      Estimate Std. Error t value Pr(>|t|)
#> q10  2.194462   1.646887   1.332    0.219
#> a    0.087894   0.162598   0.541    0.604
#> b   27.888234  34.821536   0.801    0.446
#> c    0.002319   0.007783   0.298    0.773
#> 
#> Residual standard error: 0.3618 on 8 degrees of freedom
#> 
#> Number of iterations to convergence: 38 
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
