Binomial and logistic regression in R
================

Introduction and example set
============================

Binomial and logistic regression are probably the most widely used tools to analyze regression data where the response variable y is a binary variable. A typical example of such data could be an olfactometer experiment where the response variable is the choice of an insect (left or right) and a set of explanatory variables x are given by properties of the individual insect (species, sex etc) and the choice of treatment in the olfactometer. We simulate such an example set.

``` r
set.seed(7)
data1 <- data.frame(sex = rep(c("m", "f"), each = 18),
                    treat = rep(letters[1:3], 12))
data1$pos <- rnorm(36) + rnorm(2)[as.numeric(data1$sex)] + rnorm(3)[as.numeric(data1$treat)]
data1$pos <- with(data1, rbinom(36, 1, exp(pos) / (1 + exp(pos))))

head(data1)
```

    ##   sex treat pos
    ## 1   m     a   1
    ## 2   m     b   0
    ## 3   m     c   0
    ## 4   m     a   0
    ## 5   m     b   0
    ## 6   m     c   1

Each observation is one insect's choice between the treatment and a control. The response `pos` is 1 if the insect goes in the direction of the treatment and 0 if the insect goes for the control.

One crucial aspect of data such as this (a binary response and discrete variables as explanatory), is that it can be aggregated without loss of information.

``` r
data2 <- aggregate(pos ~ sex + treat, data1, sum)
data2$neg <- with(data2, 6 - pos)
data2$trials <- 6

data2
```

    ##   sex treat pos neg trials
    ## 1   f     a   4   2      6
    ## 2   m     a   3   3      6
    ## 3   f     b   5   1      6
    ## 4   m     b   1   5      6
    ## 5   f     c   6   0      6
    ## 6   m     c   4   2      6

Instead of one row per insect `data2` contains one row per sex-treatment combination. The response `pos` gives the number of positives out of the 6 trials.

Logistic regression and binomial regression
===========================================

Fixed effects
-------------

Given that the data can be presented in two ways (per observation or per treatment), it makes sense that it can be modelled in two different ways. We can either model the data using the binary variables `data1$pos` as response, or using the aggregated variable `data2$pos`. In the latter case we need to include the information about the number of trials `data2$trials` as well. The `glm` function allows for both formulations. We start with the per-observation-formulation.

``` r
mod1 <- glm(pos ~ sex + treat, data1, family = binomial)

summary(mod1)
```

    ## 
    ## Call:
    ## glm(formula = pos ~ sex + treat, family = binomial, data = data1)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -1.8274  -0.7817   0.3150   0.7817   1.6338  
    ## 
    ## Coefficients:
    ##             Estimate Std. Error z value Pr(>|z|)  
    ## (Intercept)   1.4610     0.8375   1.744   0.0811 .
    ## sexm         -2.0581     0.8583  -2.398   0.0165 *
    ## treatb       -0.4319     0.9346  -0.462   0.6440  
    ## treatc        1.5174     1.0667   1.422   0.1549  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for binomial family taken to be 1)
    ## 
    ##     Null deviance: 47.092  on 35  degrees of freedom
    ## Residual deviance: 36.942  on 32  degrees of freedom
    ## AIC: 44.942
    ## 
    ## Number of Fisher Scoring iterations: 4

``` r
library(car)
Anova(mod1)
```

    ## Analysis of Deviance Table (Type II tests)
    ## 
    ## Response: pos
    ##       LR Chisq Df Pr(>Chisq)   
    ## sex     6.8076  1   0.009077 **
    ## treat   4.0087  2   0.134744   
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

The first option specifies the formula in the standard format. The `family` option specifies the distribution of the generalized linear model. The standard link for the binomial family is the logit function.

As for the aggregated data, there are two equivalent formulations. In the top one the response is written as the ratio between the number of positive outcomes and the number of trials, and the number of trials is added as a weight variables. In the second formulation, the number of positive outcomes and the number of negative outcomes (number of trials minus the number of positive outcomes) are binded into a matrix with two columns using `cbind(pos, neg)`, and this matrix is used as the response variable.

``` r
mod2 <- glm(pos/trials ~ sex + treat, data2, family = binomial, weights = trials)
mod3 <- glm(cbind(pos, neg) ~ sex + treat, data2, family = binomial)

summary(mod2)
```

    ## 
    ## Call:
    ## glm(formula = pos/trials ~ sex + treat, family = binomial, data = data2, 
    ##     weights = trials)
    ## 
    ## Deviance Residuals: 
    ##       1        2        3        4        5        6  
    ## -0.8423   0.7261   0.5637  -0.5637   0.7717  -0.2587  
    ## 
    ## Coefficients:
    ##             Estimate Std. Error z value Pr(>|z|)  
    ## (Intercept)   1.4610     0.8375   1.744   0.0811 .
    ## sexm         -2.0581     0.8583  -2.398   0.0165 *
    ## treatb       -0.4319     0.9346  -0.462   0.6440  
    ## treatc        1.5174     1.0668   1.422   0.1549  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for binomial family taken to be 1)
    ## 
    ##     Null deviance: 12.6844  on 5  degrees of freedom
    ## Residual deviance:  2.5345  on 2  degrees of freedom
    ## AIC: 20.951
    ## 
    ## Number of Fisher Scoring iterations: 4

