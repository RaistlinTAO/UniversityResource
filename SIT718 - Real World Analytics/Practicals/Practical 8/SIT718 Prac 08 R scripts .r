# SIT718 Prac. 08 - LP with 2+ Variables 
# Problem Description: Under 'Your Tasks' in Week 8 Prac

##############################

# Single Period Production Model


library(lpSolveAPI)

singlePeriodModel <- make.lp(8, 8) # initialise 8 constaints and 8 variables

lp.control(singlePeriodModel, sense= "maximize")  # Set control parameters: "minimize" or "maximize" 

#  Setting the objective function 
set.objfn(singlePeriodModel, c(30,	40,	20,	10,	-15,	-20,	-10,	-8))

# updating the left hand side of constaints one-by-one
set.row(singlePeriodModel, 1, c(0.3,	0.3,	0.25,	0.15), indices = c(1:4))
set.row(singlePeriodModel, 2, c(0.25,	0.35,	0.3,	0.1), indices = c(1:4))
set.row(singlePeriodModel, 3, c(0.45,	0.5,	0.4,	0.22), indices = c(1:4))
set.row(singlePeriodModel, 4, c(0.15,	0.15,	0.1,	0.05), indices = c(1:4))
set.row(singlePeriodModel, 5, c(1,1), indices =c(1,5))
set.row(singlePeriodModel, 6, c(1,1), indices =c(2,6))
set.row(singlePeriodModel, 7, c(1,1), indices =c(3,7)) 
set.row(singlePeriodModel, 8, c(1,1), indices =c(4,8)) 

# updating the right hand side of constaints 
set.rhs(singlePeriodModel, c(1000,	1000,	1000,	1000,	800,	750,	600,	500))

# updating the symbols
set.constr.type(singlePeriodModel, c("<=",	"<=",	"<=", "<=", "=",	"=",	"=", "="))

set.type(singlePeriodModel, c(1:8),"real")

set.bounds(singlePeriodModel, lower = rep(0, 8), upper = rep(Inf, 8))

# write.lp(singlePeriodModel, filename="test.lp")  Use write.lp to print out larger LPs. 
#  It produces a text file, which you can examine with any text editor.

solve(singlePeriodModel) # http://lpsolve.sourceforge.net/5.5/solve.htm

objvalue<-get.objective(singlePeriodModel)
objvalue
solution<-get.variables(singlePeriodModel)
solution

################################

# Multiple Period Production Model


library(lpSolveAPI)

multiPeriodModel <- make.lp(6, 12)

lp.control(multiPeriodModel, sense= "minimize")

set.objfn(multiPeriodModel, c(50,	45,	55,	48,	52,	50,	8,	8,	8,	8,	8,	8))

set.row(multiPeriodModel, 1, c(1,-1), indices = c(1,7))
set.row(multiPeriodModel, 2, c(1,1,-1), indices = c(2,7,8))
set.row(multiPeriodModel, 3, c(1,1,-1), indices = c(3,8,9))
set.row(multiPeriodModel, 4, c(1,1,-1), indices = c(4,9,10))
set.row(multiPeriodModel, 5, c(1,1,-1), indices = c(5,10,11))
set.row(multiPeriodModel, 6, c(1,1), indices = c(6,11))

set.rhs(multiPeriodModel, c(100,	250,	190,	140,	220,	110))

set.constr.type(multiPeriodModel, c("=",	"=",	"=", "=", "=",	"="))

set.type(multiPeriodModel, c(1:12),"integer")

set.bounds(multiPeriodModel, lower = rep(0, 12), upper = rep(Inf, 12))

# write.lp(multiPeriodModel, filename="test.lp")  Use write.lp to print out larger LPs. 
#  It produces a text file, which you can examine with any text editor.

solve(multiPeriodModel) # http://lpsolve.sourceforge.net/5.5/solve.htm

objvalue<-get.objective(multiPeriodModel)
objvalue
solution<-get.variables(multiPeriodModel)
solution

######################################################################

# TRANSPORTATION PROBLEM
# the formulars are in Weekly Resources 8.8
# Excess Demand & Using Dummy Demand Points

library(lpSolveAPI)

transportationModel <- make.lp(8, 15)

lp.control(transportationModel, sense= "minimize")

set.objfn(transportationModel, c(8,6,10,9,9,12,13,7,14,9,16,5,0,0,0)) # the last three are dummy	varibles	

set.row(transportationModel, 1, rep(1,5), indices = c(1:4,13))
set.row(transportationModel, 2, rep(1,5), indices = c(5:8,14))
set.row(transportationModel, 3, rep(1,5), indices = c(9:12,15))
set.row(transportationModel, 4,rep(1,3), indices =c(1,5,9))
set.row(transportationModel, 5,rep(1,3), indices =c(2,6,10))
set.row(transportationModel, 6,rep(1,3), indices =c(3,7,11))
set.row(transportationModel, 7,rep(1,3), indices =c(4,8,12)) 
set.row(transportationModel, 8,rep(1,3), indices =c(13:15)) 

set.rhs(transportationModel, c(72,	60,	78,	45,	70,	30,	55, 10))

set.constr.type(transportationModel, c("<=",	"<=",	"<=", ">=", ">=",	">=",	">=",">="))

set.type(transportationModel, c(1:15),"real")

set.bounds(transportationModel, lower = rep(0, 15), upper = rep(Inf, 15))

solve(transportationModel) # http://lpsolve.sourceforge.net/5.5/solve.htm

objvalue<-get.objective(transportationModel)
objvalue
solution<-get.variables(transportationModel)
solution  # This model has multiple optimal solutions with the same objective value

#write.lp(transportationModel, filename="test.lp")  #Use write.lp to print out larger LPs. 

 
