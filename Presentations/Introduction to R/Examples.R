# Code for presentation with introduction to R
data(Animals, package = "MASS")
dat <- Animals # Renames to dat

library(dplyr)

dat %>% 
  mutate(animal = row.names(dat),
         body = body * 1000, 
         greater_than_1500 = body > 1500) -> dat

library(ggplot2)

g <- ggplot(dat, aes(log(brain), log(body), color = greater_than_1500, text = row.names(dat))) + 
  geom_point() +
  geom_smooth(method = "lm", alpha = 0.2)
g

g <- ggplot(dat, aes(log(brain), log(body), color = greater_than_1500, text = animal)) + 
  geom_point() +
  geom_smooth(method = "lm", alpha = 0.2) +
  theme_bw()
g

library(plotly)
library(htmlwidgets)
saveWidget(ggplotly(g), "c:/Eg/R/SLU_Alnarp/Presentations/Introduction to R/Figurer/graph1.html")
