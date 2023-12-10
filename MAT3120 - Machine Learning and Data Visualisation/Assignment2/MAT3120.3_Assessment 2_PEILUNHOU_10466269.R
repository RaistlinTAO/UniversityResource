library(glmnet)
library(tidyverse)  #For ggplot2 and dplyr
library(caret)  #Classification and Regression Training package
library(forcats)
library(dplyr)
library(ipred)
library(rpart)  #For CART modelling

# Data preperation and clean

# load the dataset
MLData2023 <- read.csv("D:/MLData2023.csv")

# remove the records with invlid values
MLData2023 <- subset(MLData2023, Assembled.Payload.Size != -1)
MLData2023 <- subset(MLData2023, Operating.System != "-")

MLData2023$IPV6.Traffic <- ifelse(is.na(MLData2023$IPV6.Traffic), "Unknown", MLData2023$IPV6.Traffic)
MLData2023$IPV6.Traffic <- ifelse(MLData2023$IPV6.Traffic %in% c(" ", "-"), "Unknown", MLData2023$IPV6.Traffic)

# Filter the data to only include cases labelled with Class = 0 or 1
MLData2023 <- MLData2023[MLData2023$Class %in% c(0, 1), ]

# Merge all Windows operating system to Windows_All
MLData2023$Operating.System <- fct_collapse(MLData2023$Operating.System,
                                            "Windows_All" = c("Windows (Unknown)", "Windows 10+", "Windows 7"),
                                            "Others" = c("Android","iOS", "Linux (unknown)", "Other"))
# Merge all other OS to Others
MLData2023$Connection.State <- fct_collapse(MLData2023$Connection.State,
                                            "Others" = c("INVALID", "NEW", "RELATED"))

# remove records with missing values
MLData2023_cleaned <- na.omit(MLData2023)

# remove duplicate records
MLData2023_cleaned <- MLData2023_cleaned[!duplicated(MLData2023_cleaned),]



# Separate samples of non-malicious and malicious events
dat.class0 <- MLData2023_cleaned %>% filter(Class == 0) # non-malicious
dat.class1 <- MLData2023_cleaned %>% filter(Class == 1) # malicious
# Randomly select 19800 non-malicious and 200 malicious samples, then combine them to form the training samples
set.seed(10466269)
rows.train0 <- sample(1:nrow(dat.class0), size = 19800, replace = FALSE)
rows.train1 <- sample(1:nrow(dat.class1), size = 200, replace = FALSE)
# COmbine them teogther as an unbalanced training samples
train.class0 <- dat.class0[rows.train0,] # Non-malicious samples
train.class1 <- dat.class1[rows.train1,] # Malicious samples
mydata.ub.train <- rbind(train.class0, train.class1)
mydata.ub.train <- mydata.ub.train %>%
  mutate(Class = factor(Class, labels = c("NonMal","Mal")))

# Generate a balanced training samples, i.e. 19800 non-malicious and malicious samples each.
set.seed(123)
train.class1_2 <- train.class1[sample(1:nrow(train.class1), size = 19800, 
                                      replace = TRUE),]
mydata.b.train <- rbind(train.class0, train.class1_2)
mydata.b.train <- mydata.b.train %>%
  mutate(Class = factor(Class, labels = c("NonMal","Mal")))

# Create testing samples
test.class0 <- dat.class0[-rows.train0,]
test.class1 <- dat.class1[-rows.train1,]
mydata.test <- rbind(test.class0, test.class1)
mydata.test <- mydata.test %>%
  mutate(Class = factor(Class, labels = c("NonMal","Mal")))

write.csv(mydata.ub.train,"D:/unbalance_train.csv")
write.csv(mydata.b.train,"D:/balance_train.csv")
write.csv(mydata.test,"D:/test.csv")

#  Randomly select two supervised learning modelling algorithms
set.seed(10466269)
models.list1 <- c("Logistic Ridge Regression",
                  "Logistic LASSO Regression",
                  "Logistic Elastic-Net Regression")
models.list2 <- c("Classification Tree",
                  "Bagging Tree",
                  "Random Forest")
myModels <- c(sample(models.list1, size = 1),
              sample(models.list2, size = 1))
myModels %>% data.frame
# As a result,  Logistic Ridge Regression and Bagging Tree is selected




# Define the grid of hyperparameters to search over
lambdas <- 10^seq(-3,3,length=100) #A sequence 100 lambda values

