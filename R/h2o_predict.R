h2o_predict <- function(h2omodel, h2odata)
{
    library(h2o)
    prediction <- as.data.frame(h2o.predict(h2omodel, h2odata)$predict)
    prediction$Id <- as.numeric(as.data.frame(h2odata$Id)[[1]])
    names(prediction)[names(prediction) == "predict"] <- "Cover_Type"
    prediction[c("Id", "Cover_Type")]
}


