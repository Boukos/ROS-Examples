#' ---
#' title: "Regression and Other Stories: Introclass"
#' author: "Andrew Gelman, Jennifer Hill, Aki Vehtari"
#' date: "`r format(Sys.Date())`"
#' output:
#'   html_document:
#'     theme: readable
#'     toc: true
#'     toc_depth: 2
#'     toc_float: true
#'     code_download: true
#' ---

#' Plot residuals vs.\ predicted values, or residuals vs.\ observed
#' values? See Chapter 11 in Regression and Other Stories.
#' 
#' -------------
#' 

#+ setup, include=FALSE
knitr::opts_chunk$set(message=FALSE, error=FALSE, warning=FALSE, comment=NA)
# switch this to TRUE to save figures in separate files
savefigs <- FALSE

#' #### Load packages
library("rprojroot")
root<-has_dirname("ROS-Examples")$make_fix_file()
library("rstanarm")

#' #### Load data
introclass <- read.table(root("Introclass/data","gradesW4315.dat"), header=TRUE)
head(introclass)

#' ## Linear regression model
#' 
#' The option `refresh = 0` supresses the default Stan sampling
#' progress output. This is useful for small data with fast
#' computation. For more complex models and bigger data, it can be
#' useful to see the progress.
fit_1 <- stan_glm(final ~ midterm, data = introclass, refresh = 0)
print(fit_1)

#' #### Compute residuals<br>
#' compute predictions from simulations
sims <- as.matrix(fit_1)
predicted <- colMeans(sims[,1] + sims[,2] %*% t(introclass$midterm))
#' or with built-in function
predicted <- predict(fit_1)
resid <- introclass$final - predicted

#' #### Plot residuals vs predicted
#+ eval=FALSE, include=FALSE
if (savefigs) postscript(root("Introclass/figs","fakeresid1a.ps"), height=3.8, width=4.5, colormodel="gray")
#+
plot(predicted, resid, xlab="predicted value", ylab="residual",
     main="Residuals vs.\ predicted values", mgp=c(1.5,.5,0), pch=20, yaxt="n")
axis(2, seq(-40,40,20), mgp=c(1.5,.5,0))
abline(0, 0, col="gray", lwd=.5)
#+ eval=FALSE, include=FALSE
if (savefigs) dev.off()

#' #### Plot residuals vs observed
#+ eval=FALSE, include=FALSE
if (savefigs) postscript(root("Introclass/figs","fakeresid1b.ps"), height=3.8, width=4.5, colormodel="gray")
#+
plot(introclass$final, resid, xlab="observed value", ylab="residual", main="Residuals vs.\ observed values", mgp=c(1.5,.5,0), pch=20, yaxt="n")
axis(2, seq(-40,40,20), mgp=c(1.5,.5,0))
abline(0, 0, col="gray", lwd=.5)
#+ eval=FALSE, include=FALSE
if (savefigs) dev.off()

#' ## Simulated fake data
a <- 65
b <- 0.7
sigma <- 15
n <- nrow(introclass)
introclass$final_fake <- a + b*introclass$midterm + rnorm(n, 0, 15)
fit_fake <- stan_glm(final_fake ~ midterm, data = introclass, refresh = 0)

#' #### Compute residuals
#' compute predictions from simulations
sims <- as.matrix(fit_fake)
predicted_fake <- colMeans(sims[,1] + sims[,2] %*% t(introclass$midterm))
#' or with built-in function
predicted_fake <- predict(fit_fake)
resid_fake <- introclass$final_fake - predicted_fake

#' #### Plot residuals vs predicted
#+ eval=FALSE, include=FALSE
if (savefigs) postscript(root("Introclass/figs","fakeresid2a.ps"), height=3.8, width=4.5, colormodel="gray")
#+
plot(predicted_fake, resid_fake, xlab="predicted value", ylab="residual", main="Fake data:  resids vs.\ predicted", mgp=c(1.5,.5,0), pch=20, yaxt="n")
axis(2, seq(-40,40,20), mgp=c(1.5,.5,0))
abline(0, 0, col="gray", lwd=.5)
#+ eval=FALSE, include=FALSE
if (savefigs) dev.off()

#' #### Plot residuals vs observed
#+ eval=FALSE, include=FALSE
if (savefigs) postscript(root("Introclass/figs","fakeresid2b.ps"), height=3.8, width=4.5, colormodel="gray")
#+
plot(introclass$final_fake, resid_fake, xlab="observed value", ylab="residual", main="Fake data:  resids vs.\ observed", mgp=c(1.5,.5,0), pch=20, yaxt="n")
axis(2, seq(-40,40,20), mgp=c(1.5,.5,0))
abline(0, 0, col="gray", lwd=.5)
#+ eval=FALSE, include=FALSE
if (savefigs) dev.off()
