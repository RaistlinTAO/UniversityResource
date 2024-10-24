# SIT718  - Two Variable LP programming 

# The following script provide solutions for two examples used in week 7

# 7.5 - Toy Company Problem
 
#install.packages("lpSolveAPI")  # install the package in the first time

library(lpSolveAPI)

toyCompanyModel <- make.lp(0, 2) # initialise 0 constaint and two variables

lp.control(toyCompanyModel, sense= "maximize") # Set control parameters: "minimize" or "maximize" 

set.objfn(toyCompanyModel, c(3,2)) # Setting the objective function

add.constraint(toyCompanyModel, c(2,1), "<=", 100)

add.constraint(toyCompanyModel, c(1,1), "<=", 80) 

set.bounds(toyCompanyModel, lower = c(40,0), columns = c(1, 2))

set.bounds(toyCompanyModel, upper = c(Inf,Inf), columns = c(1, 2))

RowNames <- c("Constraint 1", "Constraint 2")

ColNames <- c("Soldiers", "Trains")

dimnames(toyCompanyModel) <- list(RowNames, ColNames) # Rename the rows and columns in the model 

toyCompanyModel # Display the model

solve(toyCompanyModel) # Solve the model, see http://lpsolve.sourceforge.net/5.5/solve.htm

get.objective(toyCompanyModel)   # Retrieve the value of the objective function

get.variables(toyCompanyModel)   # Retrieve the values of the decision variables

get.constraints(toyCompanyModel) # Retrieve the values of the constraints



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

1470-get.objective(assemblyModel) # We need to convert the objective function to the original version

get.variables(assemblyModel)

get.constraints(assemblyModel) 


##############################