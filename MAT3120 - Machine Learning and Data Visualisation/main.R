# Set Working Folder
setwd("E:/Projects/RP")

# Install dplyr

#install.packages("dplyr")
#install.packages('plyr')
#install.packages("stringr")
#install.packages("moments")
# Load Library
library(plyr)
library(dplyr)
library(stringr)
library(data.table)
library(moments)
library(outliers)
library(ggfortify)
library(factoextra)
# Load CSV
dat <- read.csv("MLData2023.csv", stringsAsFactors = TRUE)
head(dat)

# Separate samples of non-malicious and malicious events
dat.class0 <- dat %>% filter(Class == 0) # non-malicious
dat.class1 <- dat %>% filter(Class == 1) # malicious
# Randomly select 300 samples from each class, then combine them to form a working dataset
set.seed(1122)
rand.class0 <- dat.class0[sample(1:nrow(dat.class0), size = 300, replace = FALSE),]
rand.class1 <- dat.class1[sample(1:nrow(dat.class1), size = 300, replace = FALSE),]
# Your sub-sample of 600 observations
mydata <- rbind(rand.class0, rand.class1)
dim(mydata) # Check the dimension of your sub-sample


# Use the str(.) command to check that the data type for each feature is correctly specified. Address the issue if this is not the case.
# You are to clean and perform basic data analysis on the relevant features in mydata, and as well as principal component analysis (PCA) on the continuous variables. This is to be done using “R”. You will report on your findings.

# mydata$Class= as.factor(mydata$Class)

# Part 1 – Exploratory Data Analysis and Data Cleaning

# Note: The tables for subparts (i) and (ii) should be based on the original sub- sample of 600 observations, not the cleaned version.

# (i)

str(mydata)
categoryData <- cbind(mydata %>% dplyr::select(where(is.factor)), Class = mydata$Class)
continuesData <- subset(mydata %>% dplyr::select(where(is.numeric)), select = -Class)

str(categoryData)
freqList = lapply(categoryData,
                  function(x) {
                    tempList = data.frame(table(x))
                    tempList[, 2] = str_c(tempList[, 2], " (", round(tempList[, 2] / 6, 1), "%)")
                    names(tempList) = c("Category", "N (%)")
                    return(tempList)
                  }
)

categoryFreqTable <- as.data.frame(do.call(rbind, freqList))

setDT(categoryFreqTable, keep.rownames = TRUE)[]
categoryFreqTable$rn <- ifelse(str_detect(categoryFreqTable$rn, '.1'), str_replace(categoryFreqTable$rn, '.1', ''), '')

colnames(categoryFreqTable)[1] = "Categorical Feature"

categoryFreqTable

# (ii)
continuesResult = data.frame()
for (i in 1:ncol(continuesData)) {       # for-loop over columns
  output = c(names(continuesData)[i], sum(is.na(continuesData[, i])) / 6, round(min(continuesData[, i]), 2), round(max(continuesData[, i]), 2), round(mean(continuesData[, i]), 2), round(median(continuesData[, i])), round(skewness(continuesData[, i]), 2))

  # Using rbind() to append the output of one iteration to the dataframe
  continuesResult = rbind(continuesResult, output)
}

colnames(continuesResult) <- c("Continuous Feature", "Number (%) missing", "Min", "Max", "Mean", "Median", "Skewness")

continuesResult

# (iii)
# Are there any invalid categories/values for the categorical variables?
# YES

