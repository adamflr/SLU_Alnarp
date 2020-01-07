# Code for presentation with introduction to R
data(Animals, package = "MASS")
dat <- Animals # Renames to dat

library(dplyr)

dat %>% 
  mutate(brain = brain / 1000,
         brain_to_body_ratio = brain / body)
