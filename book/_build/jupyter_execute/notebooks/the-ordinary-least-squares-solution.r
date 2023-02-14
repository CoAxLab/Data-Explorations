x <- seq(0,5,0.1)
head(x)

f <- x^2 
head(f)

df_dx <- 2*x 
head(df_dx)

library(tidyverse)
# make a data frame so we can plot these nicely
x_dat <- data.frame(x=x,f=f,df_dx=df_dx) 
# put data frame in long form
x_dat <- gather(x_dat, "func","value",f:df_dx) 
# makes it so "f" is the function plotted on left
x_dat$func <- x_dat$func %>% factor() %>% relevel("f")
ggplot(x_dat,aes(x=x,y=value)) + geom_line() + facet_grid(. ~ func) # plot func

x <- seq(0,5,0.1)
f <- cos(x)
x_min <- x[which.min(f)] # find the x value where f is at minimum
df_dx <- -sin(x)

#plotting
# make a data frame so we can plot these nicely:
x_dat <- data.frame(x=x,f=f,df_dx=df_dx) 
# put data frame in long form:
x_dat <- gather(x_dat, "func","value",f:df_dx) 
# makes it so "f" is the function plotted on left
x_dat$func <- x_dat$func %>% factor() %>% relevel("f")

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
#plot function and log transformation of function side by side. 
ggplot(x_dat,aes(x=x,y=value)) + geom_line() + facet_grid(.~func) 
