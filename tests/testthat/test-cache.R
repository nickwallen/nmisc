library (nmisc)
context ("Cache")

test_that ("clear all cached values", {
    cache ({}, clear_cache = TRUE)
})

test_that ("cache expression", {

    # cache the value of an expression
    transient <- 1
    expect_equal (1001, cache ({transient + 1000}))
    
    # removing 'transient' ensures that the expression result is pulled from cache
    rm (transient)
    expect_equal (1001, cache ({transient + 1000}))
    
    # after clearing the cachce, the expression can no longer be calculated
    expect_error (cache ({transient + 1000}, clear_cache = TRUE))
})


