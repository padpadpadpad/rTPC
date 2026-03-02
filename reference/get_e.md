# Estimate the activation energy of a thermal performance curve

Estimate the activation energy of a thermal performance curve

## Usage

``` r
get_e(model)
```

## Arguments

- model:

  nls model object that contains a model of a thermal performance curve

## Value

Numeric estimate of activation energy (eV)

## Details

Fits a modified-Boltzmann equation to all raw data below the optimum
temperature (ºC; as estimated by `get_topt`).
