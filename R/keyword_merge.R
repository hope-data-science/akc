
#' @title Merge keywords that supposed to have same meanings
#' @description Merge keywords that have common stem or lemma, and return the majority form of the word. This function
#' recieves a tidy table (data.frame) with document ID and keyword waiting to be merged.
#' @param dt A data.frame containing at least two columns with document ID and keyword.
#' @param id Quoted characters specifying the column name of document ID.Default uses "id".
#' @param keyword Quoted characters specifying the column name of keyword.Default uses "keyword".
#' @param reduce_form Should the merge terms have the same stem("stem") or lemma("lemma")?
#' Default uses "lemma".
#' @details  While \code{keyword_clean} has provided a robust way to lemmatize the keywords, the returned token
#' might not be the most common way to use.This function first gets the stem or lemma of
#' every keyword using \code{\link{stem_strings}} or \code{\link{lemmatize_strings}} from \pkg{textstem} package,
#' then find the most frequent form (if more than 1,randomly select one)
#' for each stem or lemma. Last, every keyword
#' would be replaced by the most frequent keyword which share the same stem or lemma with it.
#' @return A tbl, namely a tidy table with document ID and merged keyword.
#' @seealso \code{\link[textstem]{stem_strings}}, \code{\link[textstem]{lemmatize_strings}}
#' @importFrom textstem stem_strings lemmatize_strings
#' @import dplyr
#' @export
#' @examples
#' library(akc)
#'
#' bibli_data_table %>%
#'   keyword_clean(lemmatize = FALSE) %>%
#'   keyword_merge(reduce_form = "stem")
#'
#' bibli_data_table %>%
#'   keyword_clean(lemmatize = FALSE) %>%
#'   keyword_merge(reduce_form = "lemma")

keyword_merge = function(dt,id = "id",keyword = "keyword",
                          reduce_form = "lemma"){
  if(!is.data.frame(dt)) stop("keyword_merge should receive a data.frame.")

  dt %>%
    as.data.table() %>%
    setnames(old = c(id,keyword),new = c("id","keyword")) -> dt2

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
