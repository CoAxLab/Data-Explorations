data_point <- 3 #this is one element 
print(data_point)

vector_1 = c(data_point, data_point + 2)
vector_2 = c(data_point+4, data_point + 6)

print(vector_1) 
print(vector_2)

data <- seq(1:10) 
nrow = 2
ncol = 5

##First look at the matrix function by typing ?matrix
sample_matrix_by_col <- matrix(data, nrow, ncol, byrow = 0) #fill matrix by column, not by rows
sample_matrix_by_row <- matrix(data, nrow, ncol, byrow = 1)

#note the difference in the structure of the matrix when it's filled by row vs. by column 
head(sample_matrix_by_col)
head(sample_matrix_by_row)

square_matrix_4 <- matrix(1:16, nrow = 4)
square_matrix_4

square_matrix_10 <- matrix(1:100, nrow=10)
square_matrix_10

######CHECK
symmetric_matrix <- matrix(1:16,nrow = 4)

lower.tri(symmetric_matrix)

lower_tri <- lower.tri(symmetric_matrix)
symmetric_matrix[lower_tri] <- t(symmetric_matrix)[lower_tri] #replace lower triangular portion with lower triangular portion of transpose 

symmetric_matrix #an example of a symmetric matrix

t(symmetric_matrix) == symmetric_matrix #a transposed symmetric matrix is equal to the original matrix 

mat <- matrix(0, 5, 5)
diag(mat) <- 1
mat

sample_matrix_by_col[1, 5] #this accesses the element in the first row and fifth column of the matrix (note that R uses one-based indexing)
sample_matrix_by_col[ ,2] #accessing all rows of column 6
sample_matrix_by_col[1, ] #accessing all columns of row 1
sample_matrix_by_col[,1:3] #getting all rows of columns 1-3

mat_1 <- matrix(1:6, nrow = 2) #initialize two matrices to manipulate
mat_2 <- matrix(7:12, nrow = 2)

print(mat_1)

print(mat_2)

#addition 
print(mat_1 + mat_2) #each element is added to the next in-place 

print(mat_1 + 3) #each element increases by 3

#subtraction
print(mat_2 - mat_1) #each element is subtracted from the next in-place 

print(mat_2 - 3)

print(mat_2)

#transposition 
transposed_mat_2 <- t(mat_2) 
print(transposed_mat_2)

print(t(transposed_mat_2))

print(mat_1 * 3)

#element-wise multiplication
print(mat_1*mat_2)

#matrix multiplication 
print(mat_1 %*% t(mat_2))

#division 
print(mat_1 / mat_2)

print(mat_1 / 2)

#taking the inverse 
print(solve(mat_2[, 2:3]))
print(mat_2[, 2:3] %*% solve(mat_2[, 2:3]))
