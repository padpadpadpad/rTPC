# Estimate thermal safety margin of a thermal performance curve

Estimate thermal safety margin of a thermal performance curve

## Usage

``` r
get_thermalsafetymargin(model)
```

## Arguments

- model:

  nls model object that contains a model of a thermal performance curve

## Value

Numeric estimate of thermal safety margin (in ºC)

## Details

Thermal safety margin is calculated as: CTmax - Topt. This is calculated
using the functions `get_ctmax` and `get_topt`.
