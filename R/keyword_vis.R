
#' @title Visualization of grouped keyword co-occurrence network
#' @description Visualization of network-based keyword clustering, with frequency and co-occurrence information attached.
#' @param tibble_graph A \code{tbl_graph} output by \code{\link[akc]{keyword_group}}.
#' @param facet Whether the figure should use facet or not.
#' @param max_nodes The maximum number of nodes displayed in each group.
#' @param alpha The transparency of label. Must lie between 0 and 1. Default uses 0.7.
#' @return An object yielded by \code{\link[ggraph]{ggraph}}
#' @details When \code{facet == TRUE},the function returns a faceted figure with limited number of nodes
#' (adjuseted by \code{max_nodes} parameter).When \code{facet == FALSE},all the nodes would be displayed in one
#' network.Colors are used to specify the groups, the size of nodes is proportional to the keyword frequency,
#' while the alpha of edges is proportional to the co-occurrence relationship between keywords.
#' @seealso \code{\link[ggraph]{ggraph}}
#' @import ggplot2
#' @import ggraph
#' @import dplyr
#' @importFrom ggforce theme_no_axes
#' @export
#' @examples
#'
#' library(akc)
#' \donttest{
#' bibli_data_table %>%
#'   keyword_clean(id = "id",keyword = "keyword") %>%
#'   keyword_group(id = "id",keyword = "keyword") %>%
#'   keyword_vis()
#'
#' # without facet
#' bibli_data_table %>%
#'   keyword_clean(id = "id",keyword = "keyword") %>%
#'   keyword_group(id = "id",keyword = "keyword") %>%
#'   keyword_vis(facet = FALSE)
#'
#' }



keyword_vis = function(tibble_graph,facet = TRUE,max_nodes = 10,alpha = 0.7){

  if(!is.tbl_graph(tibble_graph)) stop("keyword_vis only receives class 'tbl_graph'.")
  suppressWarnings(
    if(facet == FALSE){
      tibble_graph %>%
        group_by(group) %>%
        top_n(max_nodes,freq) %>%
        ungroup() %>%
        mutate(Group = str_c("Group ",group) %>% reorder(group)) %>%
        ggraph("kk") +
        geom_edge_link(aes(alpha = n),show.legend = FALSE) +
        geom_node_point(aes(size = freq),show.legend = FALSE) +
        geom_node_label(aes(label = name,fill = Group),repel = TRUE,alpha = alpha) +
        guides(fill = "none") +
        theme_no_axes()
    }else{
      tibble_graph %>%
        group_by(group) %>%
        top_n(max_nodes,freq) %>%
        ungroup() %>%
        mutate(Group = str_c("Group ",group) %>% reorder(group)) %>%
        ggraph("kk") +
        geom_edge_link(aes(alpha = n),show.legend = FALSE) +
        geom_node_point(aes(size = freq),show.legend = FALSE) +
        geom_node_label(aes(label = name,fill = Group),repel = TRUE,alpha = alpha) +
        guides(fill = "none") +
        facet_nodes(~Group) +
        theme_no_axes()
    }
  )

}





