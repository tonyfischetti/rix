#!/usr/bin/env bash
# rix doctor — check that this machine's R environment is properly
# installed.  Reports every piece, never mutates anything, exits
# nonzero if something is wrong.  Invoked by `make doctor`.

RIX="$(cd "$(dirname "$0")" && pwd)"
UNAME_S="$(uname -s)"

green="\033[32m"; red="\033[31m"; yellow="\033[33m"; bold="\033[1m"; off="\033[0m"
fail=0
ok()   { printf "  ${green}✓${off} %s\n" "$1"; }
bad()  { printf "  ${red}✗ %s${off}\n" "$1"; fail=1; }
warn() { printf "  ${yellow}! %s${off}\n" "$1"; }

printf "${bold}rix doctor${off} (%s)\n" "$UNAME_S"

# --- R itself ---
if command -v R >/dev/null; then
  ok "R on PATH ($(R --version | head -1 | awk '{print $3}'))"
else
  bad "R not found (make deps)"
fi

# --- symlinks ---
for pair in "$HOME/.Rprofile|Rprofile" "$HOME/.inputrc|inputrc" "$HOME/.Renviron|Renviron"; do
  link="${pair%%|*}"; src="${pair##*|}"
  [ "$link" -ef "$RIX/$src" ] \
    && ok "$link -> rix's $src" \
    || bad "$link does not resolve to rix's $src (make setup)"
done

# --- R_libs ---
[ -d "$HOME/local/R_libs" ] && ok "~/local/R_libs exists" || bad "~/local/R_libs missing (make setup)"

# R_LIBS must actually take effect via ~/.Renviron — this is the check
# that would have caught the old "export R_LIBS=..." line, which R
# silently ignores (Renviron is name=value, not shell)
if command -v Rscript >/dev/null; then
  if Rscript -e 'cat(.libPaths(), sep="\n")' 2>/dev/null | grep -q "local/R_libs"; then
    ok "~/local/R_libs is on .libPaths() (Renviron works)"
  else
    bad "~/local/R_libs NOT on .libPaths() — ~/.Renviron isn't taking effect"
  fi

  # --- packages ---
  missing="$(Rscript -e '
    needed <- c("assertr", "libbib", "data.table", "ggplot2",
                "tidyverse", "languageserver", "colorout")
    m <- Filter(function (p) !requireNamespace(p, quietly = TRUE), needed)
    cat(m, sep = ",")' 2>/dev/null)"
  if [ -z "$missing" ]; then
    ok "all R packages loadable (incl. colorout)"
  else
    bad "R packages missing/unloadable: $missing (make setup)"
  fi

  # --- Rprofile loads clean ---
  if R --no-save -e 'invisible(0)' 2>&1 | grep -q "Successfully loaded .Rprofile"; then
    ok "~/.Rprofile loads clean"
  else
    bad "~/.Rprofile did not announce itself — it may be erroring"
  fi
fi

echo
if [ "$fail" -eq 0 ]; then
  printf "${green}${bold}all good.${off}\n"
else
  printf "${red}${bold}problems found — see above.${off}\n"
fi
exit "$fail"
