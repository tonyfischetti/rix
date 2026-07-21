# rix — Tony's R environment.  Single source of truth for setting up R
# on a machine (replaces install.sh).
#
#   make deps      install OS packages (needs sudo; on macOS just
#                  checks for the CRAN framework build)
#   make setup     idempotent install: symlinks, R_libs, packages
#   make doctor    check the install and report, loud + colorful
#
# Everything is re-runnable: `make setup` installs only what's missing
# (the old install.sh re-installed every package on every run, and its
# bare `ln -s` died the second time).
#
# NB: written to run on the macOS system make (GNU Make 3.81) as well
# as Debian's — so no .ONESHELL.

SHELL := /bin/bash

RIX        := $(CURDIR)
UNAME_S    := $(shell uname -s)
R_LIBS_DIR := $(HOME)/local/R_libs

.PHONY: help deps setup links packages doctor

help:
	@echo "rix setup — targets:"
	@echo "  make deps      install OS packages (sudo; macOS: checks for R)"
	@echo "  make setup     idempotent install (symlinks, R_libs, packages)"
	@echo "  make doctor    check the install and report"

# ---- OS packages ----------------------------------------------------- #
# Debian: r-base + the compile-time libs the package list needs
# (tidyverse pulls ragg/textshaping, hence the font/image -dev libs —
# these were smeared into the Dockerfile's "other packages" before).
# macOS: R is the CRAN framework installer, not brew — just check.
deps:
ifeq ($(UNAME_S),Darwin)
	@command -v R >/dev/null \
	  || { echo "R not found — install the CRAN framework build: https://cran.r-project.org/bin/macosx/"; exit 1; }
	@echo "R present ($$(command -v R)) — nothing to install via brew"
else
	sudo apt-get update -qq -o Acquire::Retries=3
	sudo apt-get install -qq -y -o Acquire::Retries=3 \
	  r-base build-essential libcurl4-openssl-dev libssl-dev libxml2-dev \
	  libfontconfig1-dev libharfbuzz-dev libfribidi-dev libfreetype6-dev \
	  libpng-dev libtiff5-dev libjpeg-dev libuv1-dev
endif

# ---- full install ---------------------------------------------------- #
setup: links packages
	@echo "setup complete — run 'make doctor' to verify."

links:
	ln -sfn $(RIX)/Rprofile $(HOME)/.Rprofile
	ln -sfn $(RIX)/inputrc  $(HOME)/.inputrc
	ln -sfn $(RIX)/Renviron $(HOME)/.Renviron
	mkdir -p $(R_LIBS_DIR)

# R_LIBS passed explicitly so this works even before ~/.Renviron is
# linked (and regardless of the shell's environment)
packages: | links
	cd $(RIX) && R_LIBS=$(R_LIBS_DIR) Rscript setup-packages.R

# ---- doctor: report, never mutate ------------------------------------ #
doctor:
	@bash $(RIX)/doctor.sh
