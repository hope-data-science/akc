
#' @title Construct network from a tidy table and divide them into groups
#'
#' @description Create a \code{tbl_graph}(a class provided by \pkg{tidygraph}) from the tidy table with document ID and keyword.
#' Each entry(row) should contain only one keyword in the tidy format.This function would automatically computes
#' the frequency and classification group number of nodes representing keywords.
#' @param dt A data.frame containing at least two columns with document ID and keyword.
#' @param id Quoted characters specifying the column name of document ID.Default uses "id".
#' @param keyword Quoted characters specifying the column name of keyword.Default uses "keyword".
#' @param top The number of keywords selected with the largest frequency.
#' If there is a tie,more than \emph{top} entries would be selected.
#' @param min_freq Minimum occurrence of selected keywords.Default uses 1.
#' @param com_detect_fun Community detection function,provided by \pkg{tidygraph}(wrappers around clustering
#' functions provided by \pkg{igraph}), see \code{\link[tidygraph]{group_graph}} to find other optional algorithms.
#' Default uses \code{\link[tidygraph]{group_fast_greedy}}.
#' @return A tbl_graph, representing the keyword co-occurence network with frequency and group
#' number of the keywords.
#' @details This function receives a tidy table with document ID and keyword.Only top keywords with
#' largest frequency would be selected and the minimum occurrence of keywords could be specified.
#' For suggestions of community detection algorithm, see the references provided below.
#' @references
#' de Sousa, Fabiano Berardo, and Liang Zhao. "Evaluating and comparing the igraph community detection algorithms." 2014 Brazilian Conference on Intelligent Systems. IEEE, 2014.
#' @references Yang, Z., Algesheimer, R., & Tessone, C. J. (2016). A comparative analysis of community detection algorithms on artificial networks. Scientific reports, 6, 30750.
#' @seealso  \code{\link[tidygraph]{tbl_graph}}, \code{\link[tidygraph]{group_graph}}
#' @import tidygraph
#' @import dplyr
#' @importFrom tidyfst pairwise_count_dt
#' @importFrom rlang .data
#' @importFrom igraph graph_from_data_frame
#' @export
#' @examples
#' library(akc)
#' \donttest{
#' bibli_data_table %>%
#'   keyword_clean(id = "id",keyword = "keyword") %>%
#'   keyword_group(id = "id",keyword = "keyword")
#'
#' # use 'louvain' algorithm for community detection
#'
#' bibli_data_table %>%
#'   keyword_clean(id = "id",keyword = "keyword") %>%
#'   keyword_group(id = "id",keyword = "keyword",
#'   com_detect_fun = group_louvain)
#'
#' # get more alternatives by searching '?tidygraph::group_graph'
#' }

keyword_group = function(dt,id = "id",keyword = "keyword",
                        top = 200,min_freq = 1,
                        com_detect_fun = group_fast_greedy){

  dt %>%
    as_tibble() %>%
    transmute(id = .data[[id]],keyword = .data[[keyword]]) -> dt

  dt %>%
    count(keyword) %>%
    top_n(top,n) %>%
    filter(n >= min_freq) -> freq_table

  # suppressWarnings(
    dt %>%
      inner_join(freq_table %>% select(keyword),by = "keyword") %>%
      # pairwise_count(keyword,id,upper = FALSE) %>%
      tidyfst::pairwise_count_dt(id,keyword) %>%
      graph_from_data_frame(directed = FALSE) %>%
      as_tbl_graph() %>%
      inner_join(freq_table,by = c("name"="keyword")) %>%
      rename(freq = n) %>%
      mutate(group = com_detect_fun())  # community detection,this algorithm could be changed
    # other options could be found in tidygraph::group_graph
  # )
}




