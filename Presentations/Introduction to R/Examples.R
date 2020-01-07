# Code for presentation with introduction to R
data(Animals, package = "MASS")
dat <- Animals # Renames to dat

library(dplyr)

dat %>% 
  mutate(brain = brain / 1000,
         brain_to_body_ratio = brain / body,
         greater_than_1500 = body > 1500) -> dat

library(ggplot2)

g <- ggplot(dat, aes(log(brain), log(body), color = greater_than_1500)) + 
  geom_point() +
  geom_smooth(method = "lm", alpha = 0.2)
g
library(plotly)
htmlwidgets::saveWidget(ggplotly(g), "Figurer/graph1.html")