# Set Working Folder
setwd("E:/Projects/UniversityResource/MAT3120 Machine Learning and Data Visualisation/Assignment2")
#install.packages("caret", dependencies = c("Depends", "Suggests"))
library(doFuture)
library(forcats)
library(caret)
library(ggplot2)
library(lattice)
library(glmnet)

# Boost Performance
registerDoFuture()
plan(multisession, workers = availableCores() - 1)

# Load CSV
MLData2023 <- read.csv("MLData2023.csv", stringsAsFactors = TRUE)
head(MLData2023)

# remove the records with invlid values
MLData2023 <- subset(MLData2023, Assembled.Payload.Size != -1)
MLData2023 <- subset(MLData2023, Operating.System != "-")

MLData2023$IPV6.Traffic <- ifelse(is.na(MLData2023$IPV6.Traffic), "Unknown", MLData2023$IPV6.Traffic)
MLData2023$IPV6.Traffic <- ifelse(MLData2023$IPV6.Traffic == "-", "Unknown", MLData2023$IPV6.Traffic)

MLData2023 <- MLData2023[MLData2023$Class %in% c(0, 1),]

# Merge all windows operating system to windows All
MLData2023$Operating.System <- fct_collapse(MLData2023$Operating.System, "Windows All" = c("Windows (Unknown)", "Windows 10+", "Windows 7"), "Others" = c("Android", "iOS", "Linux (unknown)", "Other"))
MLData2023$Connection.State <- fct_collapse(MLData2023$Connection.State, "Others" = c("INVALID", "NEW", "RELATED"))

# Const Factor
# MLData2023$Class <- factor(MLData2023$Class)

# Remove records with missing values
MLData2023_cleaned <- na.omit(MLData2023)

# remove duplicate records
MLData2023_cleaned <- MLData2023_cleaned[!duplicated(MLData2023_cleaned),]

# Double Check Non Value
print(colSums(is.na(MLData2023_cleaned)))

# MLData2023_cleaned <- MLData2023_cleaned[1:500,]

# Convert Class to factor
# MLData2023_cleaned$Class <- factor(MLData2023_cleaned$Class)

# Double Check every column
column_types <- sapply(MLData2023_cleaned, class)
print(column_types)

# Set seed for reproducibility
set.seed(123)

# Split train and evaluate set 80% Training
train_indices <- createDataPartition(MLData2023_cleaned$Class, p = 0.8, list = FALSE)

# Split the data into train and evaluate set
train_data <- MLData2023_cleaned[train_indices,]
evaluate_data <- MLData2023_cleaned[-train_indices,]

train_data$Class <- factor(train_data$Class)
evaluate_data$Class <- factor(evaluate_data$Class)

# 10 Fold CV
trainControl <- trainControl(method = "repeatedcv",
                             number = 10,
                             repeats = 5,
                             verboseIter = TRUE)

lambda_values <- seq(-3, 3, length.out = 100)

# Model training for Unbalanced data
model_unbalanced <- train(Class ~ .,
               data = train_data,
               method = "glmnet",
               trControl = trainControl,
               verbose = TRUE,
               tuneGrid = expand.grid(alpha = 0, lambda = lambda_values))

# best_lambda for Unbalanced data
best_lambda_unbalanced <- model_unbalanced$bestTune$lambda
print(paste("Best lambda for Unbalanced data:", best_lambda_unbalanced))

# Model training for Balanced data
model_balanced <- train(Class ~ .,
               data = train_data,
               method = "glmnet",
               trControl = trainControl,
               verbose = TRUE,
               tuneGrid = expand.grid(alpha = 0, lambda = lambda_values),
               weights = ifelse(train_data$Class == 1, sum(train_data$Class == 0) / sum(train_data$Class == 1), 1))

# Evaluate model performance on evaluate_data for Unbalanced data
predictions_unbalanced <- predict(model_unbalanced, newdata = evaluate_data)
confusion_matrix_unbalanced <- confusionMatrix(predictions_unbalanced, evaluate_data$Class)
performance_unbalanced <- confusion_matrix_unbalanced$byClass

