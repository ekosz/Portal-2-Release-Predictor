README
======

`scraper.rb` is left running.  Once a minute it goes the to Portal 2 site, and
finds out the width of the progress bar.

The progress bar has a max width of 494, so the percent completed is `the
current size / 494`.

The site records every time a new percent is completed then plots the
data and preforms a linear regression.  

From the linear regression it then predicts when 100% completion will happen.
