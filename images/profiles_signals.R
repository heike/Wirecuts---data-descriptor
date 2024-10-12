library(tidyverse)

x3ptools::x3p_read(here::here("../Wirecuts/scans/T1AW-LI-R1.x3p")) %>% 
  wire::x3p_image_autosize(file = here::here("images/T1AW-LI-R1.png"))
x3ptools::x3p_read(here::here("../Wirecuts/scans/T2AW-LI-R1.x3p")) %>% 
  wire::x3p_image_autosize(file = here::here("images/T2AW-LI-R1.png"))

profiles <- read_csv("~/Documents/GitHub/Wirecuts/profiles/profiles-T1AW-LI-R1.csv", show_col_types = FALSE)
profiles %>%
  ggplot(aes(x = x, y = value)) +
  geom_line(color = "#003A70") +
  theme_bw() +
  xlab(expression(paste("x (", mu, "m)"))) +
  ylab(expression(paste("profile value (", mu, "m)")))
ggsave(here::here("images/T1AW-LI-R1-profiles-plot.png"), width = 6, height = 2)


signals <- read_csv("~/Documents/GitHub/Wirecuts/data-manual/wire-signatures-400-40.csv", show_col_types = FALSE)
signals %>%
  filter(id == "T1AW-LI-R1") %>%
  ggplot(aes(x = x, y = sig)) +
  geom_line(aes(color = "filtered")) +
  geom_line(aes(x = x, y = raw_sig, color = "raw"), alpha = 0.6) +
  theme_bw() +
  xlab(expression(paste("x (", mu, "m)"))) +
  ylab(expression(paste("signal value (", mu, "m)"))) +
  labs(color = "signal") +
  scale_color_manual(values = c(raw = "#40B4E5", filtered = "#003A70")) +
  theme(legend.position = "bottom")
ggsave(here::here("images/T1AW-LI-R1-signals-plot.png"), width = 6, height = 2.5)

signal1 <- signals %>%
  filter(id == "T1AW-LI-R1") %>%
  pull(sig)
signal2 <- signals %>%
  filter(id == "T2AW-LI-R1") %>%
  pull(raw_sig)

wire::vec_align_sigs_list(sig1 = signal1, sig2 = signal2, legendname = "Tool", ifplot = TRUE)
ggsave(here::here("images/T1AW-LI-R1-T2AW-LI-R1.png"), width = 6, height = 2)
