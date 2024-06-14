#################################################
#############                       #############
#############  AggWAfit             #############
#############                       #############
#################################################

#  The following functions can be used for calculating and fitting aggregation functions to data
#  
#  For fitting, the data table needs to be in the form x_11 x_12 ... x_1n y_1, i.e. with the first
#        n columns representing the variables and the last column representing the output.


###############################################################
# NECESSARY LIBRARIES (will require installation of packages) #
###############################################################

library(lpSolve)
#library(scatterplot3d)

########################
# FUNCTION DEFINITIONS #
########################

#------ some generators ------#
AM <- function(x) {x}
invAM <- function(x) {x}
GM <- function(x) {-log(x)}
invGM <- function(x) {exp(-x)}
GMa <- function(x)    {x^0.00001}
invGMa <- function(x) {x^(1/0.00001)}
QM <- function(x) {x^2}
invQM <- function(x) {sqrt(x)}
PM05 <- function(x) {x^0.5}
invPM05 <-function(x) {x^(1/0.5)}
HM <- function(x) {x^(-1)}
invHM <- function(x) {x^(-1)}


#------ Weighted Power Means ------#

PM <- function(x,w =array(1/length(x),length(x)),p) {    # 1. pre-defining the function inputs
  if(p == 0) {                  # 2. condition for `if' statement
    prod(x^w) 			          # 3. what to do when (p==0) is TRUE
  }
  else {(sum(w*(x^p)))^(1/p)}   # 4. what to do when (p==0) is FALSE
}



#------ Weighted Quasi-Arithmetic Means ------#

QAM <- function(x,w=array(1/length(x),length(x)),g=AM,g.inv=invAM) { # 1. pre-defining the inputs 
  #    (with equal weights and g ~arithmetic mean default)
  n=length(x)														# 2. store the length of x
  for(i in 1:n) x[i] <- g(x[i])									# 3. transform each of the inputs 
  #    individually in case definition of g can't operate
  #    on vectors
  g.inv(sum(x*w))													# 4. QAM final calculation
}


#------ OWA  ------# 

#    Note that this calculates the OWA assuming the data are arranged from lowest to highest - this is opposite to a number of publications but was used in the text for consistency with other functions requiring a reordering of the inputs.

OWA <- function(x,w=array(1/length(x),length(x)) ) {    # 1. pre-defining the inputs (with equal weights default)
  w <- w/sum(w)											# 2. normalise the vector in case weights don't add to 1
  sum(w*sort(x))							# 3. OWA calculation
}


#------ Choquet Integral  ------#

choquet <- function(x,v) {   						# 1. pre-defining the inputs (no default)
  n <- length(x)               						# 2. store the length of x
  w <- array(0,n)             						# 3. create an empty weight vector
  for(i in 1:(n-1)) {          						# 4. define weights based on order
    v1 <- v[sum(2^(order(x)[i:n]-1))]     			#
    # 4i. v1 is f-measure of set of all 
    #     elements greater or equal to 
    #     i-th smallest input.   
    v2 <- v[sum(2^(order(x)[(i+1):n]-1))] 			#
    # 4ii. v2 is same as v1 except 
    #     without i-th smallest 
    w[i] <-  v1 - v2           						# 4iii. subtract to obtain w[i]  
  }                         						#
  w[n] <- 1- sum(w)            						# 4iv. final weight leftover            
  x <- sort(x)                 						# 5. sort our vector
  sum(w*x)                     						# 6. calculate as we would WAM
}



#############################
# PLOTTING FUNCTIONS #
#############################

#------ 3D mesh plot  ------#

