# O'Neill model for fitting thermal performance curves

O'Neill model for fitting thermal performance curves

## Usage

``` r
oneill_1972(temp, rmax, ctmax, topt, q10)
```

## Arguments

- temp:

  temperature in degrees centigrade

- rmax:

  maximum rate at optimum temperature

- ctmax:

  high temperature (ºC) at which rates become negative

- topt:

  optimum temperature (ºC)

- q10:

  defines the fold change in performance as a result of increasing the
  temperature by 10 ºC

## Value

a numeric vector of rate values based on the temperatures and parameter
values provided to the function

## Details

Equation: \$\$rate = r\_{max} \cdot \bigg(\frac{ct\_{max} -
temp}{ct\_{max} - t\_{opt}}\bigg)^{x} \cdot exp^{x \cdot \frac{temp -
t\_{opt}}{ct\_{max} - t\_{opt}}}\$\$ \$\$where: x =
\frac{w^{2}}{400}\cdot\bigg(1 + \sqrt{1 + \frac{40}{w}}\bigg)^{2}\$\$
\$\$and:\\ w = (q\_{10} - 1)\cdot (ct\_{max} - t\_{opt})\$\$

Start values in `get_start_vals` are derived from the data and previous
values in the literature

Limits in `get_lower_lims` and `get_upper_lims` are based on extreme
values that are unlikely to occur in ecological settings.

## Note

Generally we found this model easy to fit.

## References

O’Neill, R.V., Goldstein, R.A., Shugart, H.H., Mankin, J.B. Terrestrial
Ecosystem Energy Model. Eastern Deciduous Forest Biome Memo Report Oak
Ridge. The Environmental Sciences Division of the Oak Ridge National
Laboratory. (1972)

## Examples

``` r
# load in ggplot
library(ggplot2)

# subset for the first TPC curve
data('chlorella_tpc')
d <- subset(chlorella_tpc, curve_id == 1)

# get start values and fit model
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'oneill_1972')
# fit model
mod <- nls.multstart::nls_multstart(rate~oneill_1972(temp = temp, rmax, ctmax, topt, q10),
data = d,
iter = c(4,4,4,4),
start_lower = start_vals - 10,
start_upper = start_vals + 10,
lower = get_lower_lims(d$temp, d$rate, model_name = 'oneill_1972'),
upper = get_upper_lims(d$temp, d$rate, model_name = 'oneill_1972'),
supp_errors = 'Y',
convergence_count = FALSE)

# look at model fit
summary(mod)
#> 
#> Formula: rate ~ oneill_1972(temp = temp, rmax, ctmax, topt, q10)
#> 
#> Parameters:
#>       Estimate Std. Error t value Pr(>|t|)    
#> rmax    1.5550     0.1627   9.555 1.19e-05 ***
#> ctmax  49.0000     5.1139   9.582 1.17e-05 ***
#> topt   37.6725     1.3291  28.344 2.59e-09 ***
#> q10     1.9206     0.2243   8.562 2.67e-05 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Residual standard error: 0.2657 on 8 degrees of freedom
#> 
#> Number of iterations to convergence: 47 
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
