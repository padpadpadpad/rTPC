# Estimates skewness of a thermal performance curve

Estimates skewness of a thermal performance curve

## Usage

``` r
get_skewness(model)
```

## Arguments

- model:

  nls model object that contains a model of a thermal performance curve

## Value

Numeric estimate of skewness

## Details

Skewness is calculated from the values of activation energy (e) and
deactivation energy (eh) as: skewness = e - eh. A negative skewness
indicates the TPC is left skewed, the drop after the optimum is steeper
than the rise up to the optimum. A positive skewness means that the TPC
is right skewed and a value of 0 would mean the curve is symmetrical
around the optimum.
