
## v0.9.2
Add a new option for `keyword_merge`,namely "partof". This option could help merge tokens with relatively same meaning in the same document. For instance, "time series" and "time series analysis" would be merged into "time series". This method could only be applied to more-than-one-word phrases, which means "time series" and "time" would never be merged into "time" (which is considered as information loss). This alternative is an advanced method and should be used with caution.

## v0.9.1 20200109
1. For `keyword_extract`,give the alternative option to let parameter `dict = NULL`, then the keywords would not be filtered by the dictionary. This could be useful in some circumstances.
2. Because data.table has some deprecated functions, we remove some of the functions imported from `data.table`. This might be urgent. Details are listed in <https://github.com/hope-data-science/akc/issues/1#issuecomment-572388600>.
3. For `keyword_vis`,change `mutate(Group = str_c("Group ",group))` to `mutate(Group = str_c("Group ",group) %>% reorder(group))`. This means that when there are more than 10 plots, it would be ordered as 1~10, but not 1,10,2...

## v0.9.0 20200107
Fix the Description, adding quotes to API name.
In the future the frame work will be extended to use more methods for keyword clustering in the tidy framework.

## v0.8.9 20191217
1.There might be two max values in keyword_merge, previously keep both, now randomly save only one.
2.Correct some typos in the vignette.
3.Document standardization,e.g. use TRUE and FALSE instead of T and F.
4.Update the description of package for more details.
5.Use `\donttest{}` and `\dontrun{}` for codes demanding longer time.This package could deal with relatively big data, but it demands computer with larger RAM.

## v0.8.8
Change back to unnest_token for high performance

## v0.8.7 20191211 

1.Stop word should not be used in keyword_extract, hense I remove it. Because pre-defined stop words might hurt the following task of keyword extraction.
2.The previous keyword_extract did not implement the tokenizatin correctly (did not segment the sentence first, then extract n-grams), so I have adjusted the codes to make it right (there might be something wrong in the unnest_tokens in "ngram" mode, I use tokenizers::tokennize_ngrams directly to debug). 
3.Add examples to make_dict function.

## v0.8.6 20191210

Export the tidygraph community detection functions.
Change the detection function parameter name to "com_detect_fun".
Add github url information and maintainer information.

## Test environments
* local OS X install, R 3.6.1
* ubuntu 14.04 (on travis-ci), R 3.6.1
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.


