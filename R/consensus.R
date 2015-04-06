consensus <- function(predictions, w)
{
    link <- function(x) { x }
    # number of models
    N <- length(predictions)
    # number of observations
    n <- nrow(predictions[[1]])
    categories <- ncol(predictions[[1]])
    columns <- names(predictions[[1]])
    cols <- is.element(columns, c("X1", "X2", "X3", "X4", "X5", "X6", "X7"))
    bigtable <- as.matrix(predictions[[1]][ , cols])
    for (i in 2:N)
    {
        bigtable <- bigtable + w[[i]] * link(predictions[[i]][ , cols])
    }
    apply(bigtable, 1, function(x) which(x == max(x)))
}
