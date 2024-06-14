
# SIT718  - Two Variable LP programming 

##############################
# Workshop: DAVE'S DECISION PROBLEM

#install.packages("lpSolveAPI")  # install the package in the first time

library(lpSolveAPI)

DAVEmodel <- make.lp(0, 2) # initialise 0 constaint and two variables

lp.control(DAVEmodel, sense= "minimize") # Set control parameters: "minimize" or "maximize" 

set.objfn(DAVEmodel, c(10,3)) # 10x1 + 3x2   Setting the objective function

add.constraint(DAVEmodel, c(3,2), ">=", 60) # 3x1 + 2x2 >= 60

add.constraint(DAVEmodel, c(7,2), ">=", 84) # 7x1 + 2x2 >= 84

add.constraint(DAVEmodel, c(3,6), ">=", 72) # 3x1 + 6x2 >= 72

set.bounds(DAVEmodel, lower = c(0,0), columns = c(1, 2)) # x1, x2 >= 0

set.bounds(DAVEmodel, upper = c(Inf,Inf), columns = c(1, 2))

RowNames <- c("Constraint 1", "Constraint 2", "Constraint 3")

ColNames <- c("Feed 1", "Feed 2")

dimnames(DAVEmodel) <- list(RowNames, ColNames) # Rename the rows and columns in the model 

DAVEmodel # Display the model

solve(DAVEmodel) # Solve the model, see http://lpsolve.sourceforge.net/5.5/solve.htm

get.objective(DAVEmodel)   # Retrieve the value of the objective function

get.variables(DAVEmodel)   # Retrieve the values of the decision variables

get.constraints(DAVEmodel) # Retrieve the values of the constraints

 

##############################
# Workshop: VICKY'S DECISION PROBLEM


library(lpSolveAPI)

VICKYmodel <- make.lp(0, 2) # two variables

lp.control(VICKYmodel, sense= "minimize")

set.objfn(VICKYmodel, c(0.3,0.9)) # 0.3x1 + 0.9x2

add.constraint(VICKYmodel, c(1,1), ">=", 800) # x1 + x2 >= 800

add.constraint(VICKYmodel, c(0.09-0.3,0.6-0.3), ">=", 0) # 0.09x1 + 0.6x2 >= 0.3(x1 + x2)

add.constraint(VICKYmodel, c(0.02-0.05,0.06-0.05), "<=", 0) # 0.02x1 + 0.06x2 <= 0.05(x1 + x2)

set.bounds(VICKYmodel, lower = c(0,0), columns = c(1, 2)) # x1, x2 >= 0

set.bounds(VICKYmodel, upper = c(Inf,Inf), columns = c(1, 2))

RowNames <- c("Constraint 1", "Constraint 2" , "Constraint 3")

ColNames <- c("corn", "soybean")

dimnames(VICKYmodel) <- list(RowNames, ColNames)

VICKYmodel

solve(VICKYmodel) # http://lpsolve.sourceforge.net/5.5/solve.htm

get.objective(VICKYmodel)

get.variables(VICKYmodel)

get.constraints(VICKYmodel) 


##############################


# The following script provide solutions for two examples used in week 7 Weekly Resources

# 7.5 - Toy Company Problem


library(lpSolveAPI)

toyCompanyModel <- make.lp(0, 2) # two variables

lp.control(toyCompanyModel, sense= "maximize")

set.objfn(toyCompanyModel, c(3,2))

add.constraint(toyCompanyModel, c(2,1), "<=", 100)

add.constraint(toyCompanyModel, c(1,1), "<=", 80) 

set.bounds(toyCompanyModel, lower = c(40,0), columns = c(1, 2))

set.bounds(toyCompanyModel, upper = c(Inf,Inf), columns = c(1, 2))

RowNames <- c("Constraint 1", "Constraint 2")

ColNames <- c("Soldiers", "Trains")

dimnames(toyCompanyModel) <- list(RowNames, ColNames)

toyCompanyModel

solve(toyCompanyModel) # http://lpsolve.sourceforge.net/5.5/solve.htm

get.objective(toyCompanyModel)

get.variables(toyCompanyModel)

get.constraints(toyCompanyModel) 



##############################

# 7.6 - Assembly Line Problem

library(lpSolveAPI)

assemblyModel <- make.lp(0, 2) # two variables

lp.control(assemblyModel, sense= "maximize")

set.objfn(assemblyModel, c(12,19))

add.constraint(assemblyModel, c(3,6), "<=", 540)

add.constraint(assemblyModel, c(5,5), "<=", 450) 

add.constraint(assemblyModel, c(4,8), "<=", 480) 

set.bounds(assemblyModel, lower = c(0,0), columns = c(1, 2))

set.bounds(assemblyModel, upper = c(Inf,Inf), columns = c(1, 2))

RowNames <- c("Constraint 1", "Constraint 2", "Constraint 3")

ColNames <- c("Smart-1", "Smart-2")

dimnames(assemblyModel) <- list(RowNames, ColNames)

solve(assemblyModel) # http://lpsolve.sourceforge.net/5.5/solve.htm

assemblyModel

1470-get.objective(assemblyModel)# We need to convert the objective function to the original version

get.variables(assemblyModel)

get.constraints(assemblyModel) 

