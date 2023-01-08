library(tidyverse)

# generate data where y is a function of two variables, x1 and x2
x1 <- seq(-4,4,0.5) #generate data ranging from -4 to 4 in steps of 0.5
x2 <- seq(-4,4,0.5)
#specify a sigmoidal relationship between x1 and y 
#and a linear relationship between x2 and y
dat <- expand.grid(x1=x1, x2=x2) %>% 
    mutate(y = 1/(1+exp(-x1)) + 0.1*x2)

head(dat)

# setting figure size
options(repr.plot.width=6, repr.plot.height=4)

dat  %>%
    gather(var, value, x1, x2) %>% # make it long format - only x1 or x2 in each row
    ggplot(aes(value, y)) +
    stat_summary(geom='point',fun=mean) +
    stat_summary(geom='line',fun=mean) +
    facet_wrap(~var)


#create new y_obs variable with normally distributed noise
dat <- mutate(dat, y_obs = y + rnorm(length(y), mean=0, sd=0.1)) 

#fit a linear model to find the regression coefficients
model_fit <- lm(y_obs ~ x1 + x2, data=dat) 

str(model_fit) #print the structure of the model object

model_fit$coefficients

#store the coefficients in a variable
coef <- model_fit$coefficients 

#save the name/value of the coefficients in a dataframe
data.frame(name = names(coef), value = coef) 

#extract model estimate of y for each x and store in df as fitted
dat$fitted <- model_fit$fitted.values 

#plot against the observed data 
ggplot(dat, aes(fitted, y_obs)) + 
    stat_summary(geom='point',fun=mean)

head(dat) #dataframe for fitted and obs. values. 

new_data <- data.frame(x1=-5, x2=10) #new x-values to give to the model 
predict(model_fit, newdata = new_data) #predict the y value for a given x 

dat  <- dat  %>%
        group_by(x1) %>%
        nest()

print(dat)

dat  <- dat  %>% 
    mutate(model_fit = map(data,
                           function(data) lm(y_obs ~ x2, data=data)))

print(dat)

dat[1, "model_fit"]

dat <- dat  %>% 
        mutate(coef = map(model_fit, #now iterating over "model_fit" instead of "data"
                      #a function to create data frame of coef names/values:
                      function(fit) data.frame(name = names(fit$coefficients), 
                                               beta = fit$coefficients)))
print(dat)

dat  <- dat  %>% 
        unnest(coef)

print(dat)
