
## v0.8.7 20191211 -> v0.8.8

1.Stop word should not be used in keyword_extract, hense I remove it. Because pre-defined stop words might hurt the following task of keyword extraction.
2.The previous keyword_extract did not implement the tokenizatin correctly (did not segment the sentence first, then extract n-grams), so I have adjusted the codes to make it right (there might be something wrong in the unnest_tokens in "ngram" mode, I use tokenizers::tokennize_ngrams directly to debug). -> use trick to nail it down, still use unnest_tokens, which is much faster.
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