# Evaluate model performance on evaluate_data for Balanced data
predictions_balanced <- predict(model_balanced, newdata = evaluate_data)
confusion_matrix_balanced <- confusionMatrix(predictions_balanced, evaluate_data$Class)
performance_balanced <- confusion_matrix_balanced$byClass

print(performance_unbalanced)
print(performance_balanced)

# false_positive_rate <- $specificity
# false_negative_rate <- $sensitivity
# accuracy_balanced <- $overall[1]
# precision_balanced <- $precision
# recall_balanced <- $recall
# f_score_balanced <- $F1

# Hyperparemeters
nbagg_values <- c(10, 50, 100)
cp_values <- c(0.01, 0.05, 0.1)
minsplit_values <- c(2, 5, 10)

# Initialisation
best_accuracy_unbalanced <- 0
best_nbagg_unbalanced <- NULL
best_cp_unbalanced <- NULL
best_minsplit_unbalanced <- NULL
best_model_unbalanced <- NULL

best_accuracy_balanced <- 0
best_nbagg_balanced <- NULL
best_cp_balanced <- NULL
best_minsplit_balanced <- NULL
best_model_balanced <- NULL

# Loop
for (nbagg in nbagg_values) {
  for (cp in cp_values) {
    for (minsplit in minsplit_values) {
      # Bagging Tree for Unbalanced data
      model_unbalanced <- train(Class ~ .,
                                data = train_data,
                                method = "treebag",
                                nbagg = nbagg,
                                cp = cp,
                                minsplit = minsplit,
                                trControl = trainControl,
                                metric = "Accuracy",
                                verbose = TRUE)

      accuracy_unbalanced <- model_unbalanced$results$Accuracy[1]

      if (accuracy_unbalanced > best_accuracy_unbalanced) {
        best_accuracy_unbalanced <- accuracy_unbalanced
        best_nbagg_unbalanced <- nbagg
        best_cp_unbalanced <- cp
        best_minsplit_unbalanced <- minsplit
        best_model_unbalanced <- model_unbalanced
      }

      # Bagging Tree for Balanced data
      model_balanced <- train(Class ~ .,
                              data = train_data,
                              method = "treebag",
                              nbagg = nbagg,
                              cp = cp,
                              minsplit = minsplit,
                              trControl = trainControl,
                              metric = "Accuracy",
                              verbose = TRUE,
                              weights = ifelse(train_data$Class == 1, sum(train_data$Class == 0) / sum(train_data$Class == 1), 1))

      accuracy_balanced <- model_balanced$results$Accuracy[1]

      if (accuracy_balanced > best_accuracy_balanced) {
        best_accuracy_balanced <- accuracy_balanced
        best_nbagg_balanced <- nbagg
        best_cp_balanced <- cp
        best_minsplit_balanced <- minsplit
        best_model_balanced <- model_balanced
      }
    }
  }
}

print(paste("Best nbagg for Unbalanced data:", best_nbagg_unbalanced))
print(paste("Best cp for Unbalanced data:", best_cp_unbalanced))
print(paste("Best minsplit for Unbalanced data:", best_minsplit_unbalanced))
print(paste("Best accuracy for Unbalanced data:", best_accuracy_unbalanced))

print(paste("Best nbagg for Balanced data:", best_nbagg_balanced))
print(paste("Best cp for Balanced data:", best_cp_balanced))
print(paste("Best minsplit for Balanced data:", best_minsplit_balanced))
print(paste("Best accuracy for Balanced data:", best_accuracy_balanced))

print(best_model_unbalanced)
print(best_model_balanced)

# Evaluate model performance on evaluate_data for Unbalanced data
predictions_unbalanced <- predict(best_model_unbalanced, newdata = evaluate_data)
confusion_matrix_unbalanced <- confusionMatrix(predictions_unbalanced, evaluate_data$Class)
performance_unbalanced <- confusion_matrix_unbalanced$byClass

print(performance_unbalanced)

# Evaluate model performance on evaluate_data for Balanced data
predictions_balanced <- predict(best_model_balanced, newdata = evaluate_data)
confusion_matrix_balanced <- confusionMatrix(predictions_balanced, evaluate_data$Class)
performance_balanced <- confusion_matrix_balanced$byClass

print(performance_balanced)