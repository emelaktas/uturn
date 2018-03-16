# setwd("~/Library/Mobile Documents/com~apple~CloudDocs/backup/...")

# Normally, you would read external data
# data <- read.table(file = "NumDeliveries_v2.txt", header = T)

# For reproducibility
set.seed(1234)

# randomly simulating data so the code is standalone.

data <- rpois(500, lambda = 10) 

length(data)
head(data)

pdf(file = "Histogram of VARIABLE.pdf")
hist(data, main = "Histogram of ...", xlab = "Number of ...")
dev.off()

### PROB DIST FITTING ###
library(fitdistrplus)

# Assign data (this makes sense when data has more than one variable)
data <- data

# Try Catch is used to fit theoretical probability distributions over many data sets without stopping at errors.

# Fit beta
fb <- tryCatch(fitdist(data, "beta"), message = "errr", msg= "", error = function(e) FALSE )

# Fit cauchy
fc <- tryCatch(fitdist(data, "cauchy"), message = "errr", msg= "", error = function(e) FALSE )

# Fit chi-squared
fcsq <- tryCatch(fitdist(data, "chi-squared"), message = "errr", msg= "", error = function(e) FALSE )

# Fit exponential
fe <- tryCatch(fitdist(data, "exp"), message = "errr", msg= "", error = function(e) FALSE )

# Fit F
ff <- tryCatch(fitdist(data, "f"), message = "errr", msg= "", error = function(e) FALSE )

# Fit gamma
fg <- tryCatch(fitdist(data, "gamma"), error = function(e) FALSE)

# Fit geometric
fgeo <- tryCatch(fitdist(data, "geometric"), error = function(e) FALSE)

# Fit lognormal
flogn <- tryCatch(fitdist(data, "lnorm"), error = function(e) FALSE )

# Fit logistic
flogis <- tryCatch(fitdist(data, "logis"), message = "errr", msg= "", error = function(e) FALSE )

# Fit negative binomial
fneg <- tryCatch(fitdist(data, "nbinom"), error = function(e) FALSE)

# Fit normal
fn <- tryCatch(fitdist(data, "norm"), error = function(e) FALSE)

# Fit Poisson
fp <- tryCatch(fitdist(data, "pois"), error = function(e) FALSE)

# Fit t
ft <- tryCatch(fitdist(data, "t"), error = function(e) FALSE)

# Fit Weibull
fw <- tryCatch(fitdist(data, "weibull"), error = function(e) FALSE)
 
# check which fit distributions worked - this is useful when it is not possible to fit any probability distribution
classFitDist <- c(class(fb), class(fc), class(fcsq), class(fe), class(ff), class(fg), class(fgeo), class(flogn), class(flogis), class(fneg), class(fn), class(fp), class(ft), class(fw))

# Distributions which will enter into Goodness of Fit check
DistributionsToConsider <- classFitDist == "fitdist"
 
# Check goodness of fit
goodnessoffit <- gofstat(list(fb, fc, fcsq, fe, ff, fg, fgeo, flogn, flogis, fneg, fn, fp, ft, fw)[DistributionsToConsider],  fitnames = c("beta", "cauchy", "chi-squared", "exp", "f", "gamma", "geometric", "lnorm", "logis", "nbinom", "norm", "pois", "t","weibull")[DistributionsToConsider])


# Assign best fit theoretical dist
BestFit <- names(which(goodnessoffit$aic == min(goodnessoffit$aic)))

# Names of distributions tested
distNames <- c("beta", "cauchy", "chi-squared", "exp", "f", "gamma", "geometric", "lnorm", "logis", "nbinom", "norm", "pois", "t","weibull")

distToDraw <- which(distNames == BestFit)

# Distributions tested
distributions <- c("fb", "fc", "fcsq", "fe", "ff", "fg", "fgeo", "flogn", "flogis", "fneg", "fn", "fp", "ft", "fw")


# Check that logic of finding the min AIC brings the right dist
distributions[distToDraw]

# Draw fit graphs
pdf("FitPlots.pdf",)
par(mfrow = c(2,2))

denscomp(eval(parse(text=distributions[distToDraw])), legendtext=distNames[distToDraw], xlab=round(eval(parse(text=distributions[distToDraw]))$estimate, 3))

qqcomp(eval(parse(text=distributions[distToDraw])), legendtext=distNames[distToDraw])
cdfcomp(eval(parse(text=distributions[distToDraw])), legendtext=distNames[distToDraw])
ppcomp(eval(parse(text=distributions[distToDraw])), legendtext=distNames[distToDraw])
dev.off()
