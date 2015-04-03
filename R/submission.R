library(h2o)
h2oserver <- h2o.init(nthreads = -1)

h2otrain <- as.h2o(h2oserver, train <- read.csv("../data/our_train.csv"), "train")
y <- which(names(train) == "Cover_Type")
x <- 3:(y - 1)
model_rf <- h2o.randomForest(x = x, y = y, data = h2otrain)
model_gbm <- h2o.gbm(x = x, y = y, data = h2otrain)
model_deep <- h2o.deeplearning(x = x, y = y, data = h2otrain)

h2ovalidate <- as.h2o(h2oserver, validate <- read.csv("../data/our_validation.csv"))

source("./evaluate.R")
source("./h2o_predict.R")
weights <- evaluate(h2o_predict(model_rf, h2ovalidate), validate)
weights <- c(weights, evaluate(h2o_predict(model_gbm, h2ovalidate), validate))
weights <- c(weights, evaluate(h2o_predict(model_deep, h2ovalidate), validate))

h2otest <- as.h2o(h2oserver, test <- read.csv("../data/test.csv"))
fits <- list()
fits[[1]] <- h2o_predict(model_rf, h2otest)$Cover_Type
fits[[2]] <- h2o_predict(model_gbm, h2otest)$Cover_Type
fits[[3]] <- h2o_predict(model_deep, h2otest)$Cover_Type

source("./consensus.R")
consensus_picks <- data.frame(Id = test$Id)
consensus_picks$Cover_Type <- consensus(fits, weights)

write.csv(consensus_picks, file = "submission2.csv", row.names = FALSE)
