input <- read.csv("../data/kaggle_train.csv")
testset <- read.csv("../data/test.csv")

table(input$Cover_Type)
table(testset$Cover_Type)

trainidx <- sample(1:nrow(input), floor(0.60 * nrow(input)), replace = FALSE)

validateidx <- setdiff(1:nrow(input), trainidx)

training_set <- input[trainidx, ]
validation_set <- input[validateidx, ]

write.csv(training_set, file = "../data/our_train.csv")
write.csv(validation_set, file = "../data/our_validation.csv")


