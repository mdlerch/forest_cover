hist <- function(x, ...) { graphics::hist(x, breaks = 100, ...) }

train <- read.csv("../data/collapse_train.csv")
validate <- read.csv("../data/collapse_validation.csv")

names(train)

###############################
## Better measure for Aspect ##
###############################

# Aspect is measured between 0 and 360.  Most likely 0==due north, 180==due
# south.  Try to remeasure the aspect as something that makes 0 and 360 very
# similar and also consider introducing an indicator if aspect is northerly.

hist(train$Aspect)
boxplot(Aspect ~ Cover_Type, train)

# Some of those 0's might be fake

# Let's take 0 and 360 to 0 and 180 to 1.
# We can do this with sin(.5*x)
train$Aspect2 <- sin(train$Aspect * pi / 180 / 2)
train$Northerly <- factor(train$Aspect2 < sin(90 * pi / 180 / 2))

hist(train$Aspect2)
boxplot(Aspect2 ~ Cover_Type, train)

table(train$Northerly, train$Cover_Type)



train <- train[c(1:13, 15, 16, 14)]

h2otrain <- as.h2o(h2oserver, train)

source("./model_rf_naive.R")

model_rf_naive





for (i in nonsoil)
{
    plot(train$Cover_Type ~ train[[i]], col = train$Cover_Type)
    readline()
}

hist(train$Elevation)
hist(train$Aspect)

summary(lm1 <- lm(Hillshade_3pm ~ Slope + Hillshade_Noon + Hillshade_9am,
           subset(train, Hillshade_3pm != 0)))

impute <- predict(lm1, subset(train, Hillshade_3pm == 0))
impute[impute < 0] <- 0
train$Hillshade_3pm[as.numeric(names(impute))] <- impute
impute <- predict(lm1, subset(validate, Hillshade_3pm == 0))
impute[impute < 0] <- 0
validate$Hillshade_3pm[as.numeric(names(impute))] <- impute

hist(train$Aspect)
sum(train$Aspect == 0)

train$Aspect2 <- sin(train$Aspect * pi / 180)
validate$Aspect2 <- sin(validate$Aspect * pi / 180)
hist(train$Aspect2)

hist(train$Hillshade_3pm)
hist(train$Hillshade_9am)
hist(train$Hillshade_Noon)

with(train, plot(Cover_Type ~ Horizontal_Distance_To_Fire_Points, col = Cover_Type, pch = 19))

library(h2o)
h2oserver <- h2o.init()
h2otrain <- as.h2o(h2oserver, train)

y <- which(names(train) == "Cover_Type")
x <- c(3, 5:(y - 1), y+1)

model_rf_naive <- h2o.randomForest(x = x, y = y, data = h2otrain)
source("./evaluate.R")
source("./h2o_predict.R")
h2ovalidate <- as.h2o(h2oserver, validate)
evaluate(h2o_predict(model_rf_naive, h2ovalidate), validate)

