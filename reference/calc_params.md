# Calculate extra parameters of a thermal performance curve

Calculate extra parameters of a thermal performance curve

## Usage

``` r
calc_params(model, ...)
```

## Arguments

- model:

  nls model object that contains a model of a thermal performance curve

- ...:

  additional arguments to pass to any of the functions used to estimate
  the traits. For example you can change the level argument of
  [`get_breadth()`](https://padpadpadpad.github.io/rTPC/reference/get_breadth.md).

## Value

a dataframe containing the estimates of key TPC traits for a given model
object. If any parameters cannot be calculated for a thermal performance
curve, they will return `NA`.

## Details

Currently estimates:

- maximum rate (rmax) using
  [`get_rmax()`](https://padpadpadpad.github.io/rTPC/reference/get_rmax.md)

- optimum temperature (topt) using
  [`get_topt()`](https://padpadpadpad.github.io/rTPC/reference/get_topt.md)

- critical thermal maximum (ctmax) using
  [`get_ctmax()`](https://padpadpadpad.github.io/rTPC/reference/get_ctmax.md)

- critical thermal minimum (ctmin) using
  [`get_ctmin()`](https://padpadpadpad.github.io/rTPC/reference/get_ctmin.md)

- activation energy (e) using
  [`get_e()`](https://padpadpadpad.github.io/rTPC/reference/get_e.md)

- deactivation energy (eh) using
  [`get_eh()`](https://padpadpadpad.github.io/rTPC/reference/get_eh.md)

- q10 value using
  [`get_q10()`](https://padpadpadpad.github.io/rTPC/reference/get_q10.md)

- thermal safety margin using
  [`get_thermalsafetymargin()`](https://padpadpadpad.github.io/rTPC/reference/get_thermalsafetymargin.md)

- thermal tolerance using
  [`get_thermaltolerance()`](https://padpadpadpad.github.io/rTPC/reference/get_thermaltolerance.md)

- thermal performance breadth using
  [`get_breadth()`](https://padpadpadpad.github.io/rTPC/reference/get_breadth.md)

- skewness using
  [`get_skewness()`](https://padpadpadpad.github.io/rTPC/reference/get_skewness.md)
