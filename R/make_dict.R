
#' @title  Making one's own dictionary
#' @description Construting a dictionary using a string vector with user defined vocabulary.
#' @param dict_vacabulary_vector A character vector containing the user defined professional vocabulary.
#' @details Build a user defined vocabulary for keyword extraction (\code{\link[akc]{keyword_extract}}).
#' @return  A data.table with document id and keyword,using keyword as the key.
#' @seealso \code{\link[akc]{keyword_extract}}
#' @export
#'
make_dict = function(dict_vacabulary_vector){
  data.table(keyword = unique(dict_vacabulary_vector),key = "keyword")
}
