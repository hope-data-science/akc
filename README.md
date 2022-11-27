# akc: Automatic knowledge classification <img src="man/figures/logo.png" align="right" alt="" width="120" />
[![](https://www.r-pkg.org/badges/version/akc?color=orange)](https://cran.r-project.org/package=akc) ![](http://cranlogs.r-pkg.org/badges/grand-total/akc?color=yellow) [![](http://cranlogs.r-pkg.org/badges/last-month/akc?color=red)](https://cran.r-project.org/package=akc) ![](https://img.shields.io/badge/lifecycle-stable-blue.svg) [![](https://img.shields.io/github/last-commit/hope-data-science/akc.svg)](https://github.com/hope-data-science/akc/commits/master) [![](https://img.shields.io/badge/R%20Journal-10.32614/RJ--2022--025-green.svg)](https://journal.r-project.org/articles/RJ-2022-025/)

Short for automatic knowledge classification, *akc* is an R package used to carry out keyword classification based on network science (mainly community detection techniques), using bibliometric data. However, these provided functions are general, and could be extended to solve other tasks in text mining as well.   

## Features

Generally provides a tidy framework of data manipulation supported by *dplyr*, *akc* was written in data.table when necessary to guarantee the performance for big data analysis. Meanwhile, *akc* also utilizes the state-of-the-art text mining functions provided by *stringr*,*tidytext*,*textstem* and network analysis functions provided by *igraph*,*tidygraph* and *ggraph*. Pipe %>% has been exported from *magrittr* and could be used directly in *akc*.



## Installation

```R
install.packages("akc")
# or
devtools::install_github("hope-data-science/akc")
```

Note: As `akc` utilizes many state-of-the-art functions from various excellent R packages, it might take a while to install the whole suite, especially when you are still not a heavy R user (then lots of packages might not be installed in advance). Nevertheless, the patience pays off. The well-organized framework will save you much more time afterward. 



## TODO

More layouts for the network, utilizing *graphlayouts*, etc.



## Further information

See [vignette](<https://hope-data-science.github.io/akc/articles/akc_vignette.html>) and [tutorial](<https://hope-data-science.github.io/akc/articles/tutorial_raw_text.html>) .
