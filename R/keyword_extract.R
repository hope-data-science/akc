
#' @title Extract keywords from raw text
#'
#' @description When we have raw text like abstract or article but not keywords, we might prefer extracting
#' keywords first. The least prerequisite data to be provided are a data.frame with document id and raw text,
#' and a user defined dictionary should be provided. One could use \code{\link[akc]{make_dict}} function to construct his(her)
#' own dictionary with a character vector containing the vocabularies.
#' @param df A data.frame containing at least two columns with document ID and text strings for extraction.
#' @param id Quoted characters specifying the column name of document ID.Default uses "id".
#' @param text Quoted characters specifying the column name of raw text for extraction.
#' @param dict A data.table with two columns,namely "id" and "keyword"(set as key).
#' This should be exported by \code{\link[akc]{make_dict}} function.
#' @param stopword_word A character vector containing the stop words.
#' Default uses \code{tidytext::stop_words$word}.
#' @param n_max The number of words in the n-gram. This must be an integer greater than or equal to 1.
#' Default uses 4.
#' @param n_min This must be an integer greater than or equal to 1, and less than or equal to n_max.
#' Default uses 1.
#' @details In the procedure of keyword extraction from \pkg{akc},first the raw text would be split
#' into independent clause (namely split by puctuations of \code{[,;!?.]}). Then the ngrams of the
#' clauses would be extracted. Finally, the phrases represented by ngrams should be in the dictionary
#' created by the user (using \code{make_dict}).The user could also specify the \emph{n} of ngrams,
#' and the stop words could be changed to another character vector.
#' @return A data.frame(tibble) with two columns, namely document ID and extracted keyword.
#' @seealso \code{\link[akc]{make_dict}}
#' @examples
#' library(akc)
#' library(dplyr)
#'
#' bibli_data_table %>%
#'   keyword_clean(id = "id",keyword = "keyword") %>%
#'   pull(keyword) %>%
#'   make_dict -> my_dict
#'
#' bibli_data_table %>%
#'   keyword_extract(id = "id",text = "abstract",dict = my_dict) %>%
#'   keyword_merge(keyword = "keyword")
#' @export

keyword_extract = function(dt,id = "id",text,
                           dict,stopword_vector = stop_words$word,
                           n_max = 4,n_min = 1){

  dt %>%
    as_tibble() %>%
    transmute(id = .data[[id]],text = .data[[text]]) %>%
    unnest_tokens(keyword,text,token = strsplit,split = "[,;!?.][:space:]*") %>%
    unnest_tokens(keyword,keyword,token = "ngrams",n = n_max,n_min = n_min,stopwords = stopword_vector) %>%
    unique() %>%
    data.table(key = "keyword") %>%
    merge(dict,by = "keyword") %>%
    as_tibble() %>%
    select(id,keyword)

}