set.seed(1)
Models.ub.ridge <- train(Class ~., #Formula
                         data = mydata.ub.train, #Training data
                         method = "glmnet",  #Penalised regression modelling
                         #Set to c("center", "scale") to standardise data
                         preProcess = NULL,
                         #Perform 10-fold CV, 5 times over.
                         trControl = trainControl("repeatedcv",
                                                  number = 10,
                                                  repeats = 5),
                         tuneGrid = expand.grid(alpha = 0, #Ridge regression
                                                lambda = lambdas)
)

#Optimal lambda value
Models.ub.ridge$bestTune

# Model coefficients
coef(Models.ub.ridge$finalModel, Models.ub.ridge$bestTune$lambda)

#predicted probability of class on the test data
pred.ub.ridge <- predict(Models.ub.ridge,new=mydata.test) 

#Confusion matrix with re-ordering of "Mal" and "NoMal" responses
cf.ub.ridge <- table(pred.ub.ridge %>% as.factor %>% relevel(ref="Mal"), 
                  mydata.test$Class %>% as.factor %>% relevel(ref="Mal"));  

prop <- prop.table(cf.ub.ridge,2); prop %>% round(digit=3) #Proportions by columns

#Summary of confusion matrix
#confusionMatrix(cf.ub.ridge)

indicators <- c("False Positive","False Negative", "Overall Accuracy", "Precision", "Recall", "F-score")
performance <- NA
# calculate False positive rate
performance[1] <- cf.ub.ridge[1, 2] / sum(cf.ub.ridge[1, ])
# calculate False negative rate
performance[2] <- cf.ub.ridge[2, 1] / sum(cf.ub.ridge[2, ])
# calculate Overall Accuracy
performance[3] <- sum(diag(cf.ub.ridge)) / sum(cf.ub.ridge)
# calculate Precision
performance[4] <- cf.ub.ridge[2, 2] / sum(cf.ub.ridge[, 2])
# calculate Recall 
performance[5] <- cf.ub.ridge[2, 2] / sum(cf.ub.ridge[2, ])
# calculate F-score
performance[6] <- 2 * (performance.ub.ridge.precision * performance.ub.ridge.recall) / (performance.ub.ridge.precision + performance.ub.ridge.recall)

data.frame(indicator=indicators,score=performance)


Models.b.ridge <- train(Class ~., #Formula
                         data = mydata.b.train, #Training data
                         method = "glmnet",  #Penalised regression modelling
                         #Set to c("center", "scale") to standardise data
                         preProcess = NULL,
                         #Perform 10-fold CV, 5 times over.
                         trControl = trainControl("repeatedcv",
                                                  number = 10,
                                                  repeats = 5),
                         tuneGrid = expand.grid(alpha = 0, #Ridge regression
                                                lambda = lambdas)
)

#Optimal lambda value
Models.b.ridge$bestTune

# Model coefficients
coef(Models.b.ridge$finalModel, Models.b.ridge$bestTune$lambda)

#predicted probability of class on the test data
pred.b.ridge <- predict(Models.b.ridge,new=mydata.test) 

#Confusion matrix with re-ordering of "Mal" and "NoMal" responses
cf.b.ridge <- table(pred.b.ridge %>% as.factor %>% relevel(ref="Mal"), 
                     mydata.test$Class %>% as.factor %>% relevel(ref="Mal"));  

prop <- prop.table(cf.b.ridge,2); prop %>% round(digit=3) #Proportions by columns

#Summary of confusion matrix
#confusionMatrix(cf.ub.ridge)

# calculate False positive rate
performance[1] <- cf.b.ridge[1, 2] / sum(cf.b.ridge[1, ])
# calculate False negative rate
performance[2] <- cf.b.ridge[2, 1] / sum(cf.b.ridge[2, ])
# calculate Overall Accuracy
performance[3] <- sum(diag(cf.b.ridge)) / sum(cf.b.ridge)
# calculate Precision
performance[4] <- cf.b.ridge[2, 2] / sum(cf.b.ridge[, 2])
# calculate Recall 
performance[5] <- cf.b.ridge[2, 2] / sum(cf.b.ridge[2, ])
# calculate F-score
performance[6] <- 2 * (performance.b.ridge.precision * performance.b.ridge.recall) / (performance.b.ridge.precision + performance.b.ridge.recall)


data.frame(indicator=indicators,score=performance)


set.seed(123)  # Set seed for reproducibility



# Define the hyperparameter grid
grid <- expand.grid(nbagg = c(10, 50,100), cp = c(0.01, 0.05, 0.1), minsplit = c(2, 5,10),
                    OOB.rmse=NA,  #Initialise the column to later store the OOB RMSE
                    test.accuracy=NA,
                    test.rmse=NA)