f.plot3d <- function(f,x.dom = c(0,1), y.dom = c(0,1),grid = c(25,25)) {
  all.points <- array(0,0)
  for(j in 0:(grid[2])) {for(i in 0:(2*grid[1]))  {
    all.points <- rbind(all.points,c(x.dom[1]+abs(grid[1]-i)*(x.dom[2]-x.dom[1])/grid[1],y.dom[1]+j*(y.dom[2]-y.dom[1])/grid[2])    )
  }}
  for(j in grid[1]:0) {for(i in 0:(2*grid[2]))  {
    all.points <- rbind(all.points,c(x.dom[1]+j*(x.dom[2]-x.dom[1])/grid[1], y.dom[1]+abs(grid[2]-i)*(y.dom[2]-y.dom[1])/grid[2]    ))
  }
  }
  
  all.points <- cbind(all.points,0)
  for(i in 1:nrow(all.points)) all.points[i,3] <- f(all.points[i,1:2])
  
  scatterplot3d(all.points,type="l",color="red",xlab="y",ylab="",zlab="",angle=150,scale.y=0.5,grid=FALSE,lab=c(3,3),x.ticklabs=c(x.dom[1],(x.dom[2]-x.dom[1])/2+x.dom[1],x.dom[2]),y.ticklabs=c(y.dom[1],(y.dom[2]-y.dom[1])/2+y.dom[1],y.dom[2]))
  text(-0.85,0,"x")
}

#############################
# FITTING FUNCTIONS TO DATA #
#############################


#------ fit.QAM  (finds the weighting vector w and outputs new y-values)  ------#
#
#  This function can be used to find weights for any power mean (including arithmetic means, geometric mean etc.)
#  It requires the generators (defined above), so for fitting power means, the arguments g= and g.inv= can be changed
#     appropriately.
#  It outputs the input table with the predicted y-values appended and a stats file.  To avoid overwriting
#     these files, you will need to change the output name each time.  The stats file includes measures
#     of correlation, RMSE, L1-error and the orness of the weighting vector.
#  The fitting can be implemented on a matrix A using
#     fit.OWA(A,"output.file.txt","output.stats.txt"). 


fit.QAM <- function(the.data,output.1="output1.txt",stats.1="stats1.txt",g=AM,g.inv=invAM) {
  # preliminary information
  ycol <- ncol(the.data)
  n <- ycol-1
  instances <- nrow(the.data)
  
  # build constraints matrix 
  all.const <- array(0,0)
  # reordered g(x_i)
  for(k in 1:instances) {const.i <- as.numeric(the.data[k,1:n]) 
  for(j in 1:n) const.i[j] <- g(const.i[j])
  all.const <- rbind(all.const,const.i)
  }
  # residual coefficients
  resid.pos <- -1*diag(instances)
  resid.neg <- diag(instances)
  # merge data constraints f - rij = y
  all.const <- cbind(all.const,resid.pos,resid.neg)
  # add row for weights sum to 1
  all.const<-rbind(all.const,c(array(1,n),array(0,2*instances)))
  
  # enforce weights >0
  w.geq0 <- diag(n)
  w.geq0 <- cbind(w.geq0,array(0,c(n,2*instances)))
  # add weight constraints to matrix
  all.const<-rbind(all.const,w.geq0)
  # create rhs of constr
  constr.v <- array(0,nrow(all.const))
  for(i in 1:instances) {
    # populate with y observed
    constr.v[i] <- g(the.data[i,ycol])
    # weights sum to 1
    constr.v[instances+1] <- 1
    # remainder should stay 0
  }		
  for(i in (instances+2):length(constr.v)) {constr.v[i] <- 0}								
  # create inequalities direction vector
  constr.d <- c(array("==",(instances+1)),array(">=",n))
  
  # objective function is sum of resids
  obj.coeff <- c(array(0,n),array(1,2*instances))
  # solve the lp to find w
  lp.output<-lp(direction="min",obj.coeff,all.const,constr.d,constr.v)$solution
  # create the weights matrix
  w.weights<-array(lp.output[1:n])
  # calculate predicted values
  new.yvals <- array(0,instances)
  for(k in 1:instances) {
    new.yvals[k] <- QAM(the.data[k,1:n],(w.weights),g,g.inv)
  }
  # write the output
  
  write.table(cbind(the.data,new.yvals),output.1,row.names = FALSE, col.names = FALSE)
  # write some stats	
  RMSE <- (sum((new.yvals - the.data[,ycol])^2)/instances)^0.5
  av.l1error <- sum(abs(new.yvals - the.data[,ycol]))/instances
  
  somestats <- rbind(c("RMSE",RMSE),c("Av. abs error",av.l1error),c("Pearson correlation",cor(the.data[,ycol],new.yvals)),c("Spearman correlation",cor(the.data[,ycol],new.yvals,method="spearman")),c("i","w_i "),cbind(1:n,w.weights))
  
  write.table(somestats,stats.1,quote = FALSE,row.names=FALSE,col.names=FALSE)	
}



