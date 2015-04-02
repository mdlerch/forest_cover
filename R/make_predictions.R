source("./model_h2o_rf.R")
source("./model_h2o_deep.R")
source("./model_h2o_gbm.R")

source("./consensus.R")

fits <- list(deep_pred$Cover_Type, rf_pred$Cover_Type, gbm_pred$Cover_Type)
weights <- c(0.75, 0.85, 0.75)

consensus_pics <- data.frame(Id = deep_pred$Id)
consensus_pics$Cover_Type <- consensus(fits, weights)
evaluate(consensus_pics)
