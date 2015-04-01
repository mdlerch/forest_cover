library(h2o)

h2oserver <- h2o.init()
h2otrain <- as.h2o(h2oserver, train <- read.csv("../data/our_train.csv"), "train")
h2ovalidate <- as.h2o(h2oserver, validate <- read.csv("../data/our_validation.csv"), "validate")

y <- which(names(train) == "Cover_Type")
x <- 3:(y-1)

plot(train$Soil_Type1)

RF_fit <- h2o.randomForest(x = x, y = y, data = h2otrain)

RF_pred <- as.data.frame(h2o.predict(RF_fit, h2ovalidate)$predict)
RF_pred$Id <- validate$Id
names(RF_pred)[names(RF_pred) == "predict"] <- "Cover_Type"

source("./evaluate.R")
evaluate(RF_pred)
