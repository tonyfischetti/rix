rix
===

A place to update and store my R configuration

This will create a symlink to a custom .Rprofile that's
(largely) safe to use for reproducibility purposes

You can also (for quick tasks) use `RR` to run a super
custom R profile that automatically loads your most
used packages and things.
`RR` is a shell script that will invoke R with that very special
R profile. You can create a shell alias to run that shell
script

```
git clone https://github.com/tonyfischetti/rix.git ~/.rix/
make -C ~/.rix deps      # OS packages (sudo; macOS: checks for CRAN R)
make -C ~/.rix setup     # symlinks, ~/local/R_libs, packages
make -C ~/.rix doctor    # verify everything
```

The Makefile is the single source of truth (it replaced `install.sh`).
Everything is idempotent — `make setup` installs only what's missing,
so re-running it any time is safe and fast.  `make doctor` checks the
whole install (including that `~/.Renviron` actually takes effect —
R silently ignores malformed lines) and exits nonzero if anything is
broken.
