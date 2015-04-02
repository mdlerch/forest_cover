library(h2o)

h2oserver <- h2o.init()
h2otrain <- as.h2o(h2oserver, train <- read.csv("../data/our_train.csv"), "train")
h2ovalidate <- as.h2o(h2oserver, validate <- read.csv("../data/our_validation.csv"), "validate")

y <- which(names(train) == "Cover_Type")
x <- 3:(y-1)

gbm_fit <- h2o.gbm(x = x, y = y, data = h2otrain)

gbm_pred <- as.data.frame(h2o.predict(gbm_fit, h2ovalidate)$predict)
gbm_pred$Id <- validate$Id
names(gbm_pred)[names(gbm_pred) == "predict"] <- "Cover_Type"

source("./evaluate.R")
evaluate(gbm_pred)
