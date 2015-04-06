# 0. Specify the models comprising the submission
models <- list("model_rf_naive", "model_gbm_naive", "model_deep_naive")

# 1. Setup: load packages and data
library(h2o)
h2oserver <- h2o.init(nthreads = -1)
h2otrain <- as.h2o(h2oserver, train <- read.csv("../data/collapse_train.csv"), "train")
h2ovalidate <- as.h2o(h2oserver, validate <- read.csv("../data/collapse_validation.csv"))
h2otest <- as.h2o(h2oserver, test <- read.csv("../data/collapse_test.csv"))

# 2. Obtain model fits
lapply(models, function(x) { source(paste0(x, ".R")) })

# 3. Obtain model weights
source("./evaluate.R")
source("./h2o_predict.R")
weights <- lapply(models, function(x) {
    evaluate(h2o_predict(eval(parse(text = x)), h2ovalidate), validate) })

# 4. Take consensus of model picks
predictions <- lapply(models, function(x) {
    h2o_predict(eval(parse(text = x)), h2otest) })

source("./consensus.R")
consensus_picks <- data.frame(Id = test$Id)
consensus_picks$Cover_Type <- consensus(fits, weights)

# 5. Write to file
submit <- paste0("../data/submission_", format(Sys.time(), "%m-%d-%H-%M", ".csv"))
write.csv(consensus_picks, file = submit, row.names = FALSE)
