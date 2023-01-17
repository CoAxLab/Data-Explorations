6 + 2
10 - 3 * 4
5^3

a <- c(1,2,3)
b <- c(4,5,6)
print(paste("mean of vector a:",mean(a)))
print(paste("sum of vector b:",sum(b)))

a*b

c <- c("one", "two", "three")
data <- data.frame(avar = a,bvar = b,cvar = c)
data

a[2]

data[2,1]

data$bvar

print("Column 3")
data[,3]

print("Row 1")
data[1,]

data[,"cvar"]



fahrenheit_to_celsius <- function(temp_F) {
  temp_C <- (temp_F - 32) * 5 / 9
  return(temp_C)
}

# freezing point of water
fahrenheit_to_celsius(32)

# boiling point of water
fahrenheit_to_celsius(212)

input_1 <- 20
my_sum <- function(input_1, input_2 = 10) { #input_2 is given a default value of 10
  output <- input_1 + input_2
  return(output)
}

my_sum(2)

my_sum(3, 4)

my_sum(input_1 = 1, 3)

my_sum(input_2 = 3)

mean(x = 1:10)

x

mean(x <- 1:10)

x
