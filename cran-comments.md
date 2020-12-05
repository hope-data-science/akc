
## 0.9.5
1. Add "group_no" to `keyword_cloud` to get single group of word cloud.
2. Add `doc_group` function to classify documents automatically.
3. Fix problem mentioned in <https://github.com/hope-data-science/akc/pull/4>.
4. Suppress warnings caused by `widyr::pairwise_count`,see <https://stackoverflow.com/questions/63977452/warning-message-pairwise-count-function> (`keyword_group`).
5. Suppress warnings caused by `group_by` in the new dplyr version(`keyword_vis` & `keyword_network`).
6. Urls in `keyword_group` are removed because these links might be unstable. However, through the reference users could still find the source paper via searching.

## 0.9.4 20200130
1. Add "stopword" parameter to `keyword_extract`.
2. Add `keyword_cloud` function for visualization of keywords.
3. Add `keyword_network` function to provide more flexible network visualization.
4. Add a new vignette as tutorial titled as "Tutorial for knowledge classification from raw text".

## v0.9.3 20200126
1. Rearrange the column order of `keyword_extract`,put "id" first.
2. When use the "partof" method in `keyword_merge`, iterate this process until no more "partof" method to make new changes to the data.frame.
3. Add parameter "alpha" to `keyword_vis` to control transparency.

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


