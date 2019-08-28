
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rTPC <img src="logos/hex_sticker.png" width="250" align="right" />

**rTPC** is an R package that helps fit thermal performance curves
(TPCs) in R. It contains all the models previously used to fit TPCs and
has helper functions to help in setting sensible start parameters, upper
and lower parameter limits and estimating parameters useful in
downstream analyses, such as cardinal temperatures, maximum rate and
optimum temperature.

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/padpadpadpad/rTPC.svg?branch=master)](https://travis-ci.org/padpadpadpad/rTPC)
<!-- badges: end -->

## Installation

**rTPC** can easily be downloaded from GitHub using the
`remotes::install_github()`.

``` r
# install package from GitHub
remotes::install_github("padpadpadpad/rTPC")
```

We also need to install a bunch of other packages that will help with
the analysis pipeline.

``` r
# install other packages
install.packages('nls.multstart')
install.packages('purrr')
install.packages('dplyr')
install.packages('tidyr')
install.packages('ggplot2')
install.packages('broom')
install.packages('MuMIn')
```

Then we need to load in all the necessary packages.

``` r
# load in packages
library(purrr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(broom)
library(MuMIn)
library(rTPC)
library(nls.multstart)

# write function to label ggplot2 panels
label_facets_num <- function(string){
  len <- length(string)
  string = paste('(', 1:len, ') ', string, sep = '')
  return(string)
}

# write function to convert label text size to points
pts <- function(x){
  as.numeric(grid::convertX(grid::unit(x, 'points'), 'mm'))
}
```

## Before you start modelling

Before fitting any of these models, it is likely that some filtering and
cleaning of the data needs to be done. Some things you should consider
are:

  - How many data points do you have for each curve? The more points the
    better for getting the best curve fits, but at the very least, there
    needs to be more points than unknown parameters. To fit all of the
    curves included here, that would mean having a minimum of 7 points
    per curve.
  - Do you have negative rate values? If you have a curve that crosses
    the x axis (i.e. there are negative rates), it might be beneficial
    to only consider models that are capable of modelling negative
    values. A summary of the models previously used in the literature is
    in the process of being made.
  - How is your data organised? If you have multiple curves, it makes
    sense to have your data in long format, where grouping variables,
    temperature and rate have their own columns, and different curves
    take up multiple rows, rather than a single row encompassing a
    single curve.

After you are happy that you understand your dataset and want to start
modelling your TPCs, we can do so using **rTPC**,
[**nls.multstart**](https://github.com/padpadpadpad/nls.multstart) and
tools from the **tidyverse**.

## Fitting multiple models to a single curve

**rTPC** makes it easy to fit multiple different models to the same
data. To fit each curve, we will use **nls.multstart**, which allows for
multiple starting parameters when fitting non-linear regressions to
improve the robustness and reproducibility of model fitting.

**rTPC** comes with a set of TPCs of photosynthesis and respiration of
the aquatic algae, *Chlorella vulgaris*, from Padfield *et al.* (2016).
There are 60 curves overall.

``` r
# load in data
data("Chlorella_TRC")

# change rate to be non-log transformed
d <- mutate(Chlorella_TRC, rate = exp(ln.rate))

# show the data
ggplot(d, aes(temp, rate, group = curve_id)) +
  facet_grid(flux ~growth.temp) +
  geom_point(alpha = 0.5) +
  geom_line(alpha = 0.5) +
  theme_bw()
```

<img src="man/figures/README-quicklook-1.png" width="100%" style="display: block; margin: auto;" />

First, we shall fit each model to just a single curve using
**nls.multstart::nlsmultstart()**. To do this, we take advantage of some
packages from the **tidyverse**, specifically **purrr**, **dplyr**, and
**tidyr**. In short, we specify the grouping variables of the dataset
(less applicable for a single curve) and then add a column for each
different model fit. This results in a list column, where the actual fit
is stored in the dataframe. This allows us increased flexibility
compared to other methods such as extracting the parameters from the
model and storing them in a list.

**rTPC** contains helper functions to aid in model fitting. First,
**get\_start\_vals()** estimates start values for the specified model.
These start values are estimated from the data where possible, but
otherwise represent averages of previously reported parameters from the
literature. Second, **get\_lower\_lims()** and **get\_upper\_lims()**
set wide lower and upper limits for the model specified. These are
needed as some models have multiple solutions, which means that some
estimated parameters are meaningless even though they represent the best
solution. These are currently not available for all models, but we aim
to do so soon.

``` r
# filter data for just a single curve
d_1 <- filter(d, curve_id == 1)

# run in purrr - going to be a huge long command this one
d_models <- group_by(d_1, curve_id, growth.temp, process, flux) %>%
  nest() %>%
  mutate(., lactin2 = map(data, ~nls_multstart(rate ~ lactin2_1995(temp = temp, p, c, tmax, delta_t),
                       data = .x,
                       iter = 500,
                       start_lower = c(p = 0, c = -2, tmax = 35, delta_t = 0),
                       start_upper = c(p = 3, c = 0, tmax = 55, delta_t = 15),
                       supp_errors = 'Y')),
            sharpeschoolhigh = map(data, ~nls_multstart(rate ~ sharpeschoolhigh_1981(temp_k = K, r_tref, e, eh, th, tref = 15),
                                           data = .x,
                                           iter = 500,
                                           start_lower = get_start_vals(.x$K, .x$rate, model_name = 'sharpeschoolhigh_1981') - 10,
                                           start_upper = get_start_vals(.x$K, .x$rate, model_name = 'sharpeschoolhigh_1981') + 10,
                                           supp_errors = 'Y')),
            johnsonlewin = map(data, ~nls_multstart(rate ~ johnsonlewin_1946(temp_k = K, r0, e, eh, topt),
                                           data = .x,
                                           iter = 500,
                                           start_lower = c(r0 = 1e9, e = 0, eh = 0, topt = 270),
                                           start_upper = c(r0 = 1e11, e = 2, eh = 10, topt = 330),
                                           supp_errors = 'Y')),
            thomas = map(data, ~nls_multstart(rate ~ thomas_2012(temp = temp, a, b, c, topt),
                                           data = .x,
                                           iter = 500,
                                           start_lower = get_start_vals(.x$temp, .x$rate, model_name = 'briere2_1999') - 1,
                                           start_upper = get_start_vals(.x$temp, .x$rate, model_name = 'briere2_1999') + 2,
                                           supp_errors = 'Y',
                                           lower = c(a= 0, b = -10, c = 0, topt = 0))),
            briere2 = map(data, ~nls_multstart(rate ~ briere2_1999(temp = temp, tmin, tmax, a, b),
                                           data = .x,
                                           iter = 500,
                                           start_lower = c(tmin = 0, tmax = 20, a = -10, b = -10),
                                           start_upper = c(tmin = 20, tmax = 50, a = 10, b = 10),
                                           supp_errors = 'Y',
                                           lower = c(tmin = -10, tmax = 20, a = -10, b = -10),
                                           upper = c(tmin = 20, tmax = 80, a = 10, b = 10))),
            spain = map(data, ~nls_multstart(rate ~ spain_1982(temp = temp, a, b, c, r0),
                                           data = .x,
                                           iter = 500,
                                           start_lower = c(a = -1, b = -1, c = -1, r0 = -1),
                                           start_upper = c(a = 1, b = 1, c = 1, r0 = 1),
                                           supp_errors = 'Y')),
            ratkowsky = map(data, ~nls_multstart(rate ~ ratkowsky_1983(temp = temp, tmin, tmax, a, b),
                                           data = .x,
                                           iter = 500,
                                           start_lower = c(tmin = 0, tmax = 20, a = -10, b = -10),
                                           start_upper = c(tmin = 20, tmax = 50, a = 10, b = 10),
                                           supp_errors = 'Y')),
            boatman = map(data, ~nls_multstart(rate ~ boatman_2017(temp = temp, rmax, tmin, tmax, a, b),
                                           data = .x,
                                           iter = 500,
                                           start_lower = c(rmax = 0, tmin = 0, tmax = 35, a = -1, b = -1),
                                           start_upper = c(rmax = 2, tmin = 10, tmax = 50, a = 1, b = 1),
                                           supp_errors = 'Y')),
            flinn = map(data, ~nls_multstart(rate ~ flinn_1991(temp = temp, a, b, c),
                                           data = .x,
                                           iter = 500,
                                           start_lower = c(a = 0, b = -2, c = -1),
                                           start_upper = c(a = 30, b = 2, c = 1),
                                           supp_errors = 'Y')),
            gaussian = map(data, ~nls_multstart(rate ~ gaussian_1987(temp = temp, rmax, topt, a),
                                           data = .x,
                                           iter = 500,
                                           start_lower = c(rmax = 0, topt = 20, a = 0),
                                           start_upper = c(rmax = 2, topt = 40, a = 30),
                                           supp_errors = 'Y')),
            oneill = map(data, ~nls_multstart(rate ~ oneill_1972(temp = temp, rmax, tmax, topt, a),
                                           data = .x,
                                           iter = 500,
                                           start_lower = c(rmax = 1, tmax = 30, topt = 20, a = 1),
                                           start_upper = c(rmax = 2, tmax = 50, topt = 40, a = 2),
                                           supp_errors = 'Y')),
            joehnk = map(data, ~nls_multstart(rate ~ joehnk_2008(temp = temp, rmax, topt, a, b, c),
                                           data = .x,
                                           iter = 500,
                                           start_lower = c(rmax = 0, topt = 20, a = 0, b = 1, c = 1),
                                           start_upper = c(rmax = 2, topt = 40, a = 30, b = 2, c = 2),
                                           supp_errors = 'Y',
                                           lower = c(rmax = 0, topt = 0, a = 0, b = 1, c = 1))),
            kamykowski = map(data, ~nls_multstart(rate ~ kamykowski_1985(temp = temp, tmin, tmax, a, b, c),
                                           data = .x,
                                           iter = 500,
                                           start_lower = c(tmin = 0, tmax = 10, a = -3, b = -1, c = -1),
                                           start_upper = c(tmin = 20, tmax = 50, a = 3, b = 1, c =1),
                                           supp_errors = 'Y')),
            quadratic = map(data, ~nls_multstart(rate ~ quadratic_2008(temp = temp, a, b, c),
                                           data = .x,
                                           iter = 500,
                                           start_lower = c(a = 0, b = -2, c = -1),
                                           start_upper = c(a = 30, b = 2, c = 1),
                                           supp_errors = 'Y')),
            hinshelwood = map(data, ~nls_multstart(rate ~ hinshelwood_1947(temp = temp, a, e, c, eh),
                                           data = .x,
                                           iter = 500,
                                           start_lower = c(a = 1e9, e = 5, c = 1e9, eh = 0),
                                           start_upper = c(a = 1e11, e = 20, c = 1e11, eh = 20),
                                           supp_errors = 'Y')),
            sharpeschoolfull = map(data, ~nls_multstart(rate ~ sharpeschoolfull_1981(temp_k = K, r_tref, e, el, tl, eh, th, tref = 15),
                                           data = .x,
                                           iter = 500,
                                           start_lower = get_start_vals(.x$K, .x$rate, model_name = 'sharpeschoolfull_1981') - 10,
                                           start_upper = get_start_vals(.x$K, .x$rate, model_name = 'sharpeschoolfull_1981') + 10,
                                           supp_errors = 'Y')),
            sharpeschoollow = map(data, ~nls_multstart(rate ~ sharpeschoollow_1981(temp_k = K, r_tref, e, el, tl, tref = 15),
                                           data = .x,
                                           iter = 500,
                                           start_lower = c(r_tref = 0.01, e = 0, el = 0, tl = 270),
                                           start_upper = c(r_tref = 2, e = 3, el = 10, tl = 330),
                                           supp_errors = 'Y')),
            weibull = map(data, ~nls_multstart(rate ~ weibull_1995(temp = temp, a, topt, b, c),
                                           data = .x,
                                           iter = 500,
                                           start_lower = c(a = 0, topt = 30, b = 100, c = 10),
                                           start_upper = c(a = 3, topt = 50, b = 200, c = 50),
                                           lower = c(a = 0, topt = 20, b = 0, c = 0),
                                           supp_errors = 'Y')),
            rezende = map(data, ~nls_multstart(rate ~ rezende_2019(temp = temp, a, q10, b, c),
                                           data = .x,
                                           iter = 500,
                                           start_lower = get_start_vals(.x$temp, .x$rate, model_name = 'rezende_2019') *0.8,
                                           start_upper = get_start_vals(.x$temp, .x$rate, model_name = 'rezende_2019') * 1.2,
                                           upper = get_upper_lims(.x$temp, .x$rate, model_name = 'rezende_2019'),
                                           lower = get_lower_lims(.x$temp, .x$rate, model_name = 'rezende_2019'),
                                           supp_errors = 'Y')))
```

The predictions of each model can be extracted using
**broom::augment()**, after we stack all of our models into long format.
To allow for a smooth curve, we produce a new temperature vector that
has 100 points instead of our original data which just has 8.

We can also grab all the parameters of the model using
**broom::tidy()**. This is useful if using just a single model, but as
parameter meanings do not transfer well across models, using this to
compare models is limited.

Nevertheless, we can extract parameters and visualise our model fits.

``` r
# stack models
d_stack <- gather(d_models, 'model', 'output', 6:ncol(d_models))

# preds
newdata <- tibble(temp = seq(min(d_1$temp), max(d_1$temp), length.out = 100),
                  K = seq(min(d_1$K), max(d_1$K), length.out = 100))
d_preds <- d_stack %>%
  unnest(., output %>% map(augment, newdata = newdata))

# estimate parameters
params <- d_stack %>%
  mutate(., est = map(output, tidy)) %>%
  select(., -c(data, output)) %>%
  unnest(est)

# plot fit
ggplot(d_preds, aes(temp, rate)) +
  geom_point(aes(temp, rate), d_1) +
  geom_line(aes(temp, .fitted, col = model)) +
  facet_wrap(~model, labeller = labeller(model = label_facets_num)) +
  theme_bw(base_size = 16) +
  theme(legend.position = 'none',
        strip.text = element_text(hjust = 0),
        strip.background = element_blank()) +
  xlab('Temperature (ºC)') +
  ylab('rate') +
  geom_hline(aes(yintercept = 0), linetype = 2)
```

<img src="man/figures/README-plot_predictions-1.png" width="100%" style="display: block; margin: auto;" />

### Estimating traits of the TPC

A common motivation for fitting a particular model is that a desired
term (e.g. the optimum temperature \(T_{opt}\)) is specifically defined
in the model. However, these parameters can also be derived from any
given model fit, by estimating parameters from high resolution
predictions of the model.

**rTPC** comes with a bunch of helper functions to estimate common
traits that are extracted from TPCs, such as optimum temperature,
**get\_topt()**, maximal rate, **get\_rmax()**, and activation energy,
**get\_e()**. These functions can all be called at once using
**est\_params()**.

``` r

# estimate extra parameters
params_extra <- d_stack %>%
  mutate(., est = map(output, est_params)) %>%
  select(., -c(data, output)) %>%
  unnest(est) %>%
  select(model:ncol(.)) %>%
  mutate_if(is.numeric, function(x)round(x, 2))

col_names <- c('model', 'Rmax', 'Topt', 'CTmin', 'CTmax', 'E', 'Eh', 'Q10', 'thermal\nsafety\nmargin', 'tolerance\nrange', 'skewness')

# show the table of extra parameters
kableExtra::kable(head(params_extra, 6), col.names = col_names, align = 'c') %>%
  kableExtra::kable_styling(font_size = 14, bootstrap_options = c("striped", "hover", "condensed"))
```

<table class="table table-striped table-hover table-condensed" style="font-size: 14px; margin-left: auto; margin-right: auto;">

<thead>

<tr>

<th style="text-align:center;">

model

</th>

<th style="text-align:center;">

Rmax

</th>

<th style="text-align:center;">

Topt

</th>

<th style="text-align:center;">

CTmin

</th>

<th style="text-align:center;">

CTmax

</th>

<th style="text-align:center;">

E

</th>

<th style="text-align:center;">

Eh

</th>

<th style="text-align:center;">

Q10

</th>

<th style="text-align:center;">

thermal safety margin

</th>

<th style="text-align:center;">

tolerance range

</th>

<th style="text-align:center;">

skewness

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:center;">

lactin2

</td>

<td style="text-align:center;">

1.36

</td>

<td style="text-align:center;">

38.41

</td>

<td style="text-align:center;">

15.59

</td>

<td style="text-align:center;">

48.74

</td>

<td style="text-align:center;">

0.72

</td>

<td style="text-align:center;">

1.74

</td>

<td style="text-align:center;">

2.48

</td>

<td style="text-align:center;">

10.33

</td>

<td style="text-align:center;">

33.15

</td>

<td style="text-align:center;">

\-0.34

</td>

</tr>

<tr>

<td style="text-align:center;">

sharpeschoolhigh

</td>

<td style="text-align:center;">

1.81

</td>

<td style="text-align:center;">

314.80

</td>

<td style="text-align:center;">

275.69

</td>

<td style="text-align:center;">

318.71

</td>

<td style="text-align:center;">

0.58

</td>

<td style="text-align:center;">

11.48

</td>

<td style="text-align:center;">

2.06

</td>

<td style="text-align:center;">

3.91

</td>

<td style="text-align:center;">

43.02

</td>

<td style="text-align:center;">

\-0.67

</td>

</tr>

<tr>

<td style="text-align:center;">

johnsonlewin

</td>

<td style="text-align:center;">

1.81

</td>

<td style="text-align:center;">

314.80

</td>

<td style="text-align:center;">

275.69

</td>

<td style="text-align:center;">

318.71

</td>

<td style="text-align:center;">

0.58

</td>

<td style="text-align:center;">

11.48

</td>

<td style="text-align:center;">

2.06

</td>

<td style="text-align:center;">

3.91

</td>

<td style="text-align:center;">

43.02

</td>

<td style="text-align:center;">

\-0.67

</td>

</tr>

<tr>

<td style="text-align:center;">

thomas

</td>

<td style="text-align:center;">

NA

</td>

<td style="text-align:center;">

NA

</td>

<td style="text-align:center;">

NA

</td>

<td style="text-align:center;">

NA

</td>

<td style="text-align:center;">

NA

</td>

<td style="text-align:center;">

NA

</td>

<td style="text-align:center;">

NA

</td>

<td style="text-align:center;">

NA

</td>

<td style="text-align:center;">

NA

</td>

<td style="text-align:center;">

NA

</td>

</tr>

<tr>

<td style="text-align:center;">

briere2

</td>

<td style="text-align:center;">

1.33

</td>

<td style="text-align:center;">

37.12

</td>

<td style="text-align:center;">

16.75

</td>

<td style="text-align:center;">

48.88

</td>

<td style="text-align:center;">

0.72

</td>

<td style="text-align:center;">

1.74

</td>

<td style="text-align:center;">

2.48

</td>

<td style="text-align:center;">

11.77

</td>

<td style="text-align:center;">

32.14

</td>

<td style="text-align:center;">

\-0.19

</td>

</tr>

<tr>

<td style="text-align:center;">

spain

</td>

<td style="text-align:center;">

1.33

</td>

<td style="text-align:center;">

39.96

</td>

<td style="text-align:center;">

\-1.37

</td>

<td style="text-align:center;">

48.67

</td>

<td style="text-align:center;">

0.72

</td>

<td style="text-align:center;">

1.74

</td>

<td style="text-align:center;">

2.48

</td>

<td style="text-align:center;">

8.71

</td>

<td style="text-align:center;">

50.05

</td>

<td style="text-align:center;">

\-0.38

</td>

</tr>

</tbody>

</table>

From these fits, we can also take advantage of model selection methods
such as the **AICc** score. We can calculate model weights of these to
see which model is most supported.

``` r

# calculate AICc score and weight models
d_stack <- mutate(d_stack, aic = map_dbl(output, possibly(MuMIn::AICc, NA))) %>%
  filter(., !is.na(aic)) %>%
  mutate(., weight = MuMIn::Weights(aic))

# plot weights
ggplot(d_stack, aes(forcats::fct_reorder(model, weight, .desc = TRUE), weight, fill = model)) +
  geom_col() +
  theme_bw(base_size = 16) +
  xlab('model') +
  theme(legend.position = 'element_blank',
        axis.text.x = element_text(angle = 45, hjust = 1)) +
  ylim(c(0,1)) 
```

<img src="man/figures/README-model_selection-1.png" width="50%" />

We can then calculate model weighted predictions of best overall model
fit easily enough if desired.

``` r
# calculate average prediction
ave_preds <- merge(d_preds, select(d_stack, model, weight), by = 'model') %>%
  mutate(., temp = round(temp, 2)) %>%
  group_by(temp) %>%
  summarise(., ave_pred = sum(.fitted*weight)) %>%
  ungroup()

# plot these
ggplot() +
  geom_point(aes(temp, rate), d_1) +
  geom_line(aes(temp, .fitted, group = model), alpha = 0.1, d_preds) +
  geom_line(aes(temp, ave_pred), ave_preds, size = 1) +
  theme_bw(base_size = 16) +
  theme(legend.position = 'none',
        strip.text = element_text(hjust = 0),
        strip.background = element_blank()) +
  xlab('Temperature (ºC)') +
  ylab('rate') +
  geom_hline(aes(yintercept = 0), linetype = 2)
```

<img src="man/figures/README-model_average-1.png" width="50%" />

## Fitting multiple models to multiple curves

The amazing thing about this method is that it can easily be implement
on many different curves. For example we can fit this model ensemble to
each of 15 curves from the dataset, calculate the *AICc* for each one
and then plot the model averaged curve.

``` r
# filter 15 curves
d_15 <- filter(d, curve_id <= 15)

# when scaling up our code to fit hundreds of models, its nice to have a progress bar
# there are probably more elegant ways to do this
nls_multstart_progress <- function(formula, data = parent.frame(), iter, start_lower, 
                                   start_upper, supp_errors = c("Y", "N"), convergence_count = 100, 
                                   control, modelweights, ...){
  if(!is.null(pb)){
    pb$tick()$print()
  }
  nls_multstart(formula = formula, data = data, iter = iter, start_lower = start_lower, 
                start_upper = start_upper, supp_errors = supp_errors, convergence_count = convergence_count, 
                control = control, modelweights = modelweights, ...)
}

# start progress bar and estimate time it will take
number_of_models <- 11
number_of_curves <- length(unique(d_15$curve_id))

# setup progress bar
pb <- progress_estimated(number_of_curves*number_of_models)

# run each model on each curve
d_models <- group_by(d_15, curve_id, growth.temp, process, flux) %>%
  nest() %>%
  mutate(., lactin2 = map(data, ~nls_multstart_progress(rate ~ lactin2_1995(temp = temp, p, c, tmax, delta_t),
                       data = .x,
                       iter = 500,
                       start_lower = c(p = 0, c = -2, tmax = 35, delta_t = 0),
                       start_upper = c(p = 3, c = 0, tmax = 55, delta_t = 15),
                       supp_errors = 'Y')),
            sharpeschoolhigh = map(data, ~nls_multstart_progress(rate ~ sharpeschoolhigh_1981(temp_k = K, r_tref, e, eh, th, tref = 15),
                       data = .x,
                       iter = 500,
                       start_lower = c(r_tref = 0.01, e = 0, eh = 0, th = 270),
                       start_upper = c(r_tref = 2, e = 3, eh = 10, th = 330),
                       supp_errors = 'Y')),
            thomas = map(data, ~nls_multstart_progress(rate ~ thomas_2012(temp = temp, a, b, c, topt),
                       data = .x,
                       iter = 500,
                       start_lower = c(a = -10, b = -10, c = -10, topt = 0),
                       start_upper = c(a = 10, b = 10, c = 10, topt = 40),
                       supp_errors = 'Y',
                       lower = c(a= 0, b = -10, c = 0, topt = 0))),
            briere2 = map(data, ~nls_multstart_progress(rate ~ briere2_1999(temp = temp, tmin, tmax, a, b),
                       data = .x,
                       iter = 500,
                       start_lower = c(tmin = 0, tmax = 20, a = -10, b = -10),
                       start_upper = c(tmin = 20, tmax = 50, a = 10, b = 10),
                       supp_errors = 'Y',
                       lower = c(tmin = -10, tmax = 20, a = -10, b = -10),
                       upper = c(tmin = 20, tmax = 80, a = 10, b = 10))),
         boatman = map(data, ~nls_multstart_progress(rate ~ boatman_2017(temp = temp, rmax, tmin, tmax, a, b),
                        data = .x,
                        iter = 500,
                        start_lower = c(rmax = 0, tmin = 0, tmax = 35, a = -1, b = -1),
                        start_upper = c(rmax = 2, tmin = 10, tmax = 50, a = 1, b = 1),
                        supp_errors = 'Y')),
         flinn = map(data, ~nls_multstart_progress(rate ~ flinn_1991(temp = temp, a, b, c),
                        data = .x,
                        iter = 500,
                        start_lower = c(a = 0, b = -2, c = -1),
                        start_upper = c(a = 30, b = 2, c = 1),
                        supp_errors = 'Y')),
         gaussian = map(data, ~nls_multstart_progress(rate ~ gaussian_1987(temp = temp, rmax, topt, a),
                        data = .x,
                        iter = 500,
                        start_lower = c(rmax = 0, topt = 20, a = 0),
                        start_upper = c(rmax = 2, topt = 40, a = 30),
                        supp_errors = 'Y')),
         oneill = map(data, ~nls_multstart_progress(rate ~ oneill_1972(temp = temp, rmax, tmax, topt, a),
                        data = .x,
                        iter = 500,
                        start_lower = c(rmax = 1, tmax = 30, topt = 20, a = 1),
                        start_upper = c(rmax = 2, tmax = 50, topt = 40, a = 2),
                        supp_errors = 'Y')),
         joehnk = map(data, ~nls_multstart_progress(rate ~ joehnk_2008(temp = temp, rmax, topt, a, b, c),
                        data = .x,
                        iter = 500,
                        start_lower = c(rmax = 0, topt = 20, a = 0, b = 1, c = 1),
                        start_upper = c(rmax = 2, topt = 40, a = 30, b = 2, c = 2),
                        supp_errors = 'Y',
                        lower = c(rmax = 0, topt = 0, a = 0, b = 1, c = 1))),
         quadratic = map(data, ~nls_multstart_progress(rate ~ quadratic_2008(temp = temp, a, b, c),
                        data = .x,
                        iter = 500,
                        start_lower = c(a = 0, b = -2, c = -1),
                        start_upper = c(a = 30, b = 2, c = 1),
                        supp_errors = 'Y')),
         sharpeschoolfull = map(data, ~nls_multstart_progress(rate ~ sharpeschoolfull_1981(temp_k = K, r_tref, e, el, tl, eh, th, tref = 15),
                        data = .x,
                        iter = 500,
                        start_lower = c(r_tref = 0.01, e = 0, el = 0, tl = 270, eh = 0, th = 270),
                        start_upper = c(r_tref = 2, e = 3, el = 10, tl = 330, eh = 10, th = 330),
                        supp_errors = 'Y')))
```

We can then run the same code as above but on multiple models.

``` r
# stack models
d_stack <- gather(d_models, 'model', 'output', 6:ncol(d_models))

# preds
newdata <- tibble(temp = seq(min(d_1$temp), max(d_1$temp), length.out = 100),
                  K = seq(min(d_1$K), max(d_1$K), length.out = 100))
d_preds <- d_stack %>%
  unnest(., output %>% map(augment, newdata = newdata)) %>%
  mutate(., temp = ifelse(model == 'sharpeschoolhigh', K - 273.15, temp))

# calculate AICc score and weight models
d_stack <- mutate(d_stack, aic = map_dbl(output, possibly(MuMIn::AICc, NA))) %>%
  filter(., !is.na(aic)) %>%
  group_by(curve_id) %>%
  mutate(., weight = MuMIn::Weights(aic))

# calculate average predictions
ave_preds <- merge(d_preds, select(d_stack, model, weight, curve_id), by = c('model', 'curve_id')) %>%
  mutate(., temp = round(temp, 2)) %>%
  group_by(temp, curve_id) %>%
  summarise(., ave_pred = sum(.fitted*weight)) %>%
  ungroup()
```

We can then make the exact plots as we made previously. Firstly of the
predictions of each curve.

``` r
lines <- data.frame(val = 0, curve_id = 1:15)

ggplot() +
  geom_point(aes(temp, rate), d_15) +
  geom_line(aes(temp, .fitted, group = model), alpha = 0.1, filter(d_preds, .fitted > -0.5 & .fitted < 3)) +
  geom_line(aes(temp, ave_pred), ave_preds, size = 1) +
  facet_wrap(~ curve_id, scales = 'free_y') +
  theme_bw(base_size = 16) +
  theme(legend.position = 'none',
        strip.text = element_text(hjust = 0),
        strip.background = element_blank()) +
  xlab('Temperature (ºC)') +
  ylab('rate') +
  geom_hline(aes(yintercept = val), linetype = 2, lines)
```

<img src="man/figures/README-plot_preds_many-1.png" width="100%" />

We can also plot the distribution of the weights across all of the
curves.

``` r
ggplot(d_stack, aes(forcats::fct_reorder(model, weight, .desc = TRUE), weight)) +
  MicrobioUoE::geom_pretty_boxplot(aes(fill = model, col = model)) +
  geom_point(shape = 21, fill = 'white', position = position_jitter(width = 0.2), size = 2) +
  theme_bw(base_size = 16) +
  xlab('model') +
  theme(legend.position = 'element_blank',
        axis.text.x = element_text(angle = 45, hjust = 1)) +
  ylim(c(0,1)) 
#> Warning: Removed 1 rows containing missing values (geom_point).
```

<img src="man/figures/README-plot_weights_many-1.png" width="60%" />
