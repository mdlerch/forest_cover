evaluate <- function(pred, truth = validate)
{
    ncorrect <- 0
    for (i in 1:nrow(pred))
    {
        ncorrect <- ncorrect + as.numeric(
            (truth$Cover_Type[truth$Id == pred$Id[i]]) == pred$Cover_Type[i]
            )
    }
    ncorrect / nrow(pred)
}
