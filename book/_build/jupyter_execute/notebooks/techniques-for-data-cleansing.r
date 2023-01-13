install.packages('tidyverse')
library(tidyverse)

dat <- iris
head(dat)

mean(iris$Sepal.Width)

iris$Sepal.Width %>% mean()

# nested
round(mean(iris$Sepal.Width), 2)

# tmp variable
obs_mean = mean(iris$Sepal.Width)
round(obs_mean, 2)

# with pipes
iris$Sepal.Width %>% 
    mean() %>% 
    round(2)

dat <- dat  %>%  #need to reassign the dat object with our new changes
    mutate(centered_SepLen = Sepal.Length - mean(Sepal.Length))

head(dat)

# center sepal length
dat$centered_SepLen = dat$Sepal.Length - mean(dat$Sepal.Length) 
# transforms petal length into zscores
dat$PetLen_zscores = (dat$Petal.Length - mean(dat$Petal.Length))/sd(dat$Petal.Length)

dat <- dat  %>%  
    mutate(centered_SepLen = Sepal.Length - mean(Sepal.Length),  # center Sepal Lengths
           PetLen_zscores = (Petal.Length - mean(Petal.Length))/sd(Petal.Length),  # zscore the Petal Lengths
           n_flowers = length(Species))              # calculate the total number of flowers
head(dat)

smry <- dat  %>% #creating new smry object
    summarise(n_flowers = length(Species), #how many observations (flowers) are there total? 
              shortSepal_prop = mean(centered_SepLen < 0), #what prop. have smaller-than-average sepal length?
              setosa_prop = mean(Species == 'setosa'), #what prop. of measured flowers are species Setosa?
              SepLen_mean = mean(Sepal.Length), #mean sepal length
              SepLen_sd = sd(Sepal.Length), #standard deviation of sepal length
              SepLen_se = SepLen_sd / sqrt(n_flowers)
              )
smry

print(paste('species options:',paste(levels(dat$Species),collapse=", ")))

# get rid of all setosa flowers and any flowers with negative sepal lengths
cleaned_dat <- dat  %>% 
    filter(Species != 'setosa', #!= is read "not equal to"
           Sepal.Length >= 0)

# make new data.frames for the remaining two species
versi.dat <- filter(cleaned_dat, Species == 'versicolor')
virgi.dat <- filter(cleaned_dat, Species == 'virginica')

# look at first six rows of all three data.frames
head(cleaned_dat); head(versi.dat); head(virgi.dat)

# calculate summarise for versicolor species
dat  %>% 
 filter(Species == 'versicolor')  %>% 
 summarise(SepLen_mean = mean(Sepal.Length),
           SepLen_sd = sd(Sepal.Length))

# calculate summarise for virginica species
dat  %>% 
 filter(Species == 'virginica')  %>% 
 summarise(SepLen_mean = mean(Sepal.Length),
           SepLen_sd = sd(Sepal.Length))

dat  %>% 
    select(Species, Petal.Length, Petal.Width) %>%
    head() 

#remove original petal length & width variables
dat  %>% 
    select(-Petal.Length, -Petal.Width) %>%
    head()  

# look at full data set to see order
head(dat)

# look at just a certain range of variables
dat  %>% 
    select(Sepal.Length:Species) %>%
    head()

dat  %>% 
    select(starts_with("Petal")) %>% 
    head()

dat %>% 
    arrange(Species, desc(Petal.Length)) %>%
    head()

#levels(dat$Species)
#dat  %>% 
#    arrange(desc(Species), desc(Petal.Length)) %>%
#    head()

dat <- dat  %>%  
    mutate(PetalType = if_else(Petal.Length > mean(Petal.Length),"long","short"))

head(dat)

dat <- dat %>% 
      unite(Combined_var, Species, PetalType, remove=FALSE)
head(dat)

ggplot(dat, aes(Sepal.Length, Petal.Length, color = Combined_var))+ geom_point(size = 1.5)

