# Get a formula object for calling a TPC

Get a formula object for calling a TPC

## Usage

``` r
get_tpc_as_formula(model_name, temp, trait, explicit = FALSE)
```

## Arguments

- model_name:

  the name of the model being fitted

- temp:

  the name of the temperature column

- trait:

  the name of the trait column

- explicit:

  whether to return the formula constructed using the explicit form of
  the tpc function (e.g.
  [`rTPC::briere1_1999()`](https://padpadpadpad.github.io/rTPC/reference/briere1_1999.md))

## Value

A formula calling the expected TPC

## Author

Francis Windram

## Examples

``` r
get_tpc_as_formula("briere1_1999", "temperature", "rate")
#> rate ~ briere1_1999(temp = temperature, tmin, tmax, a)
#> <environment: 0x5588a3839100>
# > rate ~ briere1_1999(temp = temperature, tmin, tmax, a)
```
