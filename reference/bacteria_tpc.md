# Example thermal performance curves of bacterial growth

A dataset containing example data of growth rates of the bacteria
Pseudomonas fluorescens in the presence and absence of its phage, phi2.
Growth rates were measured across a range of assay temperatures to
incorporate the entire thermal performance of the bacteria The dataset
is the cleaned version so some data points have been omitted. There are
multiple independent measurements per temperature for each treatment.

## Usage

``` r
data("bacteria_tpc")
```

## Format

A data frame with 649 rows and 7 variables:

- phage:

  whether the bacteria was grown with or without phage

- temp:

  the assay temperature at which the growth rate was measured (degrees
  centigrade)

- rate:

  estimated growth rate per hour

## Source

Daniel Padfield

## References

Padfield, D., Castledine, M., & Buckling, A. (2020).
Temperature-dependent changes to host–parasite interactions alter the
thermal performance of a bacterial host. The ISME Journal, 14(2),
389-398.

## Examples

``` r
data("bacteria_tpc")
library(ggplot2)
ggplot(bacteria_tpc) +
 geom_point(aes(temp, rate, col = phage))
```
