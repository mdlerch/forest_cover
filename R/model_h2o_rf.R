library(h2o)

h2oserver <- h2o.init()
h2otrain <- as.h2o(h2oserver, train <- read.csv("../data/our_train.csv"), "train")
h2ovalidate <- as.h2o(h2oserver, validate <- read.csv("../data/our_validation.csv"), "validate")

y <- which(names(train) == "Cover_Type")
x <- 3:(y-1)

rf_fit <- h2o.randomForest(x = x, y = y, data = h2otrain)
