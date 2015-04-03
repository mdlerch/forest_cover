consensus <- function(fits, w, categories = 7)
{
    N <- length(fits)
    n <- length(fits[[1]])
    bigtable <- matrix(0, nrow = n, ncol = categories)
    for (i in 1:N)
    {
        bigtable[1:n + (fits[[i]] - 1) * n] <-
            bigtable[1:n + (fits[[i]] - 1) * n] + w[[i]]
    }
    apply(bigtable, 1, function(x) which(x == max(x)))
}
