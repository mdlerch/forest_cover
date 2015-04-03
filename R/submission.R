library(h2o)
h2oserver <- h2o.init(nthreads = -1)
source("./model_h2o_rf.R")
source("./model_h2o_gbm.R")
source("./model_h2o_deep.R")

h2ovalidate <- as.h2o(h2oserver, validate <- read.csv("../data/our_validation.csv"))

source("./evaluate.R")
source("./h2o_predict.R")
weights <- evaluate(h2o_predict(rf_fit, h2ovalidate), validate)
weights <- c(weights, evaluate(h2o_predict(gbm_fit, h2ovalidate), validate))
weights <- c(weights, evaluate(h2o_predict(deep_fit, h2ovalidate), validate))

h2otest <- as.h2o(h2oserver, test <- read.csv("../data/test.csv"))
fits <- list()
fits[[1]] <- h2o_predict(rf_fit, h2otest)$Cover_Type
fits[[2]] <- h2o_predict(gbm_fit, h2otest)$Cover_Type
fits[[3]] <- h2o_predict(deep_fit, h2otest)$Cover_Type

source("./consensus.R")
consensus_picks <- data.frame(Id = test$Id)
consensus_picks$Cover_Type <- consensus(fits, weights)

write.csv(consensus_picks, file = "submission2.csv", row.names = FALSE)
