nmisc
=====

An R package containing miscellaneous functions that Nick finds useful.  Exciting, huh?!  

I find myself constantly in need of an expression cache across many projects.  The quicker, and tighter that my development iterations are, the cooler, better, and more amazing my resulting code is.  In addition, I am just plain impatient and don't like to wait unless I absolutely have to.

This package contains a function that caches the result of long-running expressions to avoid unnecessary re-execution.  For example, when iterating through modeling improvements, there is no need to wait for the pre-processing/munging code to re-execute each and every time a change is made to the model.  By wraping that code in an `ecache` the result will be cached and not re-executed unless the underlying code itself changes.

```
data <- ecache ({ 
  x <- long_running_code() 
  y <- even_slower_code()
  x + y
})
```

### Installation

  1. Install [devtools](http://www.rstudio.com/products/rpackages/devtools/).
  
  ```
  install.packages("devtools")
  ```
  
  2. Install [nmisc](https://github.com/nickwallen/nmisc).

  ```
  devtools::install_github ("nickwallen/nmisc")
  ```
