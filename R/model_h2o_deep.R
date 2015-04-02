library(h2o)

h2oserver <- h2o.init()
h2otrain <- as.h2o(h2oserver, train <- read.csv("../data/our_train.csv"), "train")
h2ovalidate <- as.h2o(h2oserver, validate <- read.csv("../data/our_validation.csv"), "validate")

y <- which(names(train) == "Cover_Type")
x <- 3:(y-1)

deep_fit <- h2o.deeplearning(x = x, y = y, data = h2otrain)

deep_pred <- as.data.frame(h2o.predict(deep_fit, h2ovalidate)$predict)
deep_pred$Id <- validate$Id
names(deep_pred)[names(deep_pred) == "predict"] <- "Cover_Type"

source("./evaluate.R")
evaluate(deep_pred)
