library(tidyverse)

reference_x3p <- "T1AW-LI-R1"
same_source_x3p <- "T1AW-LI-R2"
different_source_x3p <- "T2AW-LI-R1"
x3ps <- c(reference_x3p, same_source_x3p, different_source_x3p)

walk(x3ps, function(x3p) {
  x3ptools::x3p_read(here::here(sprintf("../wirecuts-data/scans/%s.x3p", x3p))) %>%
    wire::x3p_image_autosize(file = here::here(sprintf("images/%s.png", x3p)))
})

profiles <- read_csv(here::here(sprintf("../wirecuts-data/profiles/profiles-%s.csv", reference_x3p)), show_col_types = FALSE)
profiles %>%
  ggplot(aes(x = x, y = value)) +
  geom_line(color = "#003A70") +
  theme_bw() +
  xlab(expression(paste("x (", mu, "m)"))) +
  ylab(expression(paste("profile value (", mu, "m)")))
ggsave(here::here(sprintf("images/%s-profiles-plot.png", reference_x3p)), width = 6, height = 2)


signals <- read_csv(here::here("../wirecuts-data/data-derived/wire-signals.csv.zip"), show_col_types = FALSE)
signals %>%
  filter(ID == reference_x3p) %>%
  ggplot(aes(x = x, y = sig)) +
  geom_line(aes(color = "filtered")) +
  geom_line(aes(x = x, y = raw_sig, color = "raw"), alpha = 0.6) +
  theme_bw() +
  xlab(expression(paste("x (", mu, "m)"))) +
  ylab(expression(paste("signal value (", mu, "m)"))) +
  labs(color = "signal") +
  scale_color_manual(values = c(raw = "#40B4E5", filtered = "#003A70")) +
  theme(legend.position = "bottom")
ggsave(here::here(sprintf("images/%s-signals-plot.png", reference_x3p)), width = 6, height = 2.5)

signal1 <- signals %>%
  filter(ID == reference_x3p) %>%
  pull(sig)
signal2 <- signals %>%
  filter(ID == same_source_x3p) %>%
  pull(sig)

align_same_source <- wire::vec_align_sigs_list(sig1 = signal1, sig2 = signal2, legendname = "replicate", ifplot = TRUE, min.overlap = 1000)
ggsave(here::here(sprintf("images/%s-%s.png", reference_x3p, same_source_x3p)), width = 6, height = 2)


signal1 <- signals %>%
  filter(ID == reference_x3p) %>%
  pull(sig)
signal2 <- signals %>%
  filter(ID == different_source_x3p) %>%
  pull(sig)

align_different_source <- wire::vec_align_sigs_list(sig1 = signal1, sig2 = signal2, legendname = "tool", ifplot = TRUE, min.overlap = 1000)
ggsave(here::here(sprintf("images/%s-%s.png", reference_x3p, different_source_x3p)), width = 6, height = 2)
