# Estimate thermal tolerance of a thermal performance curve

Estimate thermal tolerance of a thermal performance curve

## Usage

``` r
get_thermaltolerance(model)
```

## Arguments

- model:

  nls model object that contains a model of a thermal performance curve

## Value

Thermal tolerance (in ºC)

## Details

Thermal tolerance is calculated as: CTmax - CTmin. This is calculated
using the functions `get_ctmax` and `get_ctmin`.
