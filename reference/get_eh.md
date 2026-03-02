# Estimate the deactivation energy of a thermal performance curve

Estimate the deactivation energy of a thermal performance curve

## Usage

``` r
get_eh(model)
```

## Arguments

- model:

  nls model object that contains a model of a thermal performance curve

## Value

Numeric estimate of activation energy (eV)

## Details

Fits a modified-Boltzmann equation to all raw data beyond the optimum
temperature (ºC; as estimated by `get_topt`).
