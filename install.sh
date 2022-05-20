#!/bin/bash

ln -s ~/.rix/Rprofile ~/.Rprofile
ln -s ~/.rix/inputrc ~/.inputrc
ln -s ~/.rix/Renviron ~/.Renviron
mkdir -p ~/local/R_libs

R -e 'install.packages(c("devtools", "assertr", "libbib", "data.table"))'
R -e 'devtools::install_github("jalvesaq/colorout")'
