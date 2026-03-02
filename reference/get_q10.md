# Estimate the q10 value of a thermal performance curve

Estimate the q10 value of a thermal performance curve

## Usage

``` r
get_q10(model)
```

## Arguments

- model:

  nls model object that contains a model of a thermal performance curve

## Value

Numeric estimate of q10 value

## Details

Fits the q10 portion of `rezende_2019` to all raw data below the optimum
temperature (ºC; as estimated by `get_topt`).
