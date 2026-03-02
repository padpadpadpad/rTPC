# Estimate thermal performance breadth of a thermal performance curve

Estimate thermal performance breadth of a thermal performance curve

## Usage

``` r
get_breadth(model, level = 0.8)
```

## Arguments

- model:

  nls model object that contains a model of a thermal performance curve

- level:

  proportion of maximum rate over which thermal performance breadth is
  calculated

## Value

Numeric estimate of thermal performance breadth (in ºC)

## Details

Thermal performance breadth is calculated as the range of temperatures
over which a curve's rate is at least 0.8 of peak. This defaults to a
proportion of 0.8 but can be changed using the `level` argument.
