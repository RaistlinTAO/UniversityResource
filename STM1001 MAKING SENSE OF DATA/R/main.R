if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("edgeR")
library(edgeR)
library(factoextra)

# Question 1
## 1.1 Bonferroni correction and FDR correction
α <- 0.05
p_set <- c(0.0292, 0.0069, 0.7924, 0.0305, 0.5276, 0.5424, 0.8708, 0.0264, 0.0104, 0.0518, 0.0048, 0.0002)
p_set_bonferroni <- p.adjust(p_set, method = "bonferroni")
p_set_fdr <- p.adjust(p_set, method = "fdr")

# Bonferroni correction ("bonferroni") in which the p-values are multiplied by the number of comparisons
# Bonferroni is generally known as the most conservative method to control the familywise error rate.
# Con sav tive
# extremely conservative
p_set_bonferroni
print(p_set_bonferroni[p_set_bonferroni < α])
sum(p_set_bonferroni < α)
# The false discovery rate is a less stringent condition than the family-wise error rate, so these methods are more powerful than the others.
p_set_fdr
print(p_set_fdr[p_set_fdr < α])
sum(p_set_fdr < α)

plot(p_set, p_set_fdr, xlab="p_set", ylab="p_set_fdr", pch=19)
plot(p_set, p_set_bonferroni, xlab="p_set", ylab="p_set_bonferroni", pch=19)

## 1.2
watermelon_data <- readRDS("watermelon_data.RDS")
head(watermelon_data)
watermelon_data$samples
## 1.3

# topTags(object, n = 10, adjust.method = "BH", sort.by = "PValue", p.value = 1)
watermelon_data_fdr <- edgeR::topTags(watermelon_data, n = 5000, adjust.method = "fdr", sort.by = "PValue", p.value = 0.01)$table

## 1.4
dim(watermelon_data_fdr)
# Using a p.value cut-off of 0.01 and fdr correction, we obtain 2153 significant genes.

# ******************************************************************************************************************** #

# Question 2

depression <- read.csv("depression.csv")
head(depression)

## 2.1
boxplot(depression$Score ~ depression$Time,
        main = "Depression Score Over Time",
        xlab = "Time", ylab = "Depression Score", col = rgb(0.1,0.1,0.7,0.5))

## 2.2
# Yes 黑色的线是median
# Skewed T0 Negative Skew T1,T2,T3 Positive Skew
# median line of a T0 lies outside of the T1,T2,T3
# 分散
# T1, T2 have large interquartile ranges means the data is dispersed.
# T1, T2 have extreme values at the end of two whiskers, this shows the range of scores has Larger ranges indicate wider distribution, that is, more scattered data.


## 2.3

one.way <- aov(Score ~ Time, data = depression)
summary(one.way)

# Df, Sum Sq, Mean Sq, F value, Pr(>F)

## 2.4

## 2.5

## 2.6

## 2.7

## 2.8
kmeans <- kmeans(depression, 5)
fviz_cluster(kmeans, data = depression)
# ******************************************************************************************************************** #

# Question 3

# 3.1 说一下WORD refrence

# 3.2
# 3.2.1
# Quantitative Type 定量 v Qualitative 定性
# Mixed
# Objective data What, Tests hypotheses,General

# 3.2.2
# effectiveness
# 效力,
# appropriateness
# 适当性 and
# feasibility fiz bility
# 可行性
# questionnaire
# was developed to survey PA members in 2013 about their
# self-reported behaviors and perceptions related to IPC practices in
# paramedic-led health care. The survey of

# Research Data from Report

# 3.3
# Probability sampling involves random selection, allowing you to make strong statistical inferences about the whole group.
# Non-probability sampling involves non-random selection based on convenience or other criteria, allowing you to easily collect data.


# 3.4
# 3.4.1
# The null hypothesis, denoted
# H0
#
# The alternative hypothesis, denoted
# H1
# alternative hypotheses

# 3.4.2
# P < .001
# p < 0.001 as statistically highly significant. So very strong evidence against the null hypothesis
# A p-value of 0.001 indicates that if the null hypothesis tested were indeed true, there would be a one in 1,000 chance of observing results at least as extreme.

# 3.5
# 医护人员对感染控制参与者（n = 417）的调查百分比
# 自我报告经常（经常或几乎总是）进行手部卫生的感染控制参与者（n = 417）的护理人员调查百分比
# Descriptive statistics summarize the characteristics of a data set.
# Inferential statistics allow you to test a hypothesis or assess whether your data is generalizable to the broader population.