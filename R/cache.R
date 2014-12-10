
#'
#' Caches the result of long-running expressions to avoid unnecessary 
#' re-execution.  The result of the expression is either cached and returned
#' or returned directly from cache.  If the source code within the expression
#' changes, then the result will be automatically re-calculated.
#'
#' @export
#'
#' @param expr The expression whose result is cached.
#' @param verbose Is more verbose output needed?
#' @param clear_cache Should all of the cached objects be deleted?
#' @param cache_dir The directory containing the cached values.
#' @param cache_db The name of the stash/database used to cache the values.
#' @return The result of the expression either from cache or freshly computed.
#' 
#' @examples
#' cache ({ 2 + 3 + 4 })
#'
cache <- function (expr, verbose = FALSE, clear_cache = FALSE, cache_dir = ".Rcache", cache_db = ".nmisc.cache" ) {
    
    # extract the source code of the expression
    code <- substitute (expr)
    
    # strip all whitespace, so whitespace changes do not impact cached values
    code <- gsub ("[[:blank:]]+", "", code)
    
    # generate a uuid based on the expression's source code
    uuid <- digest::digest (code)

    # clear the cache, if asked to
    if (clear_cache) {
        unlink (cache_dir, recursive = TRUE, force = TRUE)
    }
    
    # connect to a local stash containing the cached objects
    stash <- new ("localDB", dir = cache_dir, name = cache_db)

    # has the expression already been cached?
    if (stashR::dbExists (stash, uuid)) {
        
        if (verbose) message (sprintf ("loading from cache: %s @ %s", uuid, Sys.time()))
        
        # fetch the result from cache
        result <- unserialize (stashR::dbFetch (stash, uuid))
    
    } else {
        
        if (verbose) message (sprintf ("saving to cache: %s @ %s", uuid, Sys.time()))

        # evaluate the expression and cache the result
        result <- eval (expr)
        stashR::dbInsert (stash, key = uuid, value = serialize (expr, NULL))
    }
    
    return (result)
}