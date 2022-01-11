# set the size of the plot for the notebook
options(repr.plot.width=7, repr.plot.height=7) 
library(tidyverse)#load the library - ggplot2 is included in tidyverse, and we'll use some of the other data manipulation functions too

ggplot(diamonds, aes(x=carat, y=price)) + #diamonds = the dataframe & aes() maps the carat variable to the x axis [...] 
    geom_point(size=0.5) + #set size of the points plotted 
    scale_x_continuous(name = 'Carat') #can set the x-tick interval/limits, here, I give it a name

options(repr.plot.width=8, repr.plot.height=8)
# Change color of points as a function of their clarity
ggplot(diamonds, aes(x=carat, y=price, color=clarity)) +
    geom_point() +
    scale_x_continuous(name = 'Carat')

# get a smaller subset of data, to reduce overplotting
dsmall <- diamonds[sample(nrow(diamonds), 100), ] #randomly sample 100 data points

# Scatter plot of diamond price as a function of their carat and clarity
ggplot(dsmall, aes(x=carat, y=price, shape=clarity)) + #change shape with clarity
    geom_point(size=2) +
    scale_x_continuous(name = 'Carat')

#as the first warning mentions, clarity is an ordinal variable because clarity ratings are ordered - 
# ggplot is telling us that shapes aren't the best way to convey ordinal information. 
#as the second warning below mentions, there are limits to the automatic assignment of shapes 
# may need to specify explicit assignments if n_shapes (or any plot element) 
# exceeds automated capacity

# Scatter plot of diamond price as a function of their carat and clarity
#clarity according to size AND color
ggplot(dsmall, aes(x=carat, y=price, size=clarity, color=clarity)) +
    geom_point() +
    scale_x_continuous(name = 'Carat')

# overplotting
# Scatter plot of diamond price as a function of their carat and clarity
ggplot(diamonds, aes(x=carat, y=price, color=clarity)) +
    geom_point()

# # summarized plot of diamond price as a function of their carat and clarity
ggplot(diamonds, aes(x=carat, y=price, color=clarity)) +
    stat_summary(geom='point',fun=mean)

# # summarized plot of diamond price as a function of binned carat and clarity
ggplot(diamonds, aes(x=round(carat,1), y=price, color=clarity)) +
    stat_summary(geom='point', fun=mean) 

# # summarized plot of diamond price as a function of binned carat and clarity
ggplot(diamonds, aes(x=round(carat,1), y=price, color=clarity)) +
    stat_summary(geom='point',fun=mean) +
    stat_summary(geom='line',fun=mean) #you can layer geoms like this

# # summarized plot of diamond price as a function of binned carat and clarity
ggplot(diamonds, aes(x=round(carat,1), y=price, color=clarity)) +
    stat_summary(geom='pointrange') + #adding error bars in the form of a line with a range
    stat_summary(geom='point',fun=mean) +
    stat_summary(geom='line',fun=mean)

# # summarized plot of diamond price as a function of binned carat and clarity
ggplot(diamonds, aes(x=carat)) +
    geom_histogram(fill='white',color='black') #histogram

ggplot(diamonds, aes(x=price)) +
    geom_density(fill='white',color='black') #density plot

library(tidyverse)
ggplot(diamonds, aes(x=carat  %>% log()  %>% round(1), y=log(price), color=clarity)) +
    stat_summary(geom='linerange') +
    stat_summary(geom='point',fun=mean) +
    stat_summary(geom='line',fun=mean)

diamonds %>% 
    mutate(log_carat = carat  %>% log()  %>% round(1),
           log_price = log(price))  %>% 
    ggplot(aes(x=log_carat, y=log_price, color=clarity)) +
    stat_summary(geom='linerange') +
    stat_summary(geom='point',fun=mean) +
    stat_summary(geom='line',fun=mean)

ggplot(diamonds, aes(x=clarity, y=log(price))) +
    geom_boxplot()

ggplot(diamonds, aes(x=clarity, y=log(price))) +
    geom_violin()

ggplot(dsmall, aes(x=clarity,y=log(price),fill=clarity,col=clarity)) + geom_dotplot(binaxis="y",stackdir="center")
