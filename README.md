
<!-- README.md is generated from README.Rmd. Please edit that file -->

# **rTPC** <img src="logo.png" width="250" align="right" />

**rTPC** is an R package that helps fit thermal performance curves
(TPCs) in R. **rTPC** contains 23 model formulations previously used to
fit TPCs and has helper functions to help set sensible start parameters,
upper and lower parameter limits and estimate parameters useful in
downstream analyses, such as cardinal temperatures, maximum rate and
optimum temperature.

The idea behind **rTPC** is to make fitting thermal performance curves
easier, but we made a conscious decision not to repeat code and methods
that are already optimised and available in the R ecosystem.
Consequently, the workflows take advantage of
[**nls.multstart**](https://github.com/padpadpadpad/nls.multstart) for
fitting non-linear least squares regression and packages from the
[**tidyverse**](https://www.tidyverse.org) for data manipulation,
fitting multiple models, and visualisation.

This R package and the pipelines outlined in the vignettes are in the
process of being written up into a methods paper. In the meantime,
please cite as:

Daniel Padfield and Hannah O’Sullivan (2020). rTPC: an R package for
helping fit thermal performance curves. R package version. 0.1.0.

## Bugs and suggestions

Please report any bugs and suggestions to the
[Issues](https://github.com/padpadpadpad/rTPC/issues) or email
<d.padfield@exeter.ac.uk>.

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/padpadpadpad/rTPC.svg?branch=master)](https://travis-ci.org/padpadpadpad/rTPC)
<!-- badges: end -->

## Installation

**rTPC** can easily be downloaded from GitHub using the
`remotes::install_github()`. The vignettes available with the package
can be downloaded by adding `build_vignettes = TRUE`.

``` r
# install package from GitHub
remotes::install_github("padpadpadpad/rTPC", build_vignettes = TRUE)
```

## General pipeline

**rTPC** makes it easy to fit multiple models to multiple thermal
performance curves.

<img src="man/figures/rTPC_pipeline.png" width="1000" align="center" />

**Figure 1. General pipeline for fitting thermal performance curves
using rTPC**. First, Collect, check, and manipulate data into long
format. Next Choose which model from **rTPC** are going to be used.
Here, a random assortment of four models were chosen. Then fit the
models to data using **nls.multstart** and helper functions from
**rTPC**. Model can then be visualised using the **tidyverse** suite of
packages and common traits of TPCs can be estimated using
**rTPC::est\_params()**. This simple pipeline can easily be scaled up to
be used on multiple curves.
