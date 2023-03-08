# INSERT CODE HERE


# INSERT CODE HERE


# Initialize `results` data frame
# INSERT CODE HERE

#for loop
for (i in 1:nrow(dat)){ #don't forget to change this to your data set name
    # separate individual observation `i` from the rest of your data
    # INSERT CODE HERE
    
    # train your model
    # INSERT CODE HERE
    
    # test model on hold out observation
    # INSERT CODE HERE
    
    # classify model prediction as "pos" or "neg" and add to `results`
    # INSERT CODE HERE
    
}

# INSERT CODE HERE


#?cv.glm

# INSERT CODE HERE


set.seed(1)
#INSERT CODE BELOW

# K = 3


# K = 5


# K = 10


# K = 15