#------ fit.OWA  (finds the weighting vector w and outputs new y-values)  ------#
#
#  This function can be used to find weights for the OWA.
#  It outputs the input table with the predicted y-values appended and a stats file.  To avoid overwriting
#     these files, you will need to change the output name each time.  The stats file includes measures
#     of correlation, RMSE, L1-error and the orness of the weighting vector.
#  The fitting can be implemented on a matrix A using
#     fit.OWA(A,"output.file.txt","output.stats.txt"). 

# reads data as x1 ... xn y

fit.OWA <- function(the.data,output.1="output1.txt",stats.1="stats1.txt") {
  # preliminary information										
  ycol <- ncol(the.data)
  n <- ycol-1
  instances <- nrow(the.data)
  
  # build constraints matrix 
  all.const <- array(0,0)
  # reordered g(x_i)
  for(k in 1:instances) {const.i <- as.numeric(sort(the.data[k,1:n])) 
  all.const <- rbind(all.const,const.i)
  }
  # residual coefficients
  resid.pos <- -1*diag(instances)
  resid.neg <- diag(instances)
  # merge data constraints f - rij = y
  all.const <- cbind(all.const,resid.pos,resid.neg)
  # add row for weights sum to 1
  all.const<-rbind(all.const,c(array(1,n),array(0,2*instances)))
  
  # enforce weights >0
  w.geq0 <- diag(n)
  w.geq0 <- cbind(w.geq0,array(0,c(n,2*instances)))
  # add weight constraints to matrix
  all.const<-rbind(all.const,w.geq0)
  # create rhs of constr
  constr.v <- array(0,nrow(all.const))
  for(i in 1:instances) {
    # populate with y observed
    constr.v[i] <- the.data[i,ycol]
    # weights sum to 1
    constr.v[instances+1] <- 1
    # remainder should stay 0
  }		
  for(i in (instances+2):length(constr.v)) {constr.v[i] <- 0}								
  # create inequalities direction vector
  constr.d <- c(array("==",(instances+1)),array(">=",n))
  
  # objective function is sum of resids
  obj.coeff <- c(array(0,n),array(1,2*instances))
  # solve the lp to find w
  lp.output<-lp(direction="min",obj.coeff,all.const,constr.d,constr.v)$solution
  # create the weights matrix
  w.weights<-array(lp.output[1:n])
  # calculate predicted values
  new.yvals <- array(0,instances)
  for(k in 1:instances) {
    new.yvals[k] <- OWA(the.data[k,1:n],t(w.weights))
  }
  # write the output						
  
  
  write.table(cbind(the.data,new.yvals),output.1,row.names = FALSE, col.names = FALSE)
  # write some stats	
  RMSE <- (sum((new.yvals - the.data[,ycol])^2)/instances)^0.5
  av.l1error <- sum(abs(new.yvals - the.data[,ycol]))/instances
  
  
  somestats <- rbind(c("RMSE",RMSE),c("Av. abs error",av.l1error),c("Pearson correlation",cor(the.data[,ycol],new.yvals)),c("Spearman correlation",cor(the.data[,ycol],new.yvals,method="spearman")),c("Orness",sum(w.weights*(1:n-1)/(n-1))), c("i","w_i "),cbind(1:n,w.weights))
  
  write.table(somestats,stats.1,quote = FALSE,row.names=FALSE,col.names=FALSE)	
}


#------ fit.choquet  (finds the weighting vector w and outputs new y-values)  ------#
#
#  This function can be used to find weights for the OWA.
#  It outputs the input table with the predicted y-values appended and a stats file.  To avoid overwriting
#     these files, you will need to change the output name each time.  The stats file includes measures
#     of correlation, RMSE, L1-error and the orness of the weighting vector.
#  The fitting can be implemented on a matrix A using
#     fit.OWA(A,"output.file.txt","output.stats.txt"). 

