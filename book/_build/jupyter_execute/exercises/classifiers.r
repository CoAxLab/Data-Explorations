# WRITE YOUR CODE HERE



vrequire(tidyverse) # Load the tidyverse package, if you haven't yet
fdata$Correct <- as.factor(fdata$Correct) # so that R knows that Correct is categorical, not numeric. 

# plot the Correct / Incorrect clusters
ggplot(fdata,aes(x=round(Log_Freq_HAL,1),y=Length,col=Correct)) + geom_point(position="jitter",alpha=0.5) + theme_light() 


# WRITE YOUR CODE HERE



# WRITE YOUR CODE HERE



# WRITE YOUR CODE HERE



# WRITE YOUR CODE HERE


