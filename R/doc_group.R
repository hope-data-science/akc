
#' @title Construct network of documents based on keyword co-occurrence
#'
#' @description Create a \code{tbl_graph}(a class provided by \pkg{tidygraph}) from the tidy table with document ID and keyword.
#' Each entry(row) should contain only one document and keyword in the tidy format.This function would
#' group the documents.
#' @param dt A data.frame containing at least two columns with document ID and keyword.
#' @param id Quoted characters specifying the column name of document ID.Default uses "id".
#' @param keyword Quoted characters specifying the column name of keyword.Default uses "keyword".
#' @param com_detect_fun Community detection function,provided by \pkg{tidygraph}(wrappers around clustering
#' functions provided by \pkg{igraph}), see \code{\link[tidygraph]{group_graph}} to find other optional algorithms.
#' Default uses \code{\link[tidygraph]{group_fast_greedy}}.
#' @return A tbl_graph, representing the document relation network based on
#' keyword co-occurrence.
#' @details As we could classify keywords using document ID, we could also
#' classify documents with keywords. In the output network, the nodes are documents
#' and the edges mean the two documents share same keywords with each other.
#' @examples
#'  library(akc)
#'  bibli_data_table %>%
#'    keyword_clean(id = "id",keyword = "keyword") %>%
#'    doc_group(id = "id",keyword = "keyword") -> grouped_doc
#'
#'  grouped_doc


#' @export
doc_group = function(dt,id = "id",keyword = "keyword",
                     com_detect_fun = group_fast_greedy){
  dt %>%
    as_tibble() %>%
    transmute(id = .data[[id]],keyword = .data[[keyword]]) %>%
    # pairwise_count(id,keyword,upper = FALSE) %>%
    tidyfst::pairwise_count_dt(keyword,id) %>%
    graph_from_data_frame(directed = FALSE) %>%
    as_tbl_graph() %>%
    mutate(group = com_detect_fun()) %>%
    rename(id = name)
}


