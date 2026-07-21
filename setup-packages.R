# setup-packages.R — idempotent package install for rix (`make setup`).
# Installs only what's missing, so re-runs are fast no-ops (the old
# install.sh re-installed everything, every time).

# don't depend on Rprofile having run for a CRAN mirror
repos <- getOption("repos")
if (is.null(repos) || is.na(repos["CRAN"]) || repos["CRAN"] == "@CRAN@") {
  options(repos = c(CRAN = "https://cloud.r-project.org"))
}

needed <- c("assertr", "libbib", "data.table", "ggplot2",
            "tidyverse", "languageserver")
missing <- setdiff(needed, rownames(installed.packages()))

if (length(missing)) {
  message("installing missing packages: ", paste(missing, collapse = ", "))
  install.packages(missing)
} else {
  message("all CRAN packages already present")
}

if (requireNamespace("colorout", quietly = TRUE)) {
  message("colorout already present")
} else {
  message("installing colorout from goodies/")
  install.packages("goodies/colorout_1.3-3.tar.gz", repos = NULL, type = "source")
}

# fail loudly (nonzero exit) if anything is still unloadable
still.missing <- Filter(
  function (p) !requireNamespace(p, quietly = TRUE),
  c(needed, "colorout"))
if (length(still.missing)) {
  stop("packages failed to install: ", paste(still.missing, collapse = ", "))
}
