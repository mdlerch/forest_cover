source("./model_h2o_rf.R")

h2otest <- as.h2o(h2oserver, test <- read.csv("../data/test.csv"), "test")

rf_test_pred <- as.data.frame(h2o.predict(rf_fit, h2otest)$predict)
rf_test_pred$Id <- test$Id
names(rf_test_pred)[names(rf_test_pred) == "predict"] <- "Cover_Type"

write.csv(rf_test_pred[c("Id", "Cover_Type")], file = "submission1.csv", row.names = FALSE)
