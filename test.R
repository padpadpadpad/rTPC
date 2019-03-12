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

get_start_vals(d_1$K, d_1$rate, model_name = 'sharpeschoolhigh_1981')
get_start_vals(d_1$K, d_1$rate, model_name = 'sharpeschoolfull_1981')


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
                                                     upper = c(r_tref = 10, e = 10, el = 10, tl = 293.15, eh = 10, th = 400))))

d_stack <- gather(d_models, 'model', 'output', starts_with('sharpe'))

newdata <- tibble(temp = seq(min(d_1$temp), max(d_1$temp), length.out = 100),
                  K = seq(min(d_1$K), max(d_1$K), length.out = 100))
d_preds <- d_stack %>%
  unnest(., output %>% map(augment, newdata = newdata)) %>%
  mutate(., temp = ifelse(model %in% c('sharpeschoolhigh', 'sharpeschoolfull'), K - 273.15, temp))

extra_params <- d_stack %>%
  mutate(., est = map(output, est_params)) %>%
  select(., -c(data, output)) %>%
  unnest(., est) %>%
  mutate(., topt = ifelse(topt > 200, topt - 273.15, topt),
         rmax = round(rmax, 2))

# plot
ggplot(d_preds, aes(temp, log(rate))) +
  geom_point(aes(temp, log(rate)), d_1) +
  geom_text(aes(-Inf, Inf, label = paste('Topt =', topt, 'ºC\n', 'rmax = ', rmax)),  hjust = -0.1, vjust = 1.5, extra_params, size = pts(10)) +
  geom_line(aes(temp, log(.fitted), col = model)) +
  facet_wrap(~model, labeller = labeller(model = label_facets_num)) +
  theme_bw(base_size = 16) +
  theme(legend.position = 'none',
        strip.text = element_text(hjust = 0),
        strip.background = element_blank()) +
  xlab('Temperature (ºC)') +
  ylab('rate') +
  geom_hline(aes(yintercept = 0), linetype = 2)
