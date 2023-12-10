library("ggplot2")

# Load CSV
depression <- read.csv("depression.csv")
head(depression)

# remove any missing value
depression <- na.omit(depression)

# Drop Barplot for mean compare

ggplot(depression, aes(Time, Score)) +
  geom_bar(
    position = "dodge",
    stat = "summary",
    fun = "mean",
    col = "red"
  ) +
  labs(x = "Time", y = "Mean Score")

# Therefore, the t0 is significantly different from t1,t2,t3

des_aov <- aov(Score ~ Time, data = depression)
summary(des_aov)

# Post-hoc tests
# When a one-way ANOVA test leads to a significant result, it is common to then
# follow up with post-hoc tests to see which particular groups are significantly
# different from each other. Post-hoc tests essentially involve carrying out
# multiple t-tests to test for differences between each pair of categories.

hist(des_aov$residuals)
shapiro.test(des_aov$residuals)

# P-value of the Shapiro-Wilk test on the residuals is larger than the usual
# significance level of α = .05
# so we do not reject the hypothesis that residuals follow a normal distribution
# (p-value = 0.1132).

# 格式化代码，在R STUDIO里，全选所有代码，然后 CTRL+SHIFT+A