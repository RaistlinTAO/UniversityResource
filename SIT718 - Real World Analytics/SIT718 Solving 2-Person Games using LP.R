#############################################
# MIXED STRATEGIES #
# For Weekly Resources 10.4 Solving 2-Person Zero-Sum Games using LP
#############################################

# Player I¡¯s game #

library(lpSolveAPI)

lprec <- make.lp(0, 4)

lp.control(lprec, sense= "maximize")  

set.objfn(lprec, c(0, 0, 0, 1))

add.constraint(lprec, c(2, 1, -3, 1), "<=", 0)

add.constraint(lprec, c(-1, 1, 0, 1), "<=", 0)

add.constraint(lprec, c(3, -2, 1, 1), "<=", 0)

add.constraint(lprec, c(1,1,1,0), "=", 1)

set.bounds(lprec, lower = c(0, 0, 0, -Inf))

RowNames <- c("Row1", "Row2", "Row3","Row4")

ColNames <- c("x1", "x2", "x3", "v")

dimnames(lprec) <- list(RowNames, ColNames)

lprec

solve(lprec) # http://lpsolve.sourceforge.net/5.5/solve.htm

get.objective(lprec)

get.variables(lprec)

get.constraints(lprec)




#############################################

# Player II¡¯s game #

lprec <- make.lp(0, 4)

lp.control(lprec, sense= "minimize") 

set.objfn(lprec, c(0, 0, 0, 1))

add.constraint(lprec, c(2, -1, 3, 1), ">=", 0)

add.constraint(lprec, c(1, 1, -2, 1), ">=", 0)

add.constraint(lprec, c(-3, 0, 1, 1), ">=", 0)

add.constraint(lprec, c(1,1,1,0), "=", 1)

set.bounds(lprec, lower = c(0, 0, 0, -Inf))

RowNames <- c("Row1", "Row2", "Row3","Row4")

ColNames <- c("y1", "y2", "y3", "v")

dimnames(lprec) <- list(RowNames, ColNames)

lprec

solve(lprec) # http://lpsolve.sourceforge.net/5.5/solve.htm

get.objective(lprec)

get.variables(lprec)

get.constraints(lprec)





################################################
################################################
# Non zero-Sum game

# Player I¡¯s payoff #

library(lpSolveAPI)

lprec <- make.lp(0, 3)

lp.control(lprec, sense= "maximize")  

set.objfn(lprec, c(0, 0, 1))

add.constraint(lprec, c(-1, -3, 1), "=", 0)

add.constraint(lprec, c(-4, -2, 1), "=", 0)

add.constraint(lprec, c(1,1,0), "=", 1)

set.bounds(lprec, lower = c(0, 0, -Inf))

RowNames <- c("Row1", "Row2", "Row3")

ColNames <- c("y1", "y2", "v")

dimnames(lprec) <- list(RowNames, ColNames)

lprec

solve(lprec) 

get.objective(lprec)

get.variables(lprec)

get.constraints(lprec)



# Player II¡¯s payoff #

library(lpSolveAPI)

lprec <- make.lp(0, 3)

lp.control(lprec, sense= "maximize")  

set.objfn(lprec, c(0, 0, 1))

add.constraint(lprec, c(-3, -1, 1), "=", 0)

add.constraint(lprec, c(-2, -4, 1), "=", 0)

add.constraint(lprec, c(1,1,0), "=", 1)

set.bounds(lprec, lower = c(0, 0, -Inf))

RowNames <- c("Row1", "Row2", "Row3")

ColNames <- c("x1", "x2", "v")

dimnames(lprec) <- list(RowNames, ColNames)

lprec

solve(lprec) 

get.objective(lprec)

get.variables(lprec)

get.constraints(lprec)

