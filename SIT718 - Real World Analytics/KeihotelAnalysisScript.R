source("AggWaFit718.R")


# open hotel file
read.table("KeiHotels.txt")

QAM(c(0.3,0.4,0.2),c(0.1,0.3,0.6)) # WAM by default
QAM(c(0.3,0.4,0.2),c(0.1,0.3,0.6), AM, invAM) # WAM

#use generators for others
QAM(c(0.3,0.4,0.2),c(0.1,0.3,0.6), GM, invGM) # GM
QAM(c(0.3,0.4,0.2),c(0.1,0.3,0.6), QM, invQM) # PM p=2 
QAM(c(0.3,0.4,0.2),c(0.1,0.3,0.6),PM05,invPM05) # PM p=0.5
OWA(c(0.3,0.4,0.2),c(0.1,0.3,0.6))
choquet(c(0.2,0.5),c(0.4,0.7,1))

A<-as.matrix(read.table("KeiHotels.txt"))
A
# AM of 3rd row
QAM(A[3,])

#transform to [0,1]
A<- A/100
A

#last column should have the target(Kei's values)
to.fit <- A[,c(2,4,5,3,1)]
to.fit

#Weighted mean fir
fit.QAM(to.fit,"out_AM.txt", "stat_AM.txt")
# the above stats output shows that var 3 is contributing more
# variable 2 contributing less.
to.fit[,c(3,5)]

plot(to.fit[,c(3,5)]) # 3 is giving similar as Kei.
plot(to.fit[,c(2,5)])

fit.OWA(to.fit,"out_OWA.txt", "stat_OWA.txt")

to.fit[5,]

fit.QAM(to.fit,"out_PM05.txt", "stat_PM05.txt",PM05, invPM05)


fit.choquet(to.fit,"out_choq.txt", "stat_choq.txt")
fit.choquet(A[,c(6,5,10,9)],"out_choq2.txt", "stats_choq2.txt")

