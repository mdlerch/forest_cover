y <- which(names(train) == "Cover_Type")
x <- 3:(y - 1)

model_deep_naive <- h2o.deeplearning(x = x, y = y, data = h2otrain)
