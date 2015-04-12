hist <- function(x, ...) { graphics::hist(x, breaks = 100, ...) }

train <- read.csv("../data/collapse_train.csv")
validate <- read.csv("../data/collapse_validation.csv")

names(train)

###############################
## Setup h2o for comparisons ##
###############################

library(h2o)
h2oserver <- h2o.init()

h2otrain <- as.h2o(h2oserver, train)
source("./model_rf_naive.R")
model_rf_naive
# error rate: 0.1430577

###########################################################################
##                       Better measure for aspect                       ##
###########################################################################


# Aspect is measured between 0 and 360.  Most likely 0==due north, 180==due
# south.  Try to remeasure the aspect as something that makes 0 and 360 very
# similar and also consider introducing an indicator if aspect is northerly.

hist(train$Aspect)
boxplot(Aspect ~ Cover_Type, train)

# Some of those 0's might be fake

####################
## Change dataset ##
####################
# Let's take 0 and 360 to 0 and 180 to 1.
# We can do this with sin(.5*x)
train$Aspect2 <- sin(train$Aspect * pi / 180 / 2)
train$Northerly <- factor(train$Aspect2 < sin(90 * pi / 180 / 2))

hist(train$Aspect2)
boxplot(Aspect2 ~ Cover_Type, train)

table(train$Northerly, train$Cover_Type)

###################
## Change datset ##
###################
# Make cover type last variable
train <- train[c(1:13, 15, 16, 14)]

##########
## test ##
##########
h2otrain <- as.h2o(h2oserver, train)
source("./model_rf_naive.R")
model_rf_naive
# error rate: 0.1436286 (essentially the same)

#################################
## Impute values for hillshade ##
#################################

Hillshade_o <- train$Hillshade_3pm

with(train, plot(y = Hillshade_o, x = Hillshade_9am, col = Cover_Type))
with(train, plot(y = Hillshade_o, x = (max(Hillshade_9am) - Hillshade_9am)^.5, col = Cover_Type))
abline(lm(Hillshade_o ~ I((max(train$Hillshade_9am) - train$Hillshade_9am)^.5)))

with(train, plot(y = Hillshade_o, x = Hillshade_Noon, col = Cover_Type))
with(train, plot(y = Hillshade_o, x = Hillshade_Noon^2, col = Cover_Type))
abline(lm(Hillshade_o ~ I(train$Hillshade_Noon^2)))

with(train, plot(y = Hillshade_o, x = Slope, col = Cover_Type))

# easiest to make variables
pred9am <- with(train, (max(Hillshade_9am) - Hillshade_9am) ^ 0.5)
predNoon <- train$Hillshade_Noon ^ 2
summary(lm1 <- lm(Hillshade_o ~ pred9am * predNoon))

train$Hillshade_3pm[Hillshade_o == 0] <- lm1$fitted.values[Hillshade_o == 0]

with(train, plot(y = Hillshade_3pm, x = Hillshade_9am, col = Cover_Type))
with(train, plot(y = Hillshade_3pm, x = (max(Hillshade_9am) - Hillshade_9am)^.5, col = Cover_Type))

with(train, plot(y = Hillshade_3pm, x = Hillshade_Noon, col = Cover_Type))
with(train, plot(y = Hillshade_3pm, x = Hillshade_Noon^2, col = Cover_Type))

source("./model_rf_naive.R")
model_rf_naive