``` r
summary(mod3)
```

    ## 
    ## Call:
    ## glm(formula = cbind(pos, neg) ~ sex + treat, family = binomial, 
    ##     data = data2)
    ## 
    ## Deviance Residuals: 
    ##       1        2        3        4        5        6  
    ## -0.8423   0.7261   0.5637  -0.5637   0.7717  -0.2587  
    ## 
    ## Coefficients:
    ##             Estimate Std. Error z value Pr(>|z|)  
    ## (Intercept)   1.4610     0.8375   1.744   0.0811 .
    ## sexm         -2.0581     0.8583  -2.398   0.0165 *
    ## treatb       -0.4319     0.9346  -0.462   0.6440  
    ## treatc        1.5174     1.0668   1.422   0.1549  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for binomial family taken to be 1)
    ## 
    ##     Null deviance: 12.6844  on 5  degrees of freedom
    ## Residual deviance:  2.5345  on 2  degrees of freedom
    ## AIC: 20.951
    ## 
    ## Number of Fisher Scoring iterations: 4

``` r
Anova(mod2)
```

    ## Analysis of Deviance Table (Type II tests)
    ## 
    ## Response: pos/trials
    ##       LR Chisq Df Pr(>Chisq)   
    ## sex     6.8076  1   0.009077 **
    ## treat   4.0087  2   0.134744   
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

``` r
Anova(mod3)
```

    ## Analysis of Deviance Table (Type II tests)
    ## 
    ## Response: cbind(pos, neg)
    ##       LR Chisq Df Pr(>Chisq)   
    ## sex     6.8076  1   0.009077 **
    ## treat   4.0087  2   0.134744   
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

All three models give the same parameter estimation, the same standard errors of parameters, and the same results in likelihood ratio tests. The deviance does however differ, due to the connection between deviance and likelihood, and the differences in likelihood between the models.

Random effects
--------------

We move to the situation with random factors: sex remains a fixed effect, but the treatment is a random effect. Estimation is done using the `glmer` function from the `lme4` package.

``` r
library(lme4)
```

    ## Loading required package: Matrix

``` r
mod1 <- glmer(pos ~ sex + (1 | treat), data1, family = binomial)
mod2 <- glmer(pos/trials ~ sex + (1 | treat), data2, family = binomial, weights = trials)
mod3 <- glmer(cbind(pos, neg) ~ sex + (1 | treat), data2, family = binomial)

summary(mod1)
```

    ## Generalized linear mixed model fit by maximum likelihood (Laplace
    ##   Approximation) [glmerMod]
    ##  Family: binomial  ( logit )
    ## Formula: pos ~ sex + (1 | treat)
    ##    Data: data1
    ## 
    ##      AIC      BIC   logLik deviance df.resid 
    ##     46.9     51.6    -20.4     40.9       33 
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -2.2082 -0.8236  0.3931  0.4746  1.2141 
    ## 
    ## Random effects:
    ##  Groups Name        Variance Std.Dev.
    ##  treat  (Intercept) 0.1197   0.346   
    ## Number of obs: 36, groups:  treat, 3
    ## 
    ## Fixed effects:
    ##             Estimate Std. Error z value Pr(>|z|)  
    ## (Intercept)   1.6491     0.6859   2.405   0.0162 *
    ## sexm         -1.8788     0.8190  -2.294   0.0218 *
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##      (Intr)
    ## sexm -0.773

``` r
summary(mod2)
```

    ## Generalized linear mixed model fit by maximum likelihood (Laplace
    ##   Approximation) [glmerMod]
    ##  Family: binomial  ( logit )
    ## Formula: pos/trials ~ sex + (1 | treat)
    ##    Data: data2
    ## Weights: trials
    ## 
    ##      AIC      BIC   logLik deviance df.resid 
    ##     22.9     22.2     -8.4     16.9        3 
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -1.1856 -0.7705  0.2351  0.7136  0.9630 
    ## 
    ## Random effects:
    ##  Groups Name        Variance Std.Dev.
    ##  treat  (Intercept) 0.1198   0.3461  
    ## Number of obs: 6, groups:  treat, 3
    ## 
    ## Fixed effects:
    ##             Estimate Std. Error z value Pr(>|z|)  
    ## (Intercept)   1.6491     0.6859   2.405   0.0162 *
    ## sexm         -1.8788     0.8190  -2.294   0.0218 *
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##      (Intr)
    ## sexm -0.773

``` r
summary(mod3)
```

    ## Generalized linear mixed model fit by maximum likelihood (Laplace
    ##   Approximation) [glmerMod]
    ##  Family: binomial  ( logit )
    ## Formula: cbind(pos, neg) ~ sex + (1 | treat)
    ##    Data: data2
    ## 
    ##      AIC      BIC   logLik deviance df.resid 
    ##     22.9     22.2     -8.4     16.9        3 
    ## 
    ## Scaled residuals: 
    ##     Min      1Q  Median      3Q     Max 
    ## -1.1856 -0.7705  0.2351  0.7136  0.9630 
    ## 
    ## Random effects:
    ##  Groups Name        Variance Std.Dev.
    ##  treat  (Intercept) 0.1198   0.3461  
    ## Number of obs: 6, groups:  treat, 3
    ## 
    ## Fixed effects:
    ##             Estimate Std. Error z value Pr(>|z|)  
    ## (Intercept)   1.6491     0.6859   2.405   0.0162 *
    ## sexm         -1.8788     0.8190  -2.294   0.0218 *
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Correlation of Fixed Effects:
    ##      (Intr)
    ## sexm -0.773

The function support all three formula variations and the resulting parameter estimations are the same. As before, the likelihood-based information critera differ between the model on data in long form (with the binary outcome) and the models on data in aggregated form (the binomial outcome).

Diagnostics
===========

Theory
======
