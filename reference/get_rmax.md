# Estimate maximum rate of a thermal performance curve

Estimate maximum rate of a thermal performance curve

## Usage

``` r
get_rmax(model)
```

## Arguments

- model:

  nls model object that contains a model of a thermal performance curve

## Value

Numeric estimate of maximum rate

## Details

Maximum rate is calculated by predicting over the temperature range
using the previously estimated parameters and picking the maximum rate
value. Predictions are done every 0.001 ºC.
