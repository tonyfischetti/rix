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

To install some of the packages in that install as part of the
`install.sh` script, you need libcurl4-openssl-dev and libxml2-dev,
or the equivalent package on your OS

```
git clone https://github.com/tonyfischetti/rix.git ~/.rix/
cd ~/.rix/
./install.sh
```
