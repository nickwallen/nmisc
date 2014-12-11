library (nmisc)
context ("ecache")

test_that ("clear all ecached values", {
    ecache ({}, clear_cache = TRUE)
})

test_that ("basic expression caching", {

    # ecache the value of an expression
    transient <- 1
    expect_equal (1001, ecache ({transient + 1000}))
    
    # remove 'transient' so that the expression can no longer be evaluated
    rm (transient)
    
    # the expression result must now be pulled from the ecache
    expect_equal (1001, ecache ({transient + 1000}))
    
    # the expression has changed and the cache is no longer valid for this expression
    expect_error (ecache ({transient + 1001}))
    
    # after clearing the cachce, the expression can no longer be calculated
    expect_error (ecache ({transient + 1000}, clear_cache = TRUE))
})

test_that ("keyed expression caching", {
    
    ecache ({1}, key = "data")
    
    # even though the expression changed, a specific key has been provided
    expect_equal (1, ecache ({10}, key = "data"))
    
})

