y <- which(names(train) == "Cover_Type")
x <- 3:(y - 1)

model_gbm_naive <- h2o.gbm(x = x, y = y, data = h2otrain)
