
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


