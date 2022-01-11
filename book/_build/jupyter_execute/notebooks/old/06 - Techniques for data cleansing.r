library(tidyverse)

# generate data where y is a function of two variables, x1 and x2
x1 <- seq(-4,4,0.5) #generate data ranging from -4 to 4 in steps of 0.5
x2 <- seq(-4,4,0.5)
dat <- expand.grid(x1=x1, x2=x2)  %>% mutate(y = 1/(1+exp(-x1)) + 0.1*x2) #specify a sigmoidal relationship between x1 and y and a linear relationship between x2 and y

options(repr.plot.width=6, repr.plot.height=4)
dat  %>%
    gather(var, value, x1, x2)  %>% # make it long format - only x1 or x2 in each row
    ggplot(aes(value, y)) +
    stat_summary(geom='point',fun=mean) +
    stat_summary(geom='line',fun=mean) +
    facet_wrap(~var)

dat <- mutate(dat, y_obs = y + rnorm(length(y), mean=0, sd=0.1)) #add normally distributed noise
model_fit <- lm(y_obs ~ x1 + x2, data=dat) #fit a linear model to find the regression coeff.

str(model_fit) #print the structure of the model object

model_fit$coefficients

coef <- model_fit$coefficients #store the coefficients in a variable
data.frame(name = names(coef), value = coef) #save the name/value of the coefficients in a df

dat$fitted <- model_fit$fitted.values #extract model estimate of y for each x and store in df as fitted
ggplot(dat, aes(fitted, y_obs)) + #plot against the observed data 
    stat_summary(geom='point',fun=mean)

head(dat) #dataframe for fitted and obs. values. 

new_data <- data.frame(x1=-5, x2=10) #new x-values to give to the model 
predict(model_fit, newdata = new_data) #predict the y value for a given x 

dat  %>%
    group_by(x1) %>% 
    nest() %>%
    print()

dat  %>% 
    group_by(x1)  %>% 
    nest()  %>% 
    mutate(model_fit = map(data, function(data) lm(y_obs ~ x2, data=data)))  %>% 
    print()

dat  %>% 
    group_by(x1)  %>% 
    nest()  %>% 
    mutate(model_fit = map(data, function(data) lm(y_obs ~ x2, data=data)),
           coef = map(model_fit, function(fit) data.frame(name=names(fit$coefficients), beta=fit$coefficients)))  %>% 
    print()

dat  %>% 
    group_by(x1)  %>% 
    nest()  %>% 
    mutate(model_fit = map(data, function(data) lm(y_obs ~ x2, data=data)),
           coef = map(model_fit, function(fit) data.frame(name=names(fit$coefficients), beta=fit$coefficients))) %>%
    unnest(coef) %>%
    print()
