# Modified deutsch model for fitting thermal performance curves

Modified deutsch model for fitting thermal performance curves

## Usage

``` r
deutsch_2008(temp, rmax, topt, ctmax, a)
```

## Arguments

- temp:

  temperature in degrees centigrade

- rmax:

  maximum rate at optimum temperature

- topt:

  optimum temperature (ºC)

- ctmax:

  critical thermal maximum (ºC)

- a:

  related to the full curve width

## Value

a numeric vector of rate values based on the temperatures and parameter
values provided to the function

## Details

Equation: \$\$\textrm{if} \quad temp \< t\_{opt}: rate = r\_{max} \cdot
exp^{-\bigg(\frac{temp-t\_{opt}}{2a}\bigg)^2}\$\$ \$\$\textrm{if} \quad
temp \> t\_{opt}: rate = r\_{max} \cdot \left(1 - \bigg(\frac{temp -
t\_{opt}}{t\_{opt} - ct\_{max}}\bigg)^2\right)\$\$

Start values in `get_start_vals` are derived from the data.

Limits in `get_lower_lims` and `get_upper_lims` are based on extreme
values that are unlikely to occur in ecological settings.

## Note

Generally we found this model easy to fit.

## References

Deutsch, C. A., Tewksbury, J. J., Huey, R. B., Sheldon, K. S.,
Ghalambor, C. K., Haak, D. C., & Martin, P. R. Impacts of climate
warming on terrestrial ectotherms across latitude. Proceedings of the
National Academy of Sciences, 105(18), 6668-6672. (2008)

## Examples

``` r
# load in ggplot
library(ggplot2)

# subset for the first TPC curve
data('chlorella_tpc')
d <- subset(chlorella_tpc, curve_id == 1)

# get start values and fit model
start_vals <- get_start_vals(d$temp, d$rate, model_name = 'deutsch_2008')
# fit model
mod <- nls.multstart::nls_multstart(rate~deutsch_2008(temp = temp, rmax, topt, ctmax, a),
data = d,
iter = c(4,4,4,4),
start_lower = start_vals - 10,
start_upper = start_vals + 10,
lower = get_lower_lims(d$temp, d$rate, model_name = 'deutsch_2008'),
upper = get_upper_lims(d$temp, d$rate, model_name = 'deutsch_2008'),
supp_errors = 'Y',
convergence_count = FALSE)

# look at model fit
summary(mod)
#> 
#> Formula: rate ~ deutsch_2008(temp = temp, rmax, topt, ctmax, a)
#> 
#> Parameters:
#>       Estimate Std. Error t value Pr(>|t|)    
#> rmax    1.4363     0.1639   8.765 2.25e-05 ***
#> topt   38.2306     2.7887  13.709 7.73e-07 ***
#> ctmax  48.7175     0.9798  49.722 2.96e-11 ***
#> a       6.7950     1.9474   3.489  0.00821 ** 
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Residual standard error: 0.3105 on 8 degrees of freedom
#> 
#> Number of iterations to convergence: 34 
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
