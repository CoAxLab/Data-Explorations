# a function for simulating data for two groups. Sample size is the number of people in each group
simulate_data <- function(sample_size, group1_mu, group1_sd, group2_mu, group2_sd) {
    # draw observation from a normal distribution
    obs_group1 <- rnorm(sample_size, group1_mu, group1_sd)
    obs_group2 <- rnorm(sample_size, group2_mu, group2_sd)
    return(data.frame(group1=obs_group1, group2=obs_group2))
}

set.seed(040819) # this just helps us get the same "random" result every time we run it - for demo purposes
heights = simulate_data(sample_size = 5, group1_mu = 163, group1_sd = 15, 
                        group2_mu = 135, group2_sd = 7)
print(heights)

# a function for running a t-test and extracting p-value
run_analysis <- function(data) {
    fit <- t.test(data$group1, data$group2)
    return(c(fit$estimate[1] - fit$estimate[2],fit$stderr,fit$p.value)) # this outputs the effect size, standard error, and significance for quality metrics 
}

run_analysis(heights)[3]

# a function for repeatedly running the t-test on multiple samples drawn with the same parameters
repeat_analysis <- function(n_simulations, alpha, sample_size, group1_mu, group1_sd, group2_mu, group2_sd) {
    simouts <- matrix(rep(NA,n_simulations*3),nrow=n_simulations,ncol=3) # empty vector to store ests, stderr, p-values from each simulation
    
    # loop for repeating the simulation
    for (i in 1:n_simulations) {
        data <- simulate_data(sample_size, group1_mu, group1_sd, group2_mu, group2_sd) # simulate the data using the defined function
        simouts[i,] <- run_analysis(data) # run the analysis, and add outputs to the matrix
    }
    
    # calculate coverage (AKA power)
    cvg <- mean(simouts[,3] <= alpha) # this is the same as the number of sims that successfully rejected null divided by total number of sims - probability of correctly rejecting the null!
    # calculate relative parameter estimate bias
    theta_bias <- ( mean(simouts[,1]) - (group1_mu-group2_mu) ) / (group1_mu-group2_mu)
    # calculate relative standard error bias 
    sigma_bias <- (mean(simouts[,2]) - sd(simouts[,1])) / sd(simouts[,1])

    return(list(cvg = cvg, theta_bias=theta_bias, sigma_bias=sigma_bias, p.values=simouts[,3])) #return a list with the power as the probability of a sig. result and the corresponding p-values
}


set.seed(040819)
results = repeat_analysis(n_simulations = 1000, alpha = 0.05, sample_size = 5,
                          group1_mu=163, group1_sd = 15, group2_mu = 135, group2_sd = 7)
results[1:3]

set.seed(040819)
results = repeat_analysis(n_simulations = 1000, alpha = 0.05, sample_size = 10,
                          group1_mu=163, group1_sd = 15, group2_mu = 135, group2_sd = 7)
results[1:3]

set.seed(18546)
results = repeat_analysis(n_simulations = 1000, alpha = 0.001, sample_size = 10,
                          group1_mu=163, group1_sd = 15, group2_mu = 135, group2_sd = 7)
results[1:3]

require(tidyverse)
options(repr.plot.width=9, repr.plot.height=5)

results_n5 = repeat_analysis(1000, 0.05, 5, 163, 15, 135, 7)
results_n10 = repeat_analysis(1000, 0.05, 10, 163, 15, 135, 7)


power_df = data.frame(cbind(n5 = results_n5$p.values, n10 = results_n10$p.values)) %>% 
            gather('n_samples', c('n5', 'n10'), value = 'p.values')


ggplot(power_df, aes(x=p.values)) + geom_histogram() + facet_grid(.~n_samples)

# first, create a data.frame to store the results
dat <- expand.grid(sample_size = 2:20, alpha = c(0.05,0.01,0.001)) #vary the criterion for sig. and the sample size
dat$id <- 1:nrow(dat) #identify each combination of parameters as a separate parameter case for below (otherwise, "unnesting" will be impossible)

# then use tidyverse functions to run the analysis for each sample size
results <- dat  %>%  #using the dataframe defined above
    nest(parameters :=  c(sample_size,alpha)) %>% # separate the parameters into lists split by parameter combo case and call the new column of lists 'parameters' 
    mutate(power = map(parameters, ~ repeat_analysis(1000, .$alpha, .$sample_size, 163, 15, 135, 7)$cvg))  %>%  # note: "map" is like running a for loop, but more efficiently
    #for each case within parameters, repeat the analysis, varying the alpha and sample size
    #store the power associated with all cases as a new variable called power 
    unnest(c(parameters, power)) #return the dataframe to an unnested state, making each element of the list its own row

head(results) #now for each combination of sample size and alpha we have a power estimate, neatly arranged 

options(repr.plot.width=8) # resetting size of plot
ggplot(results, aes(sample_size, power, color=as.factor(alpha), group=alpha)) +
    geom_point() +
    geom_line() +
    geom_hline(yintercept = 0.8) + # Drew lines at these values because they are
    geom_hline(yintercept = 0.95) + # both traditionally used power thresholds
    scale_color_discrete('Alpha level') +
    scale_x_continuous('Sample size') +
    theme_classic() # this just makes it pretty

install.packages("lme4")
library(lme4) # we need lme4 so we can do test-runs of mixed effects analyses. 
require(tidyverse) # in case tidyverse needs to be re-loaded

