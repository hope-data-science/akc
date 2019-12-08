# akc: Automatic knowledge classification <img src="man/figures/logo.png" align="right" alt="" width="120" />
Short for automatic knowledge classification, *akc* is an R package used to carry out keyword classification based on network science (mainly community detection techniques), using bibliometric data. However, these provided functions are general, and could be extended to solve other tasks in text mining as well.   

## Features

Generally provides a tidy framework of data manipulation supported by *dplyr*, *akc* was written in data.table when necessary to guarantee the performance for big data analysis. Meanwhile, *akc* also utilizes the state-of-the-art text mining functions provided by *stringr*,*tidytext*,*textstem* and network analysis functions provided by *igraph*,*tidygraph* and *ggraph*. Pipe %>% has been exported from *magrittr* and could be used directly in *akc*.



## Installation

```R
devtools::install_github("hope-data-science/akc")
```



## Further information

See <https://hope-data-science.github.io/akc/>.