fit.choquet <- function(the.data,output.1="output1.txt",stats.1="stats1.txt",kadd=(ncol(the.data)-1)) {
  # preliminary information
  ycol <- ncol(the.data)
  n <- ycol - 1
  instances <- nrow(the.data)
  numvars <- 1
  for(i in 1:kadd) {numvars <- numvars + factorial(n)/(factorial(i)*factorial(n-i))}
  # build cardinality data sets
  card <- rbind(0,t(t(1:n)))
  for(k in 2:n) {
    card <- cbind(card,0)
    card <- rbind(card, t(combn(n,k)))
  }
  
  # convert the cardinality table to binary equivalent and add conversion indices
  base.conv <- function(x,b) {
    out <- array(1,x)
    for(p in 2:x) out[p] <- b^{p-1}
    out
  }
  card.bits <- array(0,c(2^n,n))
  for(i in 1:(2^n)) for(j in 1:n) {
    if(card[i,j]>0) {card.bits[i,card[i,j]] <- 1}
  }
  card.bits <- cbind(card.bits,{1:{2^n}})
  card.bits <- cbind(card.bits,0)
  for(i in 1:(2^n)) {
    card.bits[i,(n+2)] <- 1+sum(base.conv(n,2)*card.bits[i,1:n])}
  
  
  # build constraints matrix 
  all.const <- array(0,0)
  # reordered g(x_i)
  for(k in 1:instances) {
    const.i <- array(0,numvars)
    for(s in 2:numvars) {
      const.i[s]<-min(the.data[k,card[s,]])
    }
    
    all.const <- rbind(all.const,const.i)
  }
  if(kadd>1){
    all.const <- cbind(all.const,-1*all.const[,(n+2):numvars])}
  # residual coefficients
  resid.pos <- -1*diag(instances)
  resid.neg <- diag(instances)
  # merge data constraints f - rij = y
  all.const <- cbind(all.const,resid.pos,resid.neg)
  # add row for mobius values sum to 1
  all.const<-rbind(all.const,c(array(1,numvars),array(-1,(numvars-n-1)),array(0,2*instances)))
  
  
  # add monotonicity constraints
  if(kadd>1) {
    num.monconst <-0
    for(m in (n+2):(2^n))	{
      
      setA <- subset(card[m,1:n],card[m,1:n]>0)
      # now find all subsets of corresponding set
      all.setB <- card.bits
      for(q in setdiff((1:n),setA)) {
        all.setB <- subset(all.setB,all.setB[,q]==0)}
      numv.setB <- subset(all.setB,all.setB[,(n+1)]<=numvars)
      for(b in setA) {
        mon.const.m <- array(0,ncol(all.const))
        mon.const.m[subset(all.setB[,(n+1)],all.setB[,b]>0)] <- 1
        mon.const.m[(numvars+1):(2*numvars-n-1)]<- -1*mon.const.m[(n+2):numvars]
        all.const<-rbind(all.const,mon.const.m)
        num.monconst<-num.monconst+1}
    }
  }
  
  all.const<-all.const[,2:(ncol(all.const))]
  
  # create rhs of constr
  constr.v <- array(0,nrow(all.const))
  
  for(i in 1:instances) {
    # populate with y observed
    constr.v[i] <- (the.data[i,ycol])
    # weights sum to 1
    constr.v[instances+1] <- 1					
    # remainder should stay 0
  }		
  
  # create inequalities direction vector   
  constr.d <- c(array("==",(instances+1)))
  
  if(kadd>1) {
    constr.d <- c(array("==",(instances+1)),array(">=",(num.monconst)))
  }
  
  # objective function is sum of resids
  obj.coeff <- c(array(0,(n)),array(1,2*instances))			
  if(kadd>1)	{
    obj.coeff <- c(array(0,(2*numvars-n-2)),array(1,2*instances))
  }
  # solve the lp to find w
  lp.output<-lp(direction="min",obj.coeff,all.const,constr.d,constr.v)$solution
  # create the weights matrix
  mob.weights<-array(lp.output[1:n])
  if(kadd>1) {									
    mob.weights<-c(array(lp.output[1:(n)]),lp.output[(n+1):(numvars-1)]-lp.output[(numvars):(2*numvars-n-2)])
  }
  zetaTrans <- function(x) {
    n <- log(length(x),2)
    zeta.out <- array(0,length(x))
    # first specify the correspond set
    for(i in 2:length(x))	{
      setA <- subset(card[i,1:n],card[i,1:n]>0)
      # now find all subsets of corresponding set
      all.setB <- cbind(card.bits,x)
      for(j in setdiff((1:n),setA)) {
        all.setB <- subset(all.setB,all.setB[,j]==0)}
      ZA <- 0
      # add each m(B) provided these have been attached in n+1 th position
      
      for(b in 1:nrow(all.setB))
        ZA <- ZA + all.setB[b,ncol(all.setB)]			
      zeta.out[i]<- ZA}
    zeta.out <- zeta.out[order(card.bits[,(n+2)])]
    zeta.out}
  
  mob.weights.v <- array(0,2^n)
  for(v in 2:length(mob.weights.v)) mob.weights.v[v]<-mob.weights[v-1]
  fm.weights.v <- zetaTrans(mob.weights.v)
  # calculate predicted values
  new.yvals <- array(0,instances)
  for(k in 1:instances) {
    new.yvals[k] <- choquet(as.numeric(the.data[k,1:n]),fm.weights.v[2:(2^n)])
  }
  # write the output
  
  write.table(cbind(the.data,new.yvals),output.1,row.names = FALSE, col.names = FALSE)
  # write some stats	
  RMSE <- (sum((new.yvals - the.data[,ycol])^2)/instances)^0.5
  av.l1error <- sum(abs(new.yvals - the.data[,ycol]))/instances
  shapley <- function(v) {    # 1. the input is a fuzzy measure
    n <- log(length(v)+1,2)     # 2. calculates n based on |v|
    shap <- array(0,n)          # 3. empty array for Shapley values
    for(i in 1:n) {             # 4. Shapley index calculation
      shap[i] <- v[2^(i-1)]*factorial(n-1)/factorial(n) # 
      # 4i.  empty set term
      for(s in 1:length(v)) {          # 4ii. all other terms
        if(as.numeric(intToBits(s))[i] == 0) {  #
          # 4iii.if i is not in set s
          S <- sum(as.numeric(intToBits(s)))    # 
          # 4iv. S is cardinality of s
          m <- (factorial(n-S-1)*factorial(S)/factorial(n))  # 
          # 4v. calculate multiplier 
          vSi <- v[s+2^(i-1)]          # 4vi. f-measure of s and i
          vS <- v[s]                   # 4vii. f-measure of s
          shap[i]<-shap[i]+m*(vSi-vS)  # 4viii. add term
        }                            #
      }                              #
    }                                #
    shap                               # 5. return shapley indices
  }                                  #    vector as output
  
  orness.v <- function(v) {     # 1. the input is a fuzzy measure
    n <- log(length(v)+1,2)       # 2. calculates n based on |v|
    m <- array(0,length(v))       # 3. empty array for multipliers
    for(i in 1:(length(v)-1)) {   # 4. S is the cardinality of 
      S <- sum(as.numeric(intToBits(i))) #    of the subset at v[i]
      m[i] <- factorial(n-S)*factorial(S)/factorial(n)  #
    }                             #
    sum(v*m)/(n-1)}                # 5. orness calculation
  
  
  somestats <- rbind(c("RMSE",RMSE),c("Av. abs error",av.l1error),c("Pearson Correlation",cor(new.yvals,the.data[,ycol])),c("Spearman Correlation",cor(new.yvals,the.data[,ycol],method="spearman")),c("Orness",orness.v(fm.weights.v[2:(2^n)])),c("i","Shapley i"),cbind(1:n,shapley(fm.weights.v[2:(2^n)])),c("binary number","fm.weights"),cbind(1:(2^n-1),fm.weights.v[2:(2^n)]))
  #card2 <- card
  #for(i in 1:nrow(card2)) for(j in 1:ncol(card2)) {if(card2[i,j]==0) card2[i,j]<- "" }
  #somestats <- cbind(somestats,rbind(array("",c(2,n)),c("sets",array("",(n-1))),card2[,1:n]))
  
  
  
  write.table(somestats,stats.1,quote = FALSE,row.names=FALSE,col.names=FALSE)	
}







