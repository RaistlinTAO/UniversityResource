################################# 
# You can use this template to draft the script for your Assessment 2 of SIT718.
# More clarification and related resources can be found at
# https://d2l.deakin.edu.au/d2l/le/content/1422222/viewContent/7266544/View
#################################

#############################################################################################
# save your code as "name-code.R" (where ''name'' is replaced with your surname or first name).
#############################################################################################

##################################
#Question 1 - Understand the Data
##################################

data.raw <- as.matrix(read.table("RedWine.txt"))

set.seed(ID) # using your student ID number for reproducible sampling with the seed function

data.subset <- data.raw[sample(1:1599, 500), c(1:6)]

data.variable.names <- c("citric acid", "chlorides", "total sulfur dioxide", "pH", "alcohol")


# Create 5 scatterplots function (for each X variable against the variable of interest Y) 



# Create 6 histograms for each X variable and Y



################################
#Question 2 - Transform the Data
################################


I <- c("define your variable index") # Choose any four X variables and Y

variables_for_transform <- data.subset[,I]  # obtain a 400 by 5 matrix

# for each variable, you need to figure out a good data transformation method, 
# such as Polynomial, log and negation transformation. The k-S test and Skewness 
# calculation may be helpful to select the transformation method

 

p=0.5 # for example, using p=0.5 to transform the first variable. You should change p based on your distribution.
data.transformed[,1]=variables_for_transform[,1]^p 

# A Min-Max and/or Z-score transformation should then be used to adjust the scale of each variable

# min-max normalisation
minmax <- function(x){
  (x - min(x))/(max(x)-min(x))
}

# z-score standardisation and scaling to unit interval
unit.z <- function(x){
  0.15*((x-mean(x))/sd(x)) + 0.5
}

data.transformed[,1]=minmax(data.transformed[,1]) # for example,using min-max normalisation for the first varible.


# Save this transformed data to a text file
write.table(data.transformed, "name-transformed.txt")  # replace ??name?? with either your surname or first name.


##########################################
#Question 3 - Build models and investigate
##########################################

source("AggWaFit718.R")

data.transformed_copy <- as.matrix(read.table("name-transformed.txt"))  # import your saved data

# Get weights for Weighted Arithmetic Mean with fit.QAM() 


# Get weights for Power Mean p=0.5 with fit.QAM()


# Get weights for Power Mean p=2 with fit.QAM()


# Get weights for Ordered Weighted Average with fit.OWA()




#######################################
#Question 4 - Use Model for Prediction
#######################################

new_input <- c(0.9, 0.65, 38, 2.53, 7.1) 

new_input_for_transform <- new_input[c("index")] # choose the same four X variables as in Q2 



# transforming the four variables in the same way as in question 2 



# applying the transformed variables to the best model selected from Q3 for Y prediction



# Reverse the transformation to convert back the predicted Y to the original scale and then round it to integer


 

#############################################################################################
# References 
# Following Harvard style: https://www.deakin.edu.au/students/studying/study-support/referencing/harvard
#############################################################################################

# You must cite all the datasets and packages you used for this assessment. 
#
#