dat <- dat  %>% 
    separate(Combined_var, into=c('Species1', 'PetalType1'))
head(dat)

dat %>% 
    group_by(Species, PetalType) %>%
    print()

dat  %>% 
    group_by(Species, PetalType)  %>% 
    summarise(SepLen_mean = mean(Sepal.Length),
              SepLen_sd = sd(Sepal.Length),
              SepWid_mean = mean(Sepal.Width),
              SepWid_sd = sd(Sepal.Length))


dat_centered  <- dat  %>% 
 #center values by mean for all data:
 mutate(SepLen_centered_overall = Sepal.Length - mean(Sepal.Length)) %>% 
 group_by(Species)  %>% 
 #center values by mean for each species:
 mutate(SepLen_centered_byspecies = Sepal.Length - mean(Sepal.Length)) %>% 
 #just show the relevant variables (there are a lot of variables in this data.frame now!):
 select(Species, SepLen_centered_overall:SepLen_centered_byspecies)

head(dat_centered)

dat_centered %>% 
    pivot_longer(c(SepLen_centered_overall, SepLen_centered_byspecies)) %>% 
    ggplot(aes(Species, value, color=name)) +
    stat_summary(geom='point',fun=mean, size = 2.5) +
    theme_classic()

#Initial dataframe
nested  <- dat  %>% 
    select(c(Sepal.Length:Petal.Width, Species, PetalType))
head(nested)

#nesting
nested %>% 
    nest(data = c(Sepal.Length:Petal.Width, PetalType)) %>% 
    print

nested %>% 
    nest(data = c(Sepal.Length:Petal.Width, PetalType)) %>% 
    pull(data) %>% #tidyverse version of $ -- selecting data column
    first()  %>%  #pulling first row
    head() #just top 6 lines

nested %>% 
    nest(data = c(Sepal.Length:Petal.Width)) %>% #re-nesting with different variables
    print()

nested  %>% 
    group_by(Species) %>% 
    nest() %>% 
    print()

nested  <- nested %>% 
    group_by(Species, PetalType) %>% 
    nest() %>% 
    print()

nested_lm  <- nested  %>% 
    mutate(model_fit = map(data, #column name in nested df
                           function(nest_df) lm(Sepal.Length ~ Petal.Length, data=nest_df))) 

print(nested_lm)

nested_lm %>%  
    pull(model_fit) %>% #tidyverse version of $ -- selecting model_fit column
    first()  %>%  #pulling first row
    head(2) #just top 2 lines of nested df

nested_lm <- nested_lm  %>% 
        mutate(coef = map(model_fit, #now iterating over "model_fit" instead of "data"
                      #a function to create data frame of coef names/values:
                      function(fit) data.frame(name = names(fit$coefficients), 
                                               beta = fit$coefficients)))
print(nested_lm)

nested_lm  <- nested_lm  %>% 
        unnest(coef)

print(nested_lm)

newdat <- iris # new duplicate
newdat$flower.num <- 1:nrow(newdat) # add ID
head(newdat)

newdat <- newdat %>%
      pivot_longer(cols = c(Sepal.Length, Sepal.Width, #concatenate to select multiple
                            Petal.Length, Petal.Width),
                   names_to = "iris_attribute",
                   values_to = "value")
head(newdat)

newdat <- newdat %>%
      pivot_wider(names_from = "iris_attribute", values_from = "value")
head(newdat)

# participant info
personal <- data.frame(name = c("p01", "p02", "p03"),
                       age = c(18, 21, 23), 
                       firstlang = c("English", "Chinese", "English"))

# response database
response <- data.frame(name= c("p01","p01","p02","p02"),
                       response=c(0,1,1,0))
head(personal)
head(response)

personal %>% 
    left_join(response, by = "name") %>% #piped "personal" in, so only one df here
    head()

personal %>% 
    right_join(response, by = "name") %>% #piped "personal" in, so only one df here
    head()
