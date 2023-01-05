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
