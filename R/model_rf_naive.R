y <- which(names(train) == "Cover_Type")
x <- 2:(y - 1)

model_rf_naive <- h2o.randomForest(x = x, y = y, data = h2otrain)
