# Estimate optimum temperature of a thermal performance curve

Estimate optimum temperature of a thermal performance curve

## Usage

``` r
get_topt(model)
```

## Arguments

- model:

  nls model object that contains a model of a thermal performance curve

## Value

Numeric estimate of optimum temperature (in ºC)

## Details

Optimum temperature (ºC) is calculated by predicting over the
temperature range using the previously estimated parameters and keeping
the temperature where the largest rate value occurs. Predictions are
done every 0.001 ºC so the estimate of optimum temperature should be
accurate up to 0.001 ºC.
