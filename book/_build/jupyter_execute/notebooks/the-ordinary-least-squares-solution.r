x <- seq(0,5,0.1) # x is a vector with numbers from 1 to 10
f <- x^2 # f is a vector with the values of the function for x = 1 to x = 10
df_dx <- 2*x # df_dx is a vector with the values of the derivative for x = 1 to x = 10
library(tidyverse)
x_dat <- data.frame(x=x,f=f,df_dx=df_dx) # make a data frame so we can plot these nicely
x_dat <- gather(x_dat, "func","value",f:df_dx) # put data frame in long form
x_dat$func <- x_dat$func %>% factor() %>% relevel("f") # makes it so "f" is the function plotted on left
ggplot(x_dat,aes(x=x,y=value)) + geom_line() + facet_grid(. ~ func) # plot func

x <- seq(0,5,0.1)
f <- cos(x)
x_min <- x[which.min(f)] # find the x value where f is at minimum
df_dx <- -sin(x)
x_dat <- data.frame(x=x,f=f,df_dx=df_dx) # make a data frame so we can plot these nicely
x_dat <- gather(x_dat, "func","value",f:df_dx) # put data frame in long form
x_dat$func <- x_dat$func %>% factor() %>% relevel("f") # makes it so "f" is the function plotted on left
ggplot(x_dat,aes(x=x,y=value)) + geom_line() + facet_grid(. ~ func) +
      geom_vline(xintercept = x_min,linetype="dashed",color="red")# add line where f is min

x <- seq(0,5,0.1)
f <- (x-2)^2 + 6
x_dat <- data.frame(x,f)
require(ggplot2) #in case you need to load the library again
ggplot(x_dat,aes(x=x,y=f)) + geom_line()


x <- seq(0,5,0.1)
f <- (x-2)^2 + 6
log_f <- log(f)
x_dat <- data.frame(x,f,log_f)
require(tidyverse)
x_dat <- gather(x_dat,"func","value",f:log_f) #put this in long form
ggplot(x_dat,aes(x=x,y=value)) + geom_line() + facet_grid(.~func) #plot function and log transformation of function side by side. 
