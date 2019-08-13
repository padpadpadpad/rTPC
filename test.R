# load in packages
library(purrr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(nls.multstart)
library(broom)
library(rTPC)
library(MuMIn)

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

# load in data
data("Chlorella_TRC")

# change rate to be non-log transformed
d <- mutate(Chlorella_TRC, rate = exp(ln.rate))

# filter for just the first curve
d_1 <- filter(d, curve_id == 1)

# plot
ggplot(d_1, aes(temp, rate)) +
  geom_point() +
  theme_bw()

temp = 20:50; a = 2; b = 100; c = 10;topt = 40
y = weibull_1995(temp, a, topt, b, c)
plot(y~temp)

get_start_vals(d_1$K, d_1$rate, model_name = 'sharpeschoolhigh_1981')
get_start_vals(d_1$K, d_1$rate, model_name = 'sharpeschoolfull_1981')
get_start_vals(d_1$K, d_1$rate, model_name = 'sharpeschoollow_1981')
get_start_vals(d_1$temp, d_1$rate, model_name = 'briere2_1999')
get_start_vals(d_1$temp, d_1$rate, model_name = 'thomas_2012')
get_start_vals(d_1$temp, d_1$rate, model_name = 'lactin2_1995')
get_start_vals(d_1$temp, d_1$rate, model_name = 'quadratic_2008')
get_start_vals(d_1$temp, d_1$rate, model_name = 'ratkowsky_1983')
get_start_vals(d_1$temp, d_1$rate, model_name = 'gaussian_1987')
get_start_vals(d_1$temp, d_1$rate, model_name = 'rezende_2019')
get_lower_lims(d_1$temp, d_1$rate, model_name = 'rezende_2019')
get_upper_lims(d_1$temp, d_1$rate, model_name = 'rezende_2019')
get_lower_lims(d_1$K, d_1$rate, model_name = 'sharpeschoolhigh_1981')
get_upper_lims(d_1$K, d_1$rate, model_name = 'sharpeschoollow_1981')

d_models <- group_by(d_1, curve_id, growth.temp, process, flux) %>%
  nest() %>%
  mutate(., sharpeschoolhigh = map(data, ~nls_multstart(rate ~ sharpeschoolhigh_1981(temp_k = K, r_tref, e, eh, th, tref = 20),
                                                     data = .x,
                                                     iter = 500,
                                                     start_lower = get_start_vals(.x$K, .x$rate, model_name = 'sharpeschoolhigh_1981') - 10,
                                                     start_upper = get_start_vals(.x$K, .x$rate, model_name = 'sharpeschoolhigh_1981') + 10,
                                                     supp_errors = 'Y')),
         sharpeschoolfull = map(data, ~nls_multstart(rate ~ sharpeschoolfull_1981(temp_k = K, r_tref, e, el, tl, eh, th, tref = 20),
                                                     data = .x,
                                                     iter = 500,
                                                     start_lower = get_start_vals(.x$K, .x$rate, model_name = 'sharpeschoolfull_1981') - 10,
                                                     start_upper = get_start_vals(.x$K, .x$rate, model_name = 'sharpeschoolfull_1981') + 10,
                                                     supp_errors = 'Y',
                                                     lower = c(r_tref = 0, e = 0, el = 0, tl = 0, eh = 0, th = 0),
                                                     upper = c(r_tref = 10, e = 10, el = 10, tl = 293.15, eh = 10, th = 400))),
         briere2 = map(data, ~nls_multstart(rate ~ briere2_1999(temp = temp, tmin, tmax, a, b),
                                            data = .x,
                                            iter = 500,
                                            start_lower = get_start_vals(.x$temp, .x$rate, model_name = 'briere2_1999') - 1,
                                            start_upper = get_start_vals(.x$temp, .x$rate, model_name = 'briere2_1999') + 2,
                                            supp_errors = 'Y',
                                            lower = c(tmin = -10, tmax = 20, a = -10, b = -10),
                                            upper = c(tmin = 20, tmax = 80, a = 10, b = 10))),
         thomas = map(data, ~nls_multstart(rate ~ thomas_2012(temp = temp, a, b, c, topt),
                                           data = .x,
                                           iter = 500,
                                           start_lower = get_start_vals(.x$temp, .x$rate, model_name = 'thomas_2012') - 1,
                                           start_upper = get_start_vals(.x$temp, .x$rate, model_name = 'thomas_2012') + 1,
                                           supp_errors = 'Y',
                                           lower = c(a= 0, b = -10, c = 0, topt = 0))),
         rezende = map(data, ~nls_multstart(rate ~ rezende_2019(temp = temp, q10, a, b, c),
                                            data = .x,
                                            iter = 500,
                                            start_lower = get_start_vals(.x$temp, .x$rate, model_name = 'rezende_2019') -1,
                                            start_upper = get_start_vals(.x$temp, .x$rate, model_name = 'rezende_2019') +1,
                                            upper = get_upper_lims(.x$temp, .x$rate, model_name = 'rezende_2019'),
                                            lower = get_lower_lims(.x$temp, .x$rate, model_name = 'rezende_2019'),
                                            supp_errors = 'Y')))

d_stack <- gather(d_models, 'model', 'output', 6:ncol(d_models))

newdata <- tibble(temp = seq(min(d_1$temp), max(d_1$temp), length.out = 100),
                  K = seq(min(d_1$K), max(d_1$K), length.out = 100))
d_preds <- d_stack %>%
  mutate(., pred = map(output, augment, newdata = newdata)) %>%
  unnest(., pred) %>%
  mutate(., temp = ifelse(model %in% c('sharpeschoolhigh', 'sharpeschoolfull'), K - 273.15, temp))



extra_params <- d_stack %>%
  mutate(., est = map(output, est_params)) %>%
  select(., -c(data, output)) %>%
  unnest(., est) %>%
  mutate(., topt = ifelse(topt > 200, topt - 273.15, topt),
         rmax = round(rmax, 2))


ggplot(filter(d_preds))

# plot
ggplot(d_preds, aes(temp, rate)) +
  geom_point(aes(temp, rate), d_1) +
  geom_text(aes(-Inf, Inf, label = paste('Topt =', topt, 'ºC\n', 'rmax = ', rmax)),  hjust = -0.1, vjust = 1.5, extra_params, size = pts(10)) +
  geom_line(aes(temp, .fitted, col = model)) +
  facet_wrap(~model, labeller = labeller(model = label_facets_num)) +
  theme_bw(base_size = 16) +
  theme(legend.position = 'none',
        strip.text = element_text(hjust = 0),
        strip.background = element_blank()) +
  xlab('Temperature (ºC)') +
  ylab('rate') +
  geom_hline(aes(yintercept = 0), linetype = 2)
