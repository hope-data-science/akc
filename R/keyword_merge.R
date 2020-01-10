
#' @title Merge keywords that supposed to have same meanings
#' @description Merge keywords that have common stem or lemma, and return the majority form of the word. This function
#' recieves a tidy table (data.frame) with document ID and keyword waiting to be merged.
#' @param dt A data.frame containing at least two columns with document ID and keyword.
#' @param id Quoted characters specifying the column name of document ID.Default uses "id".
#' @param keyword Quoted characters specifying the column name of keyword.Default uses "keyword".
#' @param reduce_form Merge keywords with the same stem("stem") or lemma("lemma"). See details.
#' Default uses "lemma". Another advanced option is "partof". If a non-unigram (A) is part (subset) of
#' another non-unigram (B), then the longer one(B) would be replaced by the longer one(A).
#' @details  While \code{keyword_clean} has provided a robust way to lemmatize the keywords, the returned token
#' might not be the most common way to use.This function first gets the stem or lemma of
#' every keyword using \code{\link{stem_strings}} or \code{\link{lemmatize_strings}} from \pkg{textstem} package,
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
                          reduce_form = "lemma"){
  if(!is.data.frame(dt)) stop("keyword_merge should receive a data.frame.")

  dt %>%
    as.data.table() %>%
    setnames(old = c(id,keyword),new = c("id","keyword")) %>%
    unique()-> dt2

  if(reduce_form == "stem"){
    copy(dt2)[,token := stem_strings(keyword)][] -> dt3

    copy(dt3)[, .(n = .N), keyby = .(token, keyword)][
      ,.SD[n ==max(n)][1], keyby = .(token)][
        ,.(token = token, keyword_most = keyword)] -> token_keyword

    merge(dt3,token_keyword,by = "token")[, .(id = id, keyword = keyword_most)] %>%
      as_tibble()
  }else if(reduce_form == "lemma"){
    copy(dt2)[,token := lemmatize_strings(keyword)][] -> dt3

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
    dt2 %>%
      .[str_detect(keyword," ")] %>%
      as_tibble() %>%
      pairwise_count(keyword,id) %>%
      mutate(value = str_detect(item1,item2)) %>%
      filter(value == TRUE) %>%
      transmute(keyword = item1,replace = item2) %>%
      as.data.table() %>%
      unique()-> dt3

    dt2 %>%
      merge(dt3,all.x = TRUE,by = "keyword") %>%
      .[!is.na(replace),keyword:=replace] %>%
      .[,replace := NULL] %>%
      unique() %>%
      as_tibble() %>%
      select(id,keyword)
  }

}

## original codes did not consider there would be two or more max value
# keyword_merge = function(dt,id = "id",keyword = "keyword",
#                          reduce_form = "lemma"){
#   if(!is.data.frame(dt)) stop("keyword_merge should receive a data.frame.")
#
#   dt %>%
#     as.data.table() %>%
#     setnames(old = c(id,keyword),new = c("id","keyword")) -> dt2
#
#   if(reduce_form == "stem"){
#     copy(dt2)[,token := stem_strings(keyword)][] -> dt3
#
#     copy(dt3)[, .(n = .N), keyby = .(token, keyword)][
#       ,.SD[n ==max(n)], keyby = .(token)][
#         ,.(token = token, keyword_most = keyword)] -> token_keyword
#
#     merge(dt3,token_keyword,by = "token")[, .(id = id, keyword = keyword_most)] %>%
#       as_tibble()
#   }else if(reduce_form == "lemma"){
#     copy(dt2)[,token := lemmatize_strings(keyword)][] -> dt3
#
#     copy(dt3)[, .(n = .N), keyby = .(token, keyword)][
#       ,.SD[n ==max(n)], keyby = .(token)][
#         ,.(token = token, keyword_most = keyword)] -> token_keyword
#
#     merge(dt3,token_keyword,by = "token")[, .(id = id, keyword = keyword_most)] %>%
#       as_tibble()
#   }
#
# }

## orignial codes using dplyr

# keyword_merge = function(dt,id = "id",keyword = "keyword",
#                          reduce_form = "lemma"){
#   if(!is.data.frame(dt)) stop("keyword_merge should receive a data.frame.")
#
#   dt %>%
#     as_tibble() %>%
#     transmute(id = .data[[id]],keyword = .data[[keyword]]) -> dt2
#
#   if(reduce_form == "stem"){
#     dt2 %>%
#       mutate(token = stem_strings(keyword)) -> dt3
#
#     dt3 %>%
#       group_by(token) %>%
#       count(keyword) %>%
#       filter(n == max(n)) %>%
#       ungroup %>%
#       transmute(token,keyword_most = keyword) -> token_keyword
#
#     dt3 %>%
#       inner_join(token_keyword,by = "token") %>%
#       transmute(id,keyword = keyword_most)
#   }else if(reduce_form == "lemma"){
#     dt2 %>%
#       mutate(token = lemmatize_strings(keyword)) -> dt3
#
#     dt3 %>%
#       group_by(token) %>%
#       count(keyword) %>%
#       filter(n == max(n)) %>%
#       ungroup %>%
#       transmute(token,keyword_most = keyword) -> token_keyword
#
#     dt3 %>%
#       inner_join(token_keyword,by = "token") %>%
#       transmute(id,keyword = keyword_most)
#   }
#
# }
