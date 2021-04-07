# creation of hex sticker rTPC

library(hexSticker)
library(temperatureresponse)
library(tidyverse)
library(rTPC)
library(nls.multstart)
library(showtext)

data("Emiliania_huxleyi")
glimpse(Emiliania_huxleyi)

ggplot(Emiliania_huxleyi, aes(temp, rate)) +
  geom_point()

d <- Emiliania_huxleyi %>%
  mutate(., K = temp + 273.15)

# run in purrr - going to be a huge long command this one
d_models <- d %>%
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
                                                     start_lower = c(r_tref = 0.01, e = 0, eh = 0, th = 270),
                                                     start_upper = c(r_tref = 2, e = 3, eh = 10, th = 330),
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
                                           start_lower = c(a = -10, b = -10, c = -10, topt = 0),
                                           start_upper = c(a = 10, b = 10, c = 10, topt = 40),
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
                                                     start_lower = c(r_tref = 0.01, e = 0, el = 0, tl = 270, eh = 0, th = 270),
                                                     start_upper = c(r_tref = 2, e = 3, el = 10, tl = 330, eh = 10, th = 330),
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
                                            start_lower = c(a = 0, q10 = 1, b = 10, c = 0),
                                            start_upper = c(a = 1, q10 = 4, b = 50, c = 0.005),
                                            supp_errors = 'Y')))

# stack models
d_stack <- gather(d_models, 'model', 'output', 2:ncol(d_models))

# preds
newdata <- tibble(temp = seq(min(d$temp), max(d$temp), length.out = 100),
                  K = seq(min(d$K), max(d$K), length.out = 100))
d_preds <- filter(d_stack, !is.null(output)) %>%
  mutate(preds = map(output, broom::augment, newdata = newdata)) %>%
  unnest(preds) %>%
  mutate(., temp = ifelse(model == 'sharpeschoolhigh', K - 273.15, temp))

# calculate AICc score and weight models
d_stack <- mutate(d_stack, aic = map_dbl(output, possibly(MuMIn::AICc, NA))) %>%
  filter(., !is.na(aic)) %>%
  mutate(., weight = as.vector(MuMIn::Weights(aic)))

# calculate average prediction
ave_preds <- merge(d_preds, select(d_stack, model, weight), by = 'model') %>%
  mutate(., temp = round(temp, 2)) %>%
  group_by(temp) %>%
  summarise(., ave_pred = sum(.fitted*weight)) %>%
  ungroup()

# filter preds to not include mental predictions
d_preds <- merge(d_preds, select(d_stack, model, weight), by = 'model') %>%
  filter(., weight > 0.0001)

# plot these
plot_1 <- ggplot() +
  geom_line(aes(temp, .fitted, group = model), size = 0.3, alpha = 0.5, d_preds, col = 'white') +
  geom_line(aes(temp, ave_pred), ave_preds, size = 0.3, col = 'white') +
  MicrobioUoE::theme_black(base_size = 6) +
  theme(legend.position = 'none',
        strip.text = element_text(hjust = 0),
        strip.background = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.line = element_blank(),
        panel.border = element_blank(),
        axis.ticks = element_blank(),
        axis.title.x = element_text(margin=margin(-2,0,0,0)),
        axis.title.y = element_text(margin=margin(0,-2,0,0)),
        panel.grid.major = element_line(size = 0.1, colour = 'grey')) +
  xlab('Temperature') +
  ylab('Rate') +
  scale_y_continuous(breaks = c(0, 0.25, 0.5))


font_add_google("Oxygen")
font_add_google("Anton")
showtext_auto()
sysfonts::font_families()

sticker(plot_1,
        package="rTPC",
        p_size = 7,
        s_x = 0.95,
        s_y = 0.85,
        s_width = 1.19,
        s_height = 1,
        p_x = 1,
        p_y = 1.5,
        h_fill = 'black',
        h_color = '#edd90efe',
        p_color = '#edd90efe',
        p_family = "Anton",
        filename="~/google_drive/rTPC_hex_sticker.png",
        white_around_sticker = FALSE)
