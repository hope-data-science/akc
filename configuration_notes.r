
library(pacman)
p_load(devtools,usethis,roxygen2,pkgdown)

p_load(tidygraph,ggraph,igraph,dplyr,tidytext,ggwordcloud,stringr)

options(pkgdown.internet = FALSE)

rm(list = ls())
document()
install(upgrade = "never",dependencies = F)
build_site()

.rs.restartR()
options(rmarkdown.html_vignette.check_title = FALSE)


submit_cran()

## https://stackoverflow.com/questions/30424608/error-in-fetchkey-lazy-load-database
.rs.restartR()


p_load(badgecreatr,badger)

ls("package:badger")
ls("package:badgecreatr")
badger::badge_last_commit("hope-data-science/akc")

badger::badge_cran_release("akc","orange")
badger::badge_cran_download("akc", "grand-total")
badger::badge_lifecycle("maturing", "blue")
badgecreatr::badge_last_change_static(date = "2020-01-10")

[![Last-changedate](https://img.shields.io/badge/last%20update-2020--01--10-yellowgreen.svg)](/commits/master)
