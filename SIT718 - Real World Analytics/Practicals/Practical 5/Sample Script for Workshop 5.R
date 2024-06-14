## Weighted arithmetic means
WAM <- function(x,w) {
  sum(w*x)
}


WAM2 <- function(x,w) {
  w <- w/sum(w)
  sum(w*x)
}

WAM(c(3,4,2,6),c(0.3,0.2,0.4,0.8))
WAM2(c(3,4,2,6),c(0.3,0.2,0.4,0.8))


## Weighted power means

WPM <- function(x,w,p=2) { # 1. pre-defining the inputs
#  w <- w/sum(w)  # normalise weights
  if(p == 0) {prod(x^w)} # 2. weighted geometric mean if p=0
  else {sum(w*(x^p))^(1/p)} # 3. our calculation which will also
} # be the output

WPM(c(3,4,2,6),c(0.3,0.2,0.4,0.8),2)


## Weighted median

Wmed <- function(x,w) { # 1. function inputs
  w <- w/sum(w) # 2. normalise weights
  n <- length(x)
  w <- w[order(x)] # 3. sort weights by inputs
  x <- sort(x) # 4. sort inputs
  out <- x[1] # 5. set starting value
  for(i in 1:(n-1)) { # 6. for each i, we check
    if(sum(w[1:i]) < 0.5) out <- x[i+1] # to see if the weights
  } # are still below 50%,
  out # once they're not, we stop
} # updating the output


Wmed(c(3,4,2,6),c(0.3,0.2,0.4,0.8))


## Borda counts: Example for Weekly Resource 5.9 Borda Count


Borda <- function(x,w) {                        # 1. function inputs
  total.scores <- array(0,nrow(x))              # 2. vector to hold final scores
  for(j in 1:ncol(x)) {                         # 3. convert each column to ranks
    x[,j] <- rank(-x[,j])                       # Using negation to get the descending order
  }
  y <- x-x                                       # initiate score matrix
  for(i in 1:length(w)) {                       # 4. convert all of the ranks to the w scores
    y[x==i] <- w[i]
  }
  for(i in 1:nrow(y)) {                         # 5. add the scores for each candidate
    total.scores[i] <- sum(y[i,])
  }
  total.scores
}

x=rbind(c(9,6,4),c(7,7,6),c(4,8,8))
w=c(2,1,0)
Borda(x,w)

## OWA operator

WAM <- function(x,w) {sum(w*x)}

OWA <- function(x,w=array(1/length(x),length(x)) ) {
  w <- w/sum(w)
  sum(w*sort(x))
}

WAM(c(3,4,2,6),c(0.3,0.2,0.4,0.8))
OWA(c(3,4,2,6),c(0.3,0.2,0.4,0.8))


mean(c(36,4,2,6,3,22,12,31,42,7,9),trim=0.1)


Wins.mean <- function(x,h=0) { # 1. pre-defining the inputs
  n <- length(x) # 2. store the length of x
  repl <- floor(h*n) # 3. how many data to replace
  x <- sort(x) # 4. sort x
  x[1:repl] <- x[repl+1] # 5. replace lower values
  x[(n-repl+1):n] <- x[n-repl] # 6. replace upper values
  mean(x) # 7. calculate the mean
}

Wins.mean(c(36,4,2,6,3,22,12,31,42,7,9),0.1)


## Choquet integral

Choquet <- function(x,v) { # 1. pre-defining the inputs
  n <- length(x) # 2. store the length of x
  w <- array(0,n) # 3. create an empty weight vector
  for(i in 1:(n-1)) { # 4. define weights based on order
    v1 <- v[sum(2^(order(x)[i:n]-1))] #
    # 4i. v1 is f-measure of set of all
    # elements greater or equal to
    # i-th smallest input.
    v2 <- v[sum(2^(order(x)[(i+1):n]-1))] #
    # 4ii. v2 is same as v1 except
    # without i-th smallest
    w[i] <- v1 - v2 # 4iii. subtract to obtain w[i]
  } #
  w[n] <- 1- sum(w) # 4iv. final weight leftover
  x <- sort(x) # 5. sort our vector
  sum(w*x) # 6. calculate as we would WAM
}


Choquet(c(0.3,0.8),c(0.3,0.7,1)) # We don't need to input the first empty set for V

## Orness


orness <- function(w) { # 1. the input is a weighting vector
  n <- length(w) # 2. store the length of w
  sum(w*(1:n-1)/(n-1)) # 3. orness calculation
}

orness(c(0.3,0.5,0.1,0.1))

orness(c(0,0,0,0,1))

orness(c(1,0,0,0,0))




orness.v <- function(v) { # 1. the input is a fuzzy measure
  n <- log(length(v)+1,2) # 2. calculates n based on |v|
  m <- array(0,length(v)) # 3. empty array for multipliers
  for(i in 1:(length(v)-1)) { # 4. S is the cardinality of
    S <- sum(as.numeric(intToBits(i))) # of the subset at v[i]
    m[i] <- factorial(n-S)*factorial(S)/factorial(n) #
  } #
  sum(v*m)/(n-1) # 5. orness calculation
}

orness.v(c(0.4,0.7,1))


## Shapley values

shapley <- function(v) { # 1. the input is a fuzzy measure
  n <- log(length(v)+1,2) # 2. calculates n based on |v|
  shap <- array(0,n) # 3. empty array for Shapley values
  for(i in 1:n) { # 4. Shapley index calculation
    shap[i] <- v[2^(i-1)]*factorial(n-1)/factorial(n) #
    # 4i. empty set term
    for(s in 1:length(v)) { # 4ii. all other terms
      if(as.numeric(intToBits(s))[i] == 0) { #
        # 4iii.if i is not in set s
        S <- sum(as.numeric(intToBits(s))) #
        # 4iv. S is cardinality of s
        m <- (factorial(n-S-1)*factorial(S)/factorial(n)) #
        # 4v. calculate multiplier
        vSi <- v[s+2^(i-1)] # 4vi. f-measure of s and i
        vS <- v[s] # 4vii. f-measure of s
        shap[i]<-shap[i]+m*(vSi-vS) # 4viii. add term
      } #
    } #
  } #
  shap # 5. return shapley indices
} # vector as output

# We don't need to input the first empty set for V
shapley(c(0.4,0.7,1))   # 2 variables need 2^2-1=3 inputs; 3 variables need 2^3-1=7 inputs

Choquet(c(0.3,0.8),c(0.3,0.5,1))
WAM2(c(0.3,0.8),shapley(c(0.3,0.5,1)))

# Choquet integral beomes the WAM as special case
Choquet(c(0.3,0.8),c(0.5,0.5,1))
WAM2(c(0.3,0.8),shapley(c(0.5,0.5,1)))
