
##############################################
###                                        ###
###   Tony Fischetti's default R profile   ###
###                                        ###
###             tony.fischetti@gmail.com   ###
###                                        ###
##############################################

# set default CRAN mirror
local({r <- getOption("repos")
      r["CRAN"] <- "https://cloud.r-project.org"
      options(repos=r)})


#############
## OPTIONS ##
#############

options(stringsAsFactors=FALSE)     # stringsAsFactors=HELLNO
options(max.print=100)
options(scipen=10)                  # no scientific notation
options(editor="vim")               # the best there is
options(warn=2)                     # warnings as errors
options(useFancyQuotes=FALSE)       # just no
options(menu.graphics=FALSE)        # no time for Tk to load
options(max.print=300)
options(width = 80)
# options(prompt="> ")
# options(continue="... ")          # helps me realize when I forget to close (
options(datatable.print.class=TRUE)
options(datatable.print.keys=TRUE)
options(datatable.prettyprint.char=50)
options(datatable.fwrite.sep='\t')
options(datatable.na.strings="")

source("~/.rix/secret-options.R")

utils::rc.settings(ipck=TRUE)      # tab complete package names

# pretty colors
require("colorout")

# I never want to save, fam
q <- function (save="no", ...) {
  quit(save=save, ...)
}


# set up .Rhistory dump
.First <- function(){
  if(interactive()){
    library(utils)
    timestamp(,prefix=paste("##------ [",getwd(),"] ",sep=""))

  }
}

.Last <- function(){
  if(interactive()){
    hist_file <- Sys.getenv("R_HISTFILE")
    if(hist_file=="") hist_file <- "~/.Rhistory"
    savehistory(hist_file)
  }
}


message("\n*** Successfully loaded .Rprofile ***\n")
