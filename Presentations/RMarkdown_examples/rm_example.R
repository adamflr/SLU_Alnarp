## ---- echo = T-----------------------------------------------------------
dat <- MASS::oats

## ---- echo = T-----------------------------------------------------------
dat_agg <- aggregate(Y ~ V + N, dat, function(x) c(mean(x), sd(x)))
dat_agg[,1] <- as.character(dat_agg[,1])
dat_agg <- data.frame(dat_agg[, 1:2], dat_agg[, 3])
names(dat_agg) <- c("Variety", "Nitrogen", "Mean", "Std.dev")
dat_agg[dat_agg$Variety == "Golden.rain", 1] <- "Golden Rain"
dat_agg <- dat_agg[order(dat_agg$Variety), ]

knitr::kable(dat_agg, digits = 2, 
             caption = "Mean and standard deviation of yield 
             per variety and nitrogen combination.",
             row.names = F)


## ---- echo = T, fig.width = 4.5, fig.height = 3.5, fig.cap="Mean of yield per variety and nitrogen combination. Error bars give standard deviation."----
library(ggplot2)
barchart <- ggplot(dat_agg, aes(Variety, Mean, fill = Nitrogen)) + 
  geom_bar(stat = "identity", position = position_dodge(), 
           col = "black") +
  geom_errorbar(aes(ymin = Mean - Std.dev,
                    ymax = Mean + Std.dev),
                position = position_dodge(0.9),
                width = 0.3) +
  theme_bw() +
  scale_fill_grey()
print(barchart)

## ---- echo = T, message = F----------------------------------------------
library(lme4, quietly = T)
library(lmerTest, quietly = T)

names(dat) <- c("Block", "Variety", "Nitrogen", "Yield")
mod <- lmer(Yield ~ Variety + Nitrogen + (1 | Block / Variety), dat)

knitr::kable(anovaTable <- anova(mod), digits = 2, 
             caption = "Anova results of analysis of yield.",
             row.names = T)

## ---- echo = T, message = F----------------------------------------------
library(emmeans, quietly = T)

knitr::kable(emmeansTable <- cld(emmeans(mod, "Nitrogen")), 
             digits = 2,
             caption = "Comparison between levels of nitrogen.")

