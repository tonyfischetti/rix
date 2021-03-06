
##############################################
###                                        ###
###   Tony Fischetti's special R profile   ###
###                                        ###
###             tony.fischetti@gmail.com   ###
###                                        ###
##############################################


# get noisy package imports to shut up
#   we have to jump through hoops to get the
#   call to "library()" to work because it
#   will try to load a package even if it is not
#   a string literal
sshhh <- function(a.package){
  suppressWarnings(suppressPackageStartupMessages(
    library(a.package, character.only=TRUE)))
}

# list of packages to auto-load if interactive
auto.loads <-c("magrittr",
                # "assertr",
                # "dplyr",
                # "tidyr",
                "ggplot2",
                "stringr",
                "data.table",
                "libbib")

# auto-load quietly
if(interactive()){
  invisible(sapply(auto.loads, sshhh))
}
# sapply(auto.loads, function(x) library(x, character.only=TRUE))

source("~/.Rprofile")
source("~/.rix/tony-utils.R")

message("\n*** loaded magrittr, ggplot2, stringr, data.table, and libbib ***\n")

message("\n*** Successfully loaded expanded .RRprofile ***\n")
