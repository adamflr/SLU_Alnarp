Types of Sums of Squares in R
================

Types of SS
===========

In unbalanced factorial designs, there is no clear decompositon of the total sum of square into parts explained by each factor. Commercial software has introduced a taxonomy of four types of possible decomposition methods.

This piece mainly concerns the difference between type II and type III, as those are the most common choices. Those types of sums of squares are perhaps best introduced by example.

We create a pseudo-random dataset with two binary factors *A* and *B*. A third variable *A*<sub>*B*</sub> is calculated as the indicator of *A* = *B* and the response *y* is created so that there is an effect of factor *B* but not of factor *A* or the interaction.

``` r
  set.seed(8)
.a <- data.frame(A = sample(0:1, 100, T),
                 B = sample(0:1, 100, T))
.a$A_B <- as.numeric(.a$A == .a$B)
.a$y <- .a$B + rnorm(100)
for(i in 1:3) {.a[, i] <- factor(.a[, i])}

head(.a)
```

    ##   A B A_B          y
    ## 1 0 1   0  1.2968513
    ## 2 0 0   1 -1.9005736
    ## 3 1 0   0 -1.6473656
    ## 4 1 0   0 -1.7784054
    ## 5 0 1   0  1.0349434
    ## 6 1 1   1  0.5054536

Next, some different possible models are estimated and the SSE calculated. The anova table with type II sums of squares is calculated using the Anova function in the car package.

``` r
  sum(residuals(lm(y ~ A, .a))^2)
```

    ## [1] 132.1466

``` r
sum(residuals(lm(y ~ B, .a))^2)
```

    ## [1] 112.7595

``` r
sum(residuals(lm(y ~ A + B, .a))^2)
```

    ## [1] 111.8651

``` r
sum(residuals(lm(y ~ A + B + A_B, .a))^2)
```

    ## [1] 110.0759

``` r
library(car)

Anova(lm(y ~ A * B, .a), type = 2)
```

    ## Anova Table (Type II tests)
    ## 
    ## Response: y
    ##            Sum Sq Df F value    Pr(>F)    
    ## A           0.894  1  0.7800    0.3793    
    ## B          20.282  1 17.6880 5.848e-05 ***
    ## A:B         1.789  1  1.5604    0.2146    
    ## Residuals 110.076 96                      
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

We can now identify the calculation of the sums of squares: *S**S*<sub>*A*</sub> is the decrease in *S**S**E* when the model with factor A and factor B is compared to the model with only factor B; SS\_B is similar; *S**S*<sub>*A*\_*B*</sub> is the decrease in *S**S**E* when the full-factorial model is compared to the model with factor A and factor B.

We make a similar calculation demonstrating sums of squares of type III. Note that specific contrasts must be set in order to get correct results from the Anova function.

``` r
  sum(residuals(lm(y ~ A + A_B, .a))^2)
```

    ## [1] 130.8381

``` r
sum(residuals(lm(y ~ B + A_B, .a))^2)
```

    ## [1] 111.0342

``` r
sum(residuals(lm(y ~ A + B, .a))^2)
```

    ## [1] 111.8651

``` r
sum(residuals(lm(y ~ A + B + A_B, .a))^2)
```

    ## [1] 110.0759

``` r
Anova(lm(y ~ A * B, .a, 
         contrasts = list(A = contr.sum,
                          B = contr.sum)), 
      type = 3)
```

    ## Anova Table (Type III tests)
    ## 
    ## Response: y
    ##              Sum Sq Df F value    Pr(>F)    
    ## (Intercept)  23.424  1 20.4287 1.766e-05 ***
    ## A             0.958  1  0.8358    0.3629    
    ## B            20.762  1 18.1072 4.857e-05 ***
    ## A:B           1.789  1  1.5604    0.2146    
    ## Residuals   110.076 96                      
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

So the SS type III is the decrease in SSE when the interaction model is compared to a model where the factor of interest has been dropped.

These examples generalize to models with more factors with more factor levels.

The Case for Type III
---------------------

The Case for Type II
--------------------

The main advantage of SS type II must be the greater power for main effects, in comparison to type III. A simple example in an unbalanced design is given below. The p-value of the F-test differs greatly between SS type II and SS type III. In the type III case, the main effect is underestimated because of confounding with the interaction effect.

``` r
  set.seed(6)
.a <- data.frame(A = c(rep(0, 5), rep(0, 5), 
                       rep(1, 50), rep(1, 50)),
                 B = c(rep(0, 5), rep(1, 5), 
                       rep(0, 50), rep(1, 50)))
.a$y <- .a$B + rnorm(dim(.a)[1], sd = 1)
.a$AB <- .a$A == .a$B + 0
with(.a, table(A,B))
```

    ##    B
    ## A    0  1
    ##   0  5  5
    ##   1 50 50

``` r
.a$A <- factor(.a$A)
.a$B <- factor(.a$B)

mod <- lm(y ~ A * B, .a, 
          contrasts = list(A = contr.sum, B = contr.sum))

Anova(mod, type = 2)
```

    ## Anova Table (Type II tests)
    ## 
    ## Response: y
    ##            Sum Sq  Df F value    Pr(>F)    
    ## A           0.221   1  0.2188    0.6409    
    ## B          17.693   1 17.5511 5.804e-05 ***
    ## A:B         0.675   1  0.6691    0.4152    
    ## Residuals 106.858 106                      
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

``` r
Anova(mod, type = 3)
```

    ## Anova Table (Type III tests)
    ## 
    ## Response: y
    ##              Sum Sq  Df F value   Pr(>F)   
    ## (Intercept)  10.117   1 10.0361 0.002006 **
    ## A             0.221   1  0.2188 0.640911   
    ## B             3.050   1  3.0257 0.084856 . 
    ## A:B           0.675   1  0.6691 0.415193   
    ## Residuals   106.858 106                    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