# a function for simulating data for mixed-model.
simulate_data <- function(n_subjects, n_trials, intercept, 
                          slope, intercept_sd, slope_sd, trial_sd) {
    # draw observation from a normal distribution
    subject_intercepts <- rnorm(n_subjects, intercept, intercept_sd) # sample from a distribution centered at mean subject RT, varying with sd of subject RT
    subject_slopes <- rnorm(n_subjects, slope, slope_sd) # sample from distribution centered at mean effect size, varying with sd of effect size
    dat <- data.frame(subject = 1:n_subjects, intercept = subject_intercepts, slope=subject_slopes)
    # generate trials for each subject
    dat <- dat  %>% 
        nest(., parameters :=  c(intercept, slope))  %>% # for each subject
        # sample n_trials values for two new vars using "intercept" and "slope" values calculated above, adding trial variability using trial_sd
        # congruent just uses intercept for mean (the baseline condition, faster RT), 
        # incongruent uses intercept+slope to account for effect of being slower condition
        mutate(congruent = map(parameters, ~rnorm(n_trials, intercept, trial_sd)),
               incongruent = map(parameters, ~rnorm(n_trials, intercept+slope, trial_sd)))  %>%  # 
        unnest(c(congruent,incongruent), .drop = FALSE)  %>%
        unnest(parameters)  %>% # ungroup the data so it's a normal data frame again
        gather(prime, rt, congruent, incongruent) # puts it in long form - tidy data! 
    return(dat)
}


# a function for running a mixed-model and extracting coverage, theta_bias, sigma_bias, and p-values. 
run_analysis <- function(data) {
    # fit null and alternative model
    m0 <- lmer(rt ~ 1 + (prime||subject), data=data, REML=FALSE, control=lmerControl(calc.derivs = FALSE)) # null model
    m1 <- lmer(rt ~ prime + (prime||subject), data=data, REML=FALSE, control=lmerControl(calc.derivs = FALSE)) # alternative model

    est <- fixef(m1)[2] # estimate of Incongruent - Congruent difference in RT 
    se <- summary(m1)$coef[, 2, drop = FALSE][2] # stderr of estimate
    m_bic <- BIC(m0, m1)$BIC#Outputs Bayesian Information Criterion to assess goodness of model fit
    statistic <- diff(m_bic)#You can replace with change in AIC or a p-value for a likelihood ratio statistic
    return(c(est,se,statistic))
}

set.seed(04082020)
dat <- simulate_data(10, 10, 700, 50, 100,50,200)
head(dat, n=20)

run_analysis(dat)

# a function for repeatedly running the analysis on multiple samples drawn with the same parameters
repeat_analysis <- function(n_simulations, alpha, n_subjects, n_trials, intercept, slope, intercept_sd, slope_sd, trial_sd) {
    simouts <- matrix(rep(NA,3*n_simulations),nrow=n_simulations) # empty vector to store outputs from each simulation
    # loop for repeating the simulation
    for (i in 1:n_simulations) {
        data <- simulate_data(n_subjects, n_trials, intercept,
                              slope, intercept_sd, slope_sd, trial_sd)
        simouts[i,] <- run_analysis(data) # save the analysis outputs for this sim.
    }
    
    # calculate how many of the simulations had significant results (coverage)
    power <- mean(simouts[,3] <= -20) # -20 is a good standard threshold for strong evidence, see Raftery & Kass 1995
    # calculate relative parameter estimate bias
    theta_bias <- ( mean(simouts[,1]) - slope ) / (slope)
    # calculate relative standard error bias 
    sigma_bias <- (mean(simouts[,2]) - sd(simouts[,1])) / sd(simouts[,1])
    return(list(power = power, theta_bias = theta_bias, sigma_bias = sigma_bias))
}

dat <- expand.grid(n_subjects = c(20,30,40), n_trials = c(20,40,60))
dat$id <- 1:nrow(dat)
# then use tidyverse functions to run the analysis for each sample size (takes ~30-60 minutes)
results <- dat  %>% 
    nest(parameters :=  c(n_subjects, n_trials)) %>%
    # nest(-id, .key = 'parameters')  %>% 
    mutate(power = map(parameters, ~ repeat_analysis(1000, 0.05, .$n_subjects, .$n_trials, 700, 50, 100,50,200)$power),
    theta_bias = map(parameters, ~ repeat_analysis(1000, 0.05, .$n_subjects, .$n_trials, 700, 50, 100,50,200)$theta_bias),
    sigma_bias = map(parameters, ~ repeat_analysis(1000, 0.05, .$n_subjects, .$n_trials, 700, 50, 100,50,200)$sigma_bias))  %>% 
    unnest(c(parameters, power, theta_bias, sigma_bias))

results

options(repr.plot.width=10, repr.plot.height=8)
ggplot(results, aes(n_subjects, power, color=as.factor(n_trials), group=n_trials)) +
    geom_point() +
    geom_line() +
    geom_hline(yintercept = 0.8) + # again, thresholds for acceptable power
    geom_hline(yintercept = 0.95) +
    scale_color_discrete('Number of trials per subject') +
    scale_x_continuous('Number of subjects') +
    scale_y_continuous('Statistical power (for Delta BIC <= -20)') +
    theme_classic()


ggplot(results, aes(n_subjects, sigma_bias, color=as.factor(n_trials), group=n_trials)) +
    geom_point() +
    geom_line() +
    scale_color_discrete('Number of trials per subject') +
    scale_x_continuous('Number of subjects') +
    scale_y_continuous('Sigma Bias') +
    theme_classic()

ggplot(results, aes(n_subjects, theta_bias, color=as.factor(n_trials), group=n_trials)) +
    geom_point() +
    geom_line() +
    scale_color_discrete('Number of trials per subject') +
    scale_x_continuous('Number of subjects') +
    scale_y_continuous('Theta Bias') +
    theme_classic()
