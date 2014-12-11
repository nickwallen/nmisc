
#'
#' Expression Cache
#'
#' Caches the result of long-running expressions to avoid unnecessary 
#' re-execution.  The function will return the cached result of the 
#' expression if one exists.  Otherwise the function will execute the 
#' expression, cache the result and then return it.  
#' 
#' A checksum of an expression's source code, excluding white space,
#' is used to generate a unique identitifier to identify the cached expression.
#' The cache will be invalidated if the source code within the expression 
#' itself changes.
#'
#' @export
#'
#' @param expr The expression to cache.
#' @param key [Optional] The key to cache the expression under.  In most cases, this
#' argument is not necessary.
#' @param clear_cache Should all cached objects be deleted?
#' @param cache_dir The directory containing the cache.  This should either be an 
#' absolute path or relative to the current working directory.
#' @param verbose Is more verbose output needed?
#' @return The expression's result either retrieved from cache or freshly calculated.
#' 
#' @examples
#' x <- ecache ({ 2 + 3 + 4 })
#' y <- ecache ({ Sys.sleep (2); 2 + 3 + 4})
#'
ecache <- function (expr, 
                    key = NULL, 
                    clear_cache = getOption ("clear_cache", default = FALSE), 
                    cache_dir = getOption ("cache_dir", default = ".Recache"),
                    verbose = getOption ("verbose", default = FALSE)) {
    
    stopifnot (is.character (key) | is.null (key))
    stopifnot (is.logical (clear_cache))
    stopifnot (is.character (cache_dir))
    stopifnot (is.logical (verbose))

    # does a unique key need to be calculated for the expression?
    if (is.null (key)) {

        # extract the source code of the expression
        code <- substitute (expr)
        
        # strip all whitespace, so whitespace changes do not impact cached values
        code <- gsub ("[[:blank:]]+", "", code)
        
        # generate a uuid based on the expression's source code
        key <- digest::digest (code)
    }

    # clear the cache, if asked to
    if (clear_cache) {
        unlink (cache_dir, recursive = TRUE, force = TRUE)
    }
    
    # connect to a local stash containing the cached objects
    stash <- new ("localDB", dir = cache_dir, name = cache_dir)

    # has the expression already been cached?
    if (stashR::dbExists (stash, key)) {
        
        if (verbose) message (sprintf ("loading from cache: %s @ %s", key, Sys.time()))
        
        # fetch the result from cache
        result <- unserialize (stashR::dbFetch (stash, key))
    
    } else {
        
        if (verbose) message (sprintf ("saving to cache: %s @ %s", key, Sys.time()))

        # evaluate the expression and cache the result
        result <- eval (parse (text=expr))
        stashR::dbInsert (stash, key = key, value = serialize (expr, NULL))
    }
    
    return (result)
}