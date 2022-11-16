#!/bin/bash

ln -s ~/.rix/Rprofile ~/.Rprofile
ln -s ~/.rix/inputrc ~/.inputrc
ln -s ~/.rix/Renviron ~/.Renviron
mkdir -p ~/local/R_libs

R -e 'install.packages(c("assertr", "libbib", "data.table", "ggplot2"))'
R CMD INSTALL goodies/colorout_1.2-1.tar.gz
