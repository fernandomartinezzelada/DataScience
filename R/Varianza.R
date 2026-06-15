var(c(1,2,3))
var(c(1,2))
var(c(1))

x1 <- rnorm(5, mean = 5, sd = 0)        #c(5,5,5,5,5)
x2 <- c(1,5,13,5,1) #rnorm(5, mean = 5, sd = 4.898979)
x3 <- c(1,1,21,1,1) #rnorm(5, mean = 5, sd = 8.944272)

x1
x2
x3

mean(x1)
mean(x2)
mean(x3)

#var(x1)
#var(x2)
#var(x3)

sd(x1)
sd(x2)
sd(x3)

#((1-5)*(1-5)+(1-5)*(1-5)+(1-5)*(1-5)+(1-5)*(1-5)+(21-5)*(21-5))/4

hist(x1)
curve(dnorm(x, mean = 5, sd = 0), add = T, col = "red" )

hist(x2)
curve(dnorm(x, mean = 5, sd = 4.898979), add = T, col = "red" )

hist(x3)
curve(dnorm(x, mean = 5, sd = 8.944272), add = T, col = "red" )

p<-.9
q<-qnorm(p, mean = 5, sd = 0)
q
p<-pnorm(q, mean = 5, sd = 0)
p
