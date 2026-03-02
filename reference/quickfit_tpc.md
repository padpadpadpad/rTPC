# Perform a quick, automated, TPC fit

Performs a simple TPC fit using
[`nls_multstart`](https://rdrr.io/pkg/nls.multstart/man/nls_multstart.html).
This function tries to use a sensible default configuration, however if
you want to use the more custom elements of
[`nls_multstart`](https://rdrr.io/pkg/nls.multstart/man/nls_multstart.html)
then you will need to construct your own.

## Usage

``` r
quickfit_tpc(data, model_name, temp, trait, start_adjusts = 0, iter, ...)
```

## Arguments

- data:

  the data to fit a model to

- model_name:

  the model name as a string

- temp:

  the column name (as a string) containing the temperature data

- trait:

  the column name (as a string) containing the temperature data

- start_adjusts:

  any adjustments to make to the lower and upper starting bounds. If
  `0 < start_adjusts < 1`, this will be interpreted as a proportion of
  the base starting values.

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

The nls model object of the fit model

## Author

Francis Windram

## Examples

``` r
if (FALSE) { # \dontrun{
data("chlorella_tpc")

d <- subset(chlorella_tpc, curve_id == 1)

quickfit_tpc(
  d,
  "briere1_1999",
  "temp",
  "rate",
  start_adjusts = 10,
  iter = 150
)

quickfit_tpc(
  d,
  "briere1_1999",
  "temp",
  "rate",
  start_adjusts = 0.8,
  iter = c(5,5,5)
)
} # }
```