for (I in 1:nrow(grid))
{
  set.seed(123)
  #Bagging using the hyperparameter valued defined by Row I of the search grid
  bagged.tree <- bagging(Class~.,mydata.ub.train,
                         nbagg=grid$nbagg[I],  
                         coob=TRUE,
                         control=rpart.control(cp=grid$cp[I],
                                               minsplit=grid$minsplit[I]));
  #Store the OOB RMSE
  grid$OOB.rmse[I] <- bagged.tree$err
  
  #Store the test RMSE
  pred <- predict(bagged.tree,newdata=mydata.test); 

}

grid <- grid[order(grid$OOB.rmse,decreasing=FALSE)[1:10],] 

grid
bagged.final<- bagging(Class~.,mydata.ub.train,
                       nbagg=grid$nbagg[1],  
                       coob=TRUE,
                       control=rpart.control(cp=grid$cp[1],
                                             minsplit=grid$minsplit[1]));

pred.final <- predict(bagged.final,newdata=mydata.test); 


cf.ub.bagged <- table(pred.final %>% as.factor %>% relevel(ref="Mal"), 
                     mydata.test$Class %>% as.factor %>% relevel(ref="Mal"));  

prop <- prop.table(cf.ub.bagged,2); prop %>% round(digit=3) #Proportions by columns

#Summary of confusion matrix
confusionMatrix(cf.ub.bagged)

# calculate False positive rate
performance[1] <- cf.ub.bagged[1, 2] / sum(cf.ub.bagged[1, ])
# calculate False negative rate
performance[2] <- cf.ub.bagged[2, 1] / sum(cf.ub.bagged[2, ])
# calculate Overall Accuracy
performance[3] <- sum(diag(cf.ub.bagged)) / sum(cf.ub.bagged)
# calculate Precision
performance[4] <- cf.ub.bagged[2, 2] / sum(cf.ub.bagged[, 2])
# calculate Recall 
performance[5] <- cf.ub.bagged[2, 2] / sum(cf.ub.bagged[2, ])
# calculate F-score
performance[6] <- 2 * (performance.ub.bagged.precision * performance.ub.bagged.recall) / (performance.ub.bagged.precision + performance.ub.bagged.recall)

data.frame(indicator=indicators,score=performance)

# Define the hyperparameter grid
grid <- expand.grid(nbagg = c(10, 50,100), cp = c(0.01, 0.05, 0.1), minsplit = c(2, 5,10),
                    OOB.rmse=NA,  #Initialise the column to later store the OOB RMSE
                    test.accuracy=NA,
                    test.rmse=NA)

for (I in 1:nrow(grid))
{
  set.seed(123)
  #Bagging using the hyperparameter valued defined by Row I of the search grid
  bagged.tree <- bagging(Class~.,mydata.b.train,
                         nbagg=grid$nbagg[I],  
                         coob=TRUE,
                         control=rpart.control(cp=grid$cp[I],
                                               minsplit=grid$minsplit[I]));
  #Store the OOB RMSE
  grid$OOB.rmse[I] <- bagged.tree$err
  
  #Store the test RMSE
  pred <- predict(bagged.tree,newdata=mydata.test); 

}

grid <- grid[order(grid$OOB.rmse,decreasing=FALSE)[1:10],] 

grid

bagged.final<- bagging(Class~.,mydata.b.train,
                       nbagg=grid$nbagg[1],  
                       coob=TRUE,
                       control=rpart.control(cp=grid$cp[1],
                                             minsplit=grid$minsplit[1]));

pred.final <- predict(bagged.final,newdata=mydata.test); 


cf.b.bagged <- table(pred.final %>% as.factor %>% relevel(ref="Mal"), 
                      mydata.test$Class %>% as.factor %>% relevel(ref="Mal"));  

prop <- prop.table(cf.b.bagged,2); prop %>% round(digit=3) #Proportions by columns

#Summary of confusion matrix
confusionMatrix(cf.b.bagged)

# calculate False positive rate
performance[1] <- cf.b.bagged[1, 2] / sum(cf.b.bagged[1, ])
# calculate False negative rate
performance[2] <- cf.b.bagged[2, 1] / sum(cf.b.bagged[2, ])
# calculate Overall Accuracy
performance[3] <- sum(diag(cf.b.bagged)) / sum(cf.b.bagged)
# calculate Precision
performance[4] <- cf.b.bagged[2, 2] / sum(cf.b.bagged[, 2])
# calculate Recall 
performance[5] <- cf.b.bagged[2, 2] / sum(cf.b.bagged[2, ])
# calculate F-score
performance[6] <- 2 * (performance.b.bagged.precision * performance.b.bagged.recall) / (performance.b.bagged.precision + performance.b.bagged.recall)

data.frame(indicator=indicators,score=performance)
