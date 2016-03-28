n <- 2
integrate(function(w) { 1 - ptukey(w, n, Inf)}, 0, Inf) 

#* See https://github.com/nutterb/Bluegrass/blob/devel/R/constants.R
#* For custom written functions for calculating control constants
#* Note: d4 isn't numerically specified.  I haven't found a source 
#* for it yet.