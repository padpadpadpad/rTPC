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

d_models <- group_by(d_1, curve_id, growth.temp, process, flux) %>%
  nest() %>%
  mutate(., sharpeschoolhigh = map(data, ~nls_multstart(rate ~ sharpeschoolhigh_1981(temp_k = K, r_tref, e, eh, th, tref = 15),
                                                     data = .x,
                                                     iter = 500,
                                                     start_lower = get_start_vals(.x$K, .x$rate, model_name = 'sharpeschoolhigh_1981') - 10,
                                                     start_upper = get_start_vals(.x$K, .x$rate, model_name = 'sharpeschoolhigh_1981') + 10,
                                                     supp_errors = 'Y')))
