
#' @title Flexiable visualization of network (alternative to 'keyword_vis')
#' @description Providing flexible visualization of \code{\link[akc]{keyword_vis}}. The
#' group size would be showed, and user could extract specific group to visualize.
#' @param tibble_graph A \code{tbl_graph} output by \code{\link[akc]{keyword_group}}.
#' @param group_no If one wants to visualize a specific group, gives the group number.
#' Default uses \code{NULL},which returns all the groups.
#' @param facet Whether the figure should use facet or not.
#' @param max_nodes The maximum number of nodes displayed in each group.
#' @param alpha The transparency of label. Must lie between 0 and 1. Default uses 0.7.
#' @return An object yielded by \code{\link[ggraph]{ggraph}}
#' @details If the \code{group_no} is not specified, when \code{facet == TRUE},
#' the function returns a faceted figure with limited number of nodes
#' (adjuseted by \code{max_nodes} parameter). The "N=" shows the total size of the group.
#' @details  When \code{facet == FALSE},all the nodes would be displayed in one
#' network.Colors are used to specify the groups, the size of nodes is proportional to the keyword frequency,
#' while the alpha of edges is proportional to the co-occurrence relationship between keywords.
#' @details If the \code{group_no} is specified, returns the network visualization of the group.
#' If you want to display all the nodes, set \code{max_nodes} to \code{Inf}.
#' @seealso \code{\link[ggraph]{ggraph}},\code{\link[akc]{keyword_vis}}
#' @export
#' @examples
#'
#'  library(akc)
#' \donttest{
#'  bibli_data_table %>%
#'    keyword_clean(id = "id",keyword = "keyword") %>%
#'    keyword_group(id = "id",keyword = "keyword") %>%
#'    keyword_network()
#'
#' # use color with `scale_fill_`
#'  bibli_data_table %>%
#'    keyword_clean(id = "id",keyword = "keyword") %>%
#'    keyword_group(id = "id",keyword = "keyword") %>%
#'    keyword_network() + ggplot2::scale_fill_viridis_d()
#'
#'  # without facet
#'  bibli_data_table %>%
#'    keyword_clean(id = "id",keyword = "keyword") %>%
#'    keyword_group(id = "id",keyword = "keyword") %>%
#'    keyword_network(facet = FALSE)
#'
#' # get Group 5
#'  bibli_data_table %>%
#'    keyword_clean(id = "id",keyword = "keyword") %>%
#'    keyword_group(id = "id",keyword = "keyword") %>%
#'    keyword_network(group_no = 5)
#' }

keyword_network = function(tibble_graph, group_no = NULL,
                           facet = TRUE,max_nodes = 10,alpha = 0.7){

  if(!is.tbl_graph(tibble_graph)) stop("keyword_vis only receives class 'tbl_graph'.")

  suppressWarnings(
    if(is.null(group_no)){
      tibble_graph %>%
        as_tibble() %>%
        add_count(group,name = "group_no") -> net_group_no

      tibble_graph %>%
        inner_join(net_group_no) %>%
        group_by(group) %>%
        top_n(max_nodes,freq) %>%
        ungroup() %>%
        mutate(Group = str_c("Group ",group," (N=",group_no,")") %>%
                 reorder(group)) %>%
        ggraph("kk") +
        geom_edge_link0(aes(alpha = n),show.legend = FALSE) +
        geom_node_point(aes(size = freq),show.legend = FALSE) +
        geom_node_label(aes(label = name,fill = Group),repel = TRUE,alpha = alpha) +
        guides(fill = "none") +
        theme_no_axes() -> g

      if(facet == TRUE) g = g + facet_nodes(~Group)

      g
    } else {
      max_group_no <- tibble_graph %>% as_tibble() %>% .$group %>% max()
      if(group_no > max_group_no)
        stop(paste0("The group does not exist, maximum group number is ",max_group_no))
      else{
        tibble_graph %>%
          filter(group == group_no) %>%
          top_n(max_nodes,freq) %>%
          ggraph("kk") +
          geom_edge_link0(aes(alpha = n),show.legend = FALSE) +
          geom_node_point(aes(size = freq),show.legend = FALSE) +
          geom_node_label(aes(label = name),repel = TRUE,alpha = alpha) +
          guides(fill = "none") +
          theme_no_axes()
      }
    }
  )

}


