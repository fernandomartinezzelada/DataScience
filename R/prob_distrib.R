?hist()
?dnorm()

rm(x)

set.seed(123) # Semilla para generar númeos aleatorios
x <- rnorm(100) # variable X
e <- rnorm(100, sd = .5) # error aleatorio

pnorm(160, mean = 171.8, sd = 5)

qnorm(.009, mean = 171.8, sd = 5)

dnorm(x, mean = 171.8, sd = 5)

curve(dnorm(x, mean = 171.8, sd = 5), add = T, col = "red" )

?ntile()

x <- c(5, 1, 3, 2, 2, NA)

dplyr::ntile(x, 2)

dplyr::ntile(x, 4)

y <- c(1,2,3,4,5)

dplyr::ntile(desc(y), 5)


w<-1:length(x)

options(repr.plot.width=16, repr.plot.height=9)
plot(data.frame(w=w,x=x,e=e))

?IQR()
