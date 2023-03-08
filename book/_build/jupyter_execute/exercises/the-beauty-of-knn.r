# INSERT CODE HERE


# INSERT CODE HERE


set.seed(2023)

# INSERT CODE HERE



set.seed(2023)
# INSERT CODE HERE


# INSERT CODE HERE


set.seed(2023)
# INSERT CODE HERE


# this is provided
# setting up empty table to store for loop output
output  <- data.frame(k = seq(1:30),
                     error = rep(NA, 30))
head(output)

for (k in seq(1:30)) {
    knn_fits  <- # your knn function here
    
    #overall error
    conf_df  <- # data frame of test predictions versus actual test
    output$error[k]  <- #calculate error from conf_df and add to your output dataframe
   
}
head(output)

# INSERT CODE HERE

set.seed(2023)
#INSERT CODE HERE

