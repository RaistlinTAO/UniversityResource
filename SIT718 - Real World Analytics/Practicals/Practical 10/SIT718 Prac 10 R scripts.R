# SIT718 Prac. 10


#########################
#########################

# Q1

# Player I's game #

library(lpSolveAPI)

lprec <- make.lp(0, 4)

lp.control(lprec, sense= "maximize") #  can change sense to  "minimize"



set.objfn(lprec, c(0, 0, 0, 1)) # x1 x2 x3 v


add.constraint(lprec, c(-3, 2, 5, 1), "<=", 0)

add.constraint(lprec, c(1, -4, 6, 1), "<=", 0)

add.constraint(lprec, c(3, 1, -2, 1), "<=", 0)

add.constraint(lprec, c(1,1,1,0), "=", 1)

set.bounds(lprec, lower = c(0, 0, 0, -Inf))

RowNames <- c("Row1", "Row2", "Row3","Row4")

ColNames <- c("x1", "x2", "x3", "v")

dimnames(lprec) <- list(RowNames, ColNames)



solve(lprec) # http://lpsolve.sourceforge.net/5.5/solve.htm

get.objective(lprec)

get.variables(lprec)

get.constraints(lprec)


lprec 

#############################################

# Player II's game #

library(lpSolveAPI)

lprec <- make.lp(0, 4) # y1 y2 y3 v

lp.control(lprec, sense= "minimize") #  can change sense to  "maximize"



set.objfn(lprec, c(0, 0, 0, 1))

add.constraint(lprec, c(-3,1,3, 1), ">=", 0)

add.constraint(lprec, c(2,-4,1, 1), ">=", 0)

add.constraint(lprec, c(5,6,-2, 1), ">=", 0)

add.constraint(lprec, c(1,1,1,0), "=", 1)

set.bounds(lprec, lower = c(0, 0, 0, -Inf))

RowNames <- c("Row1", "Row2", "Row3","Row4")

ColNames <- c("y1", "y2", "y3", "v")

dimnames(lprec) <- list(RowNames, ColNames)



solve(lprec) # http://lpsolve.sourceforge.net/5.5/solve.htm

get.objective(lprec)

get.variables(lprec)

get.constraints(lprec)


lprec


##################################################
################################################## 

# Q2

# Player I's game #

library(lpSolveAPI)

lprec <- make.lp(0, 5)

lp.control(lprec, sense= "maximize") #  can change sense to  "minimize"



set.objfn(lprec, c(0, 0, 0, 0, 1)) 


add.constraint(lprec, c(-1, -3, 0, -2, 1), "<=", 0)

add.constraint(lprec, c(2, -2, -4, -3, 1), "<=", 0)

add.constraint(lprec, c(-1, -5, 2, 2, 1), "<=", 0)

add.constraint(lprec, c(-2, -4, 3, 4, 1), "<=", 0)

add.constraint(lprec, c(1,1,1,1,0), "=", 1)

set.bounds(lprec, lower = c(0, 0, 0, 0, -Inf))

RowNames <- c("Row1", "Row2", "Row3", "Row4", "Row5")

ColNames <- c("x1", "x2", "x3", "x4", "v")

dimnames(lprec) <- list(RowNames, ColNames)



solve(lprec) # http://lpsolve.sourceforge.net/5.5/solve.htm

get.objective(lprec)

get.variables(lprec)

get.constraints(lprec)


lprec 

#############################################

# Player II's game #

library(lpSolveAPI)

lprec <- make.lp(0, 5)

lp.control(lprec, sense= "minimize") #  can change sense to  "maximize"



set.objfn(lprec, c(0, 0, 0, 0, 1))

add.constraint(lprec, c(-1, 2, -1, -2, 1), ">=", 0)

add.constraint(lprec, c(-3,-2, -5, -4, 1), ">=", 0)

add.constraint(lprec, c(0, -4, 2, 3, 1), ">=", 0)

add.constraint(lprec, c(-2, -3, 2, 4, 1), ">=", 0)

add.constraint(lprec, c(1,1,1,1,0), "=", 1)

set.bounds(lprec, lower = c(0, 0, 0, 0, -Inf))

RowNames <- c("Row1", "Row2", "Row3","Row4","Row5")

ColNames <- c("x1", "x2", "x3", "x4", "v")

dimnames(lprec) <- list(RowNames, ColNames)



solve(lprec) # http://lpsolve.sourceforge.net/5.5/solve.htm

get.objective(lprec)

get.variables(lprec)

get.constraints(lprec)


lprec