# Is there any evidence of outliers for any of the continuous/numeric variables?
# Z Score, Hypothesis Tests
for (i in 1:ncol(continuesData)) {
  cat('Find Outliers in ', names(continuesData)[i])
  cat('grubbs.test')
  print(grubbs.test(continuesData[, i]))

  cat('Mean and Standard deviation (SD)')
  # get mean and Standard deviation
  mean = mean(continuesData[, i])
  std = sd(continuesData[, i])

  # get threshold values for outliers
  Tmin = mean - (3 * std)
  Tmax = mean + (3 * std)

  # find outlier
  print(which(continuesData[, i] < Tmin | continuesData[, i] > Tmax))
  print(continuesData[, i][which(continuesData[, i] < Tmin | continuesData[, i] > Tmax)])
  print('-----------------------------------------------------------------')
  # Dixon’s Q Test
}
# The p-value is 0.056. At the 5% significance level, we do not reject the hypothesis that the highest value 44 is not an outlier.
# The p-value is 1. At the 5% significance level, we do not reject the hypothesis that the lowest value 12 is not an outlier.

# If so, how many and what percentage are there?


# Part 2 – Perform PCA and Visualise Data

# (i)

# mydata[mydata == "" |
#                mydata == ' ' |
#                mydata == '-'] <- NA

mydata <- replace(mydata, mydata == '' | mydata == ' ' | mydata == '-', NA)
mydata$Packet.TTL <- replace(mydata$Packet.TTL, mydata$Packet.TTL == 35, NA)

# (ii)
#Write to a csv file.
# write.csv(mydata,"mydata.csv")

# (iii)

pca_data = Filter(is.numeric, mydata)
# filter the incomplete cases (i.e. any rows with NAs)
pca_data <- na.omit(pca_data)
# perform PCA using prcomp(.)
pca_data.pca <- prcomp(pca_data[, -10], scale = TRUE)
summary(pca_data.pca)
# Outline why you believe the data should or should not be scaled, i.e. standardised, when performing PCA.
round(pca_data.pca$scale, 3)
# It is important to scale the data before applying PCA for the following reasons:
# PCA is sensitive to the scale of the variables. Without scaling, variables with larger scales will dominate the variance explained by the principal components, making it difficult to interpret the results.
# Scaling ensures that all variables are on the same scale, so that the variance explained by each variable is comparable. This makes it easier to interpret the principal components and identify patterns in the data.
# Scaling also ensures that the principal components are not affected by the units of measurement of the original variables. This can be especially important when working with data from different sources or in different units.
# Scaling also ensures that the principal components are not affected by the outliers in the data.

# Outline the individual and cumulative proportions of variance (3 decimal places) explained by each of the first 4 components.


# Outline how many principal components (PCs) are adequate to explain at least 50% of the variability in your data.
# PC1+PC2+PC3 23.23 + 16.11+ 12.83

# Outline the coefficients (or loadings) to 3 decimal places for PC1, PC2 and PC3, and describe which features (based on the loadings) are the key drivers for each of these three PCs.
print(round(pca_data.pca$rotation[, 1:3], 3))
# PC1 increases when DYNRiskA.Score, Server.Response.Packet.Time, and Source.IP.Concurrent.Connection are increased
# and it is positively correlated
# whereas PC1 increases Assembled.Payload.Size decrease because these values are negatively correlated.

# (iv)
biplot(pca_data.pca, cex = 0.6, main = 'PCA Results',
       col = c('blue', 'red'),
       xlab = 'First Component',
       ylab = 'Second Component',)

# The X-axis of the biplot represents the first principal component where the petal length and petal width are combined and transformed into PC1 with some parts of sepal length and sepal width. Whereas the vertical part of the sepal length and sepal width forms the second principal component.


autoplot(pca_data.pca, data = pca_data, colour = 'Class', loadings = TRUE, loadings.colour = 'blue',
         loadings.label = TRUE, loadings.label.size = 3)
# pca_data.pca.plot <- autoplot(pca_data.pca,
#                               data = pca_data,
#                               colour = 'Class')
#
# pca_data.pca.plot

# X 轴最远的两个feature 对于PC1影响最大 Y轴最远对于PC2影响最大
# When two vectors are close, forming a small angle, the two variables they represent are positively correlated.
# If they meet each other at 90°, they are not likely to be correlated.
# When they diverge and form a large angle (close to 180°), they are negative correlated.
# (v)

# 0 = Non-malicious, 1 = Malicious