
#' @title Merge keywords that supposed to have same meanings
#' @description Merge keywords that have common stem or lemma, and return the majority form of the word. This function
#' recieves a tidy table (data.frame) with document ID and keyword waiting to be merged.
#' @param dt A data.frame containing at least two columns with document ID and keyword.
#' @param id Quoted characters specifying the column name of document ID.Default uses "id".
#' @param keyword Quoted characters specifying the column name of keyword.Default uses "keyword".
#' @param reduce_form Merge keywords with the same stem("stem") or lemma("lemma"). See details.
#' Default uses "lemma". Another advanced option is "partof". If a non-unigram (A) is part (subset) of
#' another non-unigram (B), then the longer one(B) would be replaced by the shorter one(A).
#' @param lemmatize_dict A dictionary of base terms and lemmas to use for replacement.
#'  Only used when the \bold{lemmatize} parameter is \code{TRUE}.
#'  The first column should be the full word form in lower case
#'  while the second column is the corresponding replacement lemma.
#'  Default uses \code{NULL}, this would apply the default dictionary used in
#'  \code{\link[textstem]{lemmatize_strings}} function. Applicable when \bold{reduce_form} takes "lemma".
#' @param stem_lang The name of a recognized language.
#'  The list of supported languages could be found at \code{\link[SnowballC]{getStemLanguages}}.
#'  Applicable when \bold{reduce_form} takes "stem".
#' @details  While \code{keyword_clean} has provided a robust way to lemmatize the keywords, the returned token
#' might not be the most common way to use.This function first gets the stem or lemma of
#' every keyword using \code{\link[textstem]{stem_strings}} or \code{\link[textstem]{lemmatize_strings}} from \pkg{textstem} package,
#' then find the most frequent form (if more than 1,randomly select one)
#' for each stem or lemma. Last, every keyword
#' would be replaced by the most frequent keyword which share the same stem or lemma with it.
#' @details When the `reduce_form` is set to "partof", then for non-unigrams in the same document,
#' if one non-unigram is the subset of another, then they would be merged into the shorter one,
#' which is considered to be more general (e.g. "time series" and "time series analysis" would be
#' merged into "time series" if they co-occur in the same document). This could reduce the redundant
#' information. This is only applied to multi-word phrases, because using it for one word would
#' oversimplify the token and cause information loss (therefore, "time series" and "time" would not be
#' merged into "time"). This is an advanced option that should be used with caution (A trade-off between
#' information generalization and detailed information retention).
#' @return A tbl, namely a tidy table with document ID and merged keyword.
#' @seealso \code{\link[textstem]{stem_strings}}, \code{\link[textstem]{lemmatize_strings}}
#' @importFrom textstem stem_strings lemmatize_strings
#' @import dplyr
#' @export
#' @examples
#' library(akc)
#'
#' \donttest{
#' bibli_data_table %>%
#'   keyword_clean(lemmatize = FALSE) %>%
#'   keyword_merge(reduce_form = "stem")
#'
#' bibli_data_table %>%
#'   keyword_clean(lemmatize = FALSE) %>%
#'   keyword_merge(reduce_form = "lemma")
#' }
#'


keyword_merge = function(dt,id = "id",keyword = "keyword",
                          reduce_form = "lemma",
                         lemmatize_dict = NULL,
                         stem_lang = "porter"){
  if(!is.data.frame(dt)) stop("keyword_merge should receive a data.frame.")

  dt %>%
    as.data.table() %>%
    setnames(old = c(id,keyword),new = c("id","keyword")) %>%
    unique()-> dt2

  if(reduce_form == "stem"){
    copy(dt2)[,token := stem_strings(keyword,language = stem_lang)][] -> dt3

    copy(dt3)[, .(n = .N), keyby = .(token, keyword)][
      ,.SD[n ==max(n)][1], keyby = .(token)][
        ,.(token = token, keyword_most = keyword)] -> token_keyword

    merge(dt3,token_keyword,by = "token")[, .(id = id, keyword = keyword_most)] %>%
      as_tibble()
  }else if(reduce_form == "lemma"){
    if(is.null(lemmatize_dict))
      copy(dt2)[,token := lemmatize_strings(keyword)][] -> dt3
    else
      copy(dt2)[,token := lemmatize_strings(keyword,dictionary = lemmatize_dict)][] -> dt3

    copy(dt3)[, .(n = .N), keyby = .(token, keyword)][
      ,.SD[n ==max(n)][1], keyby = .(token)][
        ,.(token = token, keyword_most = keyword)] -> token_keyword

    merge(dt3,token_keyword,by = "token")[, .(id = id, keyword = keyword_most)] %>%
      as_tibble()
  }
  else if(reduce_form == "partof"){
    # for multigrams only
    # if a multigram is a subset of another multigram in the same document,merge to
    # the multigram with the shorter length
    # e.g. "time series" and "time series analysis" would be merged to "time series"
    repeat{
      dt2 %>%
        .[str_detect(keyword," ")] %>%
        as_tibble() %>%
        # pairwise_count(keyword,id) %>%
        tidyfst::pairwise_count_dt(id,keyword) %>%
        mutate(value = str_detect(item1,item2)) %>%
        filter(value == TRUE) %>%
        transmute(keyword = item1,replace = item2) %>%
        as.data.table() %>%
        unique()-> dt3

      dt2 %>%
        merge(dt3,all.x = TRUE,by = "keyword") %>%
        .[!is.na(replace),keyword:=replace] %>%
        .[,replace := NULL] %>%
        unique() -> final
      if(setequal(dt2,final)) break
      else dt2 = final
    }
    final%>%
      as_tibble() %>%
      select(id,keyword)

  }

}


