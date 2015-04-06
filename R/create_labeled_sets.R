train <- read.csv("../data/kaggle_train.csv")
test <- read.csv("../data/test.csv")

make_one_col <- function(colmatrix)
{
    S <- ncol(colmatrix)
    n <- nrow(colmatrix)
    multiplier <- rep(1, n)
    for (i in 2:S)
    {
        multiplier <- cbind(multiplier, rep(i, n))
    }
    outmat <- colmatrix * multiplier
    apply(outmat, 1, sum)
}

# collapse soil
soilcols <- grep("^Soil", names(train))
train$Soil <- factor(make_one_col(as.matrix(train[ , soilcols])), levels = 1:40)
soilcols <- grep("^Soil", names(test))
test$Soil <- factor(make_one_col(as.matrix(test[ , soilcols])), levels = 1:40)

# collapse wilderness
wildcol <- grep("^Wilderness", names(train))
train$Wilderness <- factor(make_one_col(as.matrix(train[ , wildcol])), levels = 1:4)
wildcol <- grep("^Wilderness", names(test))
test$Wilderness <- factor(make_one_col(as.matrix(test[ , wildcol])), levels = 1:4)

# remove unnecessary columns
rmcols <- grep("(^X)|(^Wilderness_)|(^Soil_)", names(train))
train <- train[ , -rmcols]
rmcols <- grep("(^X)|(^Wilderness_)|(^Soil_)", names(test))
test <- test[ , -rmcols]

# make cover_type last column
idx <- which(names(train) == "Cover_Type")
jdx <- setdiff(1:length(names(train)), idx)
train <- train[c(jdx, idx)]

# Split train into train and validate
trainidx <- sample(1:nrow(train), floor(0.60 * nrow(train)), replace = FALSE)
validateidx <- setdiff(1:nrow(train), trainidx)

training_set <- train[trainidx, ]
validation_set <- train[validateidx, ]

write.csv(training_set, file = "../data/collapse_train.csv", row.names = FALSE)
write.csv(validation_set, file = "../data/collapse_validation.csv", row.names = FALSE)

write.csv(test, file = "../data/collapse_test.csv", row.names = FALSE)
