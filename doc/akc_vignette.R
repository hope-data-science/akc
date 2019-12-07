## ---- include = FALSE----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----fig.cap = "Logo of akc package.", echo=FALSE------------------------
knitr::include_graphics("logo.png")

## ----setup---------------------------------------------------------------
# load pakcage
library(akc)
library(dplyr)

# inspect the built-in data
bibli_data_table

## ------------------------------------------------------------------------
bibli_data_table %>% 
  keyword_clean() -> clean_data

clean_data

## ------------------------------------------------------------------------
clean_data %>% 
  keyword_merge() -> merged_data

merged_data

## ------------------------------------------------------------------------
merged_data %>% 
  keyword_group() -> grouped_data

grouped_data

## ------------------------------------------------------------------------
grouped_data %>% 
  keyword_table(top = 10)

## ---- fig.width=10, fig.height=8-----------------------------------------
grouped_data %>% 
  keyword_vis()

## ------------------------------------------------------------------------
bibli_data_table %>%
  keyword_clean(id = "id",keyword = "keyword") %>%
  pull(keyword) %>%
  make_dict -> my_dict

bibli_data_table %>%
  keyword_extract(id = "id",text = "abstract",dict = my_dict) %>%
  keyword_merge(keyword = "keyword")

