# Perform an automated quick tpc fit across models and curves

Performs a TPC fit using
[`nls_multstart`](https://rdrr.io/pkg/nls.multstart/man/nls_multstart.html)
and [`map`](https://purrr.tidyverse.org/reference/map.html). This
function tries to use a sensible default configuration, however if you
need to to use the more custom elements of
[`nls_multstart`](https://rdrr.io/pkg/nls.multstart/man/nls_multstart.html)
then you will need to construct your own.

## Usage

``` r
quickfit_tpc_multi(
  data,
  model_names,
  temp,
  trait,
  start_adjusts = 0,
  iter,
  ...
)
```

## Arguments

- data:

  the data to fit a model to

- model_names:

  a vector of model names to fit as strings

- temp:

  the column name (as a string) containing the temperature data

- trait:

  the column name (as a string) containing the temperature data

- start_adjusts:

  any adjustments to make to the lower and upper starting bounds. If
  `0 < start_adjusts < 1`, this will be interpreted as a proportion of
  the base starting values. If above 1, it will add and substract that
  value from the base starting values.

- iter:

  number of combinations of starting parameters which will be tried . If
  a single value is provided, then a shotgun/random-search/lhs approach
  will be used to sample starting parameters from a uniform distribution
  within the starting parameter bounds. If a vector of the same length
  as the number of parameters is provided, then a gridstart approach
  will be used to define each combination of that number of equally
  spaced intervals across each of the starting parameter bounds
  respectively. Thus, c(5,5,5) for three fitted parameters yields 125
  model fits. Supplying a vector for iter will override
  convergence_count.

- ...:

  additional arguments to pass to
  [`nls_multstart`](https://rdrr.io/pkg/nls.multstart/man/nls_multstart.html).

## Value

A tibble of model fits

## Note

The parameters `temp`, `trait`, `start_adjusts`, `iter`, `lhstype`,
`gridstart`, or `force` can be specified per-model by providing a vector
of values of a length equal to the number of models to be fit.

## Author

Francis Windram

Daniel Padfield

## Examples

``` r
if (FALSE) { # \dontrun{
# load example data
data("chlorella_tpc")

# subset for just the first 5 curves
d <- subset(chlorella_tpc, curve_id <= 5)


quickfit_tpc_multi(d, c("briere1_1999", "briere2_1999"), "temp", "rate")

quickfit_tpc_multi(d, c("briere1_1999", "briere2_1999"), "temp", "rate", start_adjusts = 10)

quickfit_tpc_multi(d, c("briere1_1999", "briere2_1999"), "temp", "rate", iter = c(100, 150))
} # }
```
