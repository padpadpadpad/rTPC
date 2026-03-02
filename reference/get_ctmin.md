# Estimate the critical thermal minimum of a thermal performance curve

Estimate the critical thermal minimum of a thermal performance curve

## Usage

``` r
get_ctmin(model)
```

## Arguments

- model:

  nls model object that contains a model of a thermal performance curve

## Value

Numeric estimate of critical thermal minimum (ºC)

## Details

Optimum temperature is calculated by predicting over a temperature range
50 degrees lower than the minimum value in the dataset. The predicted
rate value closest to 0 is then extracted. When this is impossible due
to the curve formula (i.e the Sharpe-Schoolfield model), the temperature
where the rate is 5 percent of the maximum rate is estimated.
Predictions are done every 0.001 ºC value so the estimate of the
critical thermal minimum should be accurate up to 0.001 ºC.
