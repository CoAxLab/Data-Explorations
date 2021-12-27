# function to install the packages if missing, otherwise, just load them
import_packages <- function(packages) {
    for (package in packages) {
        if (!(package %in% row.names(installed.packages()))) { #if the package is not installed
            install.packages(package, repos = "http://cran.us.r-project.org") #install from archive
        } 
        library(package, character.only = TRUE) #load the set of packages that you gave to the function
    }
}

import_packages(c('tidyverse')) #call the function with tidyverse as the input

6+2
10-3*4
5^3

a <- c(1,2,3)
b <- c(4,5,6)
print(paste("mean of vector a:",mean(a)))
print(paste("sum of vector b:",sum(b)))

a*b

c <- c("one","two","three")
data <- data.frame(avar=a,bvar=b,cvar=c)
data

a[2]

data[2,1]

data$bvar

print("Column 3")
data[,3]

print("Row 1")
data[1,]

long_data <- data.frame(subject = rep(1:3, each=4),
                        timepoint = rep(1:4, times=3),
                        observation = round(rnorm(12), 2))
long_data

long_data  %>% 
    mutate(timepoint = paste0('time',timepoint))  %>% 
    spread(timepoint, observation)

mean(long_data$observation)

long_data$observation  %>% mean()

# nested
round(mean(long_data$observation), 2)

# tmp variable
obs_mean = mean(long_data$observation)
round(obs_mean, 2)

# with pipes
long_data$observation  %>% mean()  %>% round(2)

# pipes on separate rows:
long_data$observation  %>% 
  mean() %>% 
  round(2)

# with pipes
long_data  %>% 
    mutate(timepoint = paste0('time',timepoint))  %>% 
    spread(timepoint, observation)

# nested functions
spread(mutate(long_data, timepoint = paste0('time',timepoint)), timepoint, observation)

# temporary variables
mutated_data <- mutate(long_data, timepoint = paste0('time',timepoint))
spread(mutated_data, timepoint, observation)

dat <- iris
head(dat)

?iris

head(dat)

dat <- mutate(dat, centered_SepLen = Sepal.Length - mean(Sepal.Length))
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

smry <- dat  %>% 
    summarise(n_flowers = length(Species), # how many observations (flowers) are there total? 
              shortSepal_prop = mean(centered_SepLen < 0), # what proportion of these flowers have smaller-than-average sepal length?
              setosa_prop = mean(Species == 'setosa'), # what proportion of measured flowers are species Setosa?
              SepLen_mean = mean(Sepal.Length), # mean sepal length
              SepLen_sd = sd(Sepal.Length), # standard deviation of sepal length
              SepLen_se = SepLen_sd / sqrt(n_flowers)
              )
smry
              

print(paste('species options:',paste(levels(dat$Species),collapse=", ")))

# get rid of all setosa flowers and any flowers with negative sepal lengths
cleaned_dat <- dat  %>% 
    filter(Species != 'setosa',
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

select(dat, Species, Petal.Length, Petal.Width)  %>% head() #to keep only specific variables, list them one after another like this

select(dat, -Sepal.Length, -Sepal.Width)  %>% head() #remove original sepal length & width variables

# look at full data set
head(dat)
# look at just a certain range of variables
select(dat, Sepal.Length:Species)  %>% head()  #note that this is an inclusive range - the first and last variables are included

arrange(dat, Species, desc(Petal.Length))  %>% head()

# arrange(dat, desc(Species), desc(Petal.Length)) %>% head()

dat <- dat  %>%  
    mutate(PetalType = ifelse(Petal.Length > mean(Petal.Length),"long","short"))

barplot(table(dat$PetalType),main="Number of flowers for each PetalType")

head(dat)


dat <- dat %>% 
      unite(Combined_var, Species, PetalType, remove=FALSE)
head(dat)

dat <- dat  %>% 
    separate(Combined_var, into=c('Species1', 'PetalType1')) #separate the combined variable into the two original variables. 
head(dat)

cleaned_dat <- cleaned_dat  %>%  
    mutate(PetalType = ifelse(Petal.Length > mean(Petal.Length),"long","short")) # this creates the PetalType variable for cleaned_dat

cleaned_dat %>% 
    group_by(Species, PetalType)  %>% # group them by the
    print()

cleaned_dat  %>% 
    group_by(Species, PetalType)  %>% 
    summarise(SepLen_mean = mean(Sepal.Length),
              SepLen_sd = sd(Sepal.Length),
              SepWid_mean = mean(Sepal.Width),
              SepWid_sd = sd(Sepal.Length))

dat  %>% 
 mutate(SepLen_centered_overall = Sepal.Length - mean(Sepal.Length))  %>% #center values by mean for all data
 group_by(Species)  %>% 
 mutate(SepLen_centered_byspecies = Sepal.Length - mean(Sepal.Length))  %>% #center values by mean for each species
 # select(SepLen_centered_overall:SepLen_centered_byspecies) %>% # just show the relevant variables (there are a lot of variables in this data.frame now!)
 head()

dat  %>% 
 mutate(SepLen_centered_overall = Sepal.Length - mean(Sepal.Length))  %>% #center values by mean for all data
 group_by(Species)  %>% 
 mutate(SepLen_centered_byspecies = Sepal.Length - mean(Sepal.Length))  %>% 
 gather(key = centering_type, value = SepLen_centered, SepLen_centered_overall, SepLen_centered_byspecies)  %>% 
 ggplot(aes(Species, SepLen_centered, color=centering_type)) +
    stat_summary(geom='point',fun=mean) +
    theme_classic()

newdat <- iris # new duplicate of iris dataset so we don't have to deal with all the messy variables we created.
newdat$flower.num <- 1:nrow(newdat) # like a participant ID, so we can put these back where they came from using "spread."
newdat <- newdat %>%
      gather(key="flower_att",value="measurement",
      Sepal.Length, Sepal.Width, Petal.Length, Petal.Width)
head(newdat)




newdat <- newdat %>%
      spread(flower_att,measurement)
head(newdat)

personal <- data.frame(name = c("p01","p02"), age = c(18,21), firstlang = c("English", "Chinese")) # participant inforation
response <- data.frame(name= c("p01","p01","p02","p02"),response=c(0,1,1,0)) # response database
head(response)

response <- response %>% left_join(select(personal,name:age)) # don't need to use "select", but it keeps you from adding info you don't need. 
head(response)
