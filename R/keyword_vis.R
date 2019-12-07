
#' @title Visualization of grouped keyword co-occurrence network
#' @description Visualization of network-based keyword clustering, with frequency and co-occurrence information attached.
#' @param tibble_graph A \code{tbl_graph} output by \code{\link[akc]{keyword_group}}.
#' @param facet Whether the figure should use facet or not.
#' @param max_nodes The maximum number of nodes displayed in each group.
#' @return An object yielded by \code{\link[ggraph]{ggraph}}
#' @details When \code{facet == T},the function returns a faceted figure with limited number of nodes
#' (adjuseted by \code{max_nodes} parameter).When \code{facet == F},all the nodes would be displayed in one
#' network.Colors are used to specify the groups, the size of nodes is proportional to the keyword frequency,
#' while the alpha of edges is proportional to the co-occurrence relationship between keywords.
#' @seealso \code{\link[ggraph]{ggraph}}
#' @import ggplot2
#' @import ggraph
#' @import dplyr
#' @importFrom ggforce theme_no_axes
#' @export
#' @examples
#' library(akc)
#'
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
#' # remove legends
#' bibli_data_table %>%
#'   keyword_clean(id = "id",keyword = "keyword") %>%
#'   keyword_group(id = "id",keyword = "keyword") %>%
#'   keyword_vis() + ggplot2::guides(fill = FALSE)

keyword_vis = function(tibble_graph,facet = T,max_nodes = 10){

  if(!is.tbl_graph(tibble_graph)) stop("keyword_vis only receives class 'tbl_graph'.")

  if(facet == F){
    tibble_graph %>%
      group_by(group) %>%
      top_n(max_nodes,freq) %>%
      ungroup() %>%
      mutate(Group = str_c("Group ",group)) %>%
      ggraph("kk") +
      geom_edge_link(aes(alpha = n),show.legend = F) +
      geom_node_point(aes(size = freq),show.legend = F) +
      geom_node_label(aes(label = name,fill = Group),repel = T) +
      guides(fill = F) +
      theme_no_axes()
  }else{
    tibble_graph %>%
      group_by(group) %>%
      top_n(max_nodes,freq) %>%
      ungroup() %>%
      mutate(Group = str_c("Group ",group)) %>%
      ggraph("kk") +
      geom_edge_link(aes(alpha = n),show.legend = F) +
      geom_node_point(aes(size = freq),show.legend = F) +
      geom_node_label(aes(label = name,fill = Group),repel = T) +
      guides(fill = F) +
      facet_nodes(~Group) +
      theme_no_axes()
  }

}
