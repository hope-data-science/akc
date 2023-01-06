
#' @title Display the table with different groups of keywords
#' @description Display the result of network-based keyword clustering, with frequency information attached.
#' @param tibble_graph A \code{tbl_graph} output by \code{\link[akc]{keyword_group}}.
#' @param top How many keywords should be displayed in the table for each group.
#' Default uses 10.If there is a tie,more than \emph{top} keywords would be selected.
#' To show all the keywords, use \emph{Inf}.
#' @return A tibble with two columns, namely group and keywords with frequency attached.
#' Different keywords are separated by semicolon(';').
#' @seealso \code{\link[akc]{keyword_group}}
#' @import dplyr
#' @importFrom rlang `:=`
#' @export
#' @examples
#' library(akc)
#'
#' bibli_data_table %>%
#'   keyword_clean(id = "id",keyword = "keyword") %>%
#'   keyword_group(id = "id",keyword = "keyword") %>%
#'   keyword_table()

keyword_table = function(tibble_graph,top = 10){
  if(is.tbl_graph(tibble_graph)){
    tibble_graph %>%
      as_tibble() %>%
      transmute(keyword = name,value = freq,group) %>%
      mutate(keyword_value = str_c(keyword," (",value,")")) %>%
      group_by(group) %>%
      arrange(desc(value)) %>%
      top_n(top,value) %>%
      summarise(keyword = str_c(keyword_value,collapse = "; ")) %>%
      rename(Group = group,!!str_c("Keywords (TOP ",top,")") := keyword)
  }else{
   stop("keyword_table only receives class 'tbl_graph'.")
  }
}


