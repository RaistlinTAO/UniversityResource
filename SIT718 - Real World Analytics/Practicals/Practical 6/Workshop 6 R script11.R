kei.data <- as.matrix(read.table("KeiHotels.txt"))

minkowski <- function(x,y,p=1) (sum(abs(x-y)^p))^(1/p)

minkowski(kei.data[,1],kei.data[,2],2)

minkowski(kei.data[,1],kei.data[,3])

cor(kei.data[,1],kei.data[,3])

cor(kei.data[,1],kei.data[,3], method = "spearman")

 
d1 <- d2 <- d3 <- d4 <- array(0,9)

for(i in 1:9){ 
  d1[i] <- minkowski(kei.data[,1],kei.data[,i+1],2)
  d2[i] <- minkowski(kei.data[,1],kei.data[,i+1],1)
  d3[i] <- cor(kei.data[,1],kei.data[,i+1], method = "pearson")
  d4[i] <- cor(kei.data[,1],kei.data[,i+1], method = "spearman")}

d1 # Euclidean
d2 # Manhattan
d3 # Pearson
d4 # Spearman

#############################

hist(kei.data[,5])

hist(kei.data[,1])

hist(kei.data[,7])

plot(kei.data[,1],kei.data[,2])

plot(kei.data[,1],kei.data[,5])

##############################

source("AggWaFit718.R")

# find the weights for a weighted arithmetic mean that best 
# approximates Kei¡¯s ratings from those of the other users.
fit.QAM(kei.data[,c(2:10,1)]) # by default, it uses AM
# It generates two files output1.txt and stats1.txt in your working directory, the name of output files can be changed
# The last column in output1.txt is the fitted value

#  Weighted power means with p=0.5, the outputs files are PM05output1.txt and PM05stats1.txt
fit.QAM(kei.data[,c(2:10,1)],output.1="PM05output1.txt",stats.1="PM05stats1.txt", g=PM05,g.inv = invPM05) # p = 0.5

#  Weighted power means with p=2, the outputs files are QMoutput1.txt and QMstats1.txt
fit.QAM(kei.data[,c(2:10,1)],output.1="QMoutput1.txt",stats.1="QMstats1.txt",g=QM,g.inv = invQM) # p = 2

#  Weighted geometric means, the outputs files are GMoutput1.txt and GMstats1.txt 
fit.QAM(kei.data[,c(2:10,1)],output.1="GMoutput1.txt",stats.1="GMstats1.txt",g=GMa,g.inv = invGMa) # GM


#  OWA, the outputs files are OWAoutput1.txt and OWAstats1.txt 
fit.OWA(kei.data[,c(2:10,1)],"OWAoutput1.txt","OWAstats1.txt") # OWA


###############################

# identify the fuzzy measures for user 6, 5, 10 and 9 that fit user 1. The outputs files are Choutput1.txt and Chstats1.txt 
fit.choquet(kei.data[,c(6,5,10,9,1)],output.1="Choutput1.txt",stats.1="Chstats1.txt",)

# Shapley value shows the importance of the input varibles

# the order of binary number in tats1.txt shows the fuzzy measures
# referring to "Binary representation of the fuzzy measures (Choquet integrals)" in Practical 5

#No.  Binary  Variable-set
#1	  0001    variable 1
#2	  0010    variable 2
#3	  0011    variable 1,2
#4	  0100    variable 3
#5	  0101    variable 1,3
#6	  0110    variable 2,3
#7  	0111    variable 1,2,3
#8	  1000    variable 4
#9  	1001    variable 1,4
#10	  1010    variable 2,4
#11	  1011    variable 1,2,4
#12	  1100    variable 3,4
#13	  1101    variable 1,3,4
#14  	1110    variable 2,3,4
#15 	1111    variable 1,2,3,4


