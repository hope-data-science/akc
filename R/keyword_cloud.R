
#' @title Draw word cloud for grouped keywords
#'
#' @description This function should be used to plot the object exported by
#' \code{\link[akc]{keyword_group}}. It could draw a robust word cloud of keywords.
#' @param tibble_graph A \code{tbl_graph} output by \code{\link[akc]{keyword_group}}.
#' @param group_no If one wants to visualize a specific group, gives the group number.
#' Default uses \code{NULL},which returns all the groups.
#' @param top How many top keywords (by frequency) should be plot? Default uses 50.
#' @param max_size Size of largest keyword.Default uses 20.
#' @details In the output graph, the size of keywords is proportional to the keyword
#' frequency, keywords in different colours belong to different group. For advanced
#' usage of word cloud, use \pkg{ggwordcloud} directly with the grouped keywords
#' yielded by \code{\link[akc]{keyword_group}}.
#' @seealso \code{\link[akc]{keyword_group}},
#' \code{\link[ggwordcloud]{geom_text_wordcloud_area}}
#' @importFrom ggwordcloud geom_text_wordcloud_area
#' @export
#' @examples
#'
#' library(dplyr)
#' library(akc)
#'
#' \donttest{
#'   bibli_data_table %>%
#'     keyword_clean(id = "id",keyword = "keyword") %>%
#'     keyword_group(id = "id",keyword = "keyword") -> grouped_keyword
#'
#'   grouped_keyword %>%
#'     keyword_cloud()
#'
#'   grouped_keyword %>%
#'     keyword_cloud(group_no = 1)
#' }

keyword_cloud = function(tibble_graph,group_no = NULL,top = 50,max_size = 20){
  if(is.null(group_no))
    tibble_graph %>%
    as_tibble() %>%
    top_n(top,freq) %>%
    mutate(group = as.factor(group)) %>%
    ggplot(aes(label = name,size = freq,colour = group,x=group)) +
    geom_text_wordcloud_area() +
    scale_size_area(max_size = max_size) +
    scale_x_discrete(breaks = NULL,name = "") +
    theme_minimal()
  else{
    tibble_graph %>%
      as_tibble() %>%
      filter(group == group_no) %>%
      top_n(top,freq) %>%
      ggplot(aes(label = name,size = freq)) +
      geom_text_wordcloud_area() +
      scale_size_area(max_size = max_size) +
      #scale_x_discrete(breaks = NULL,name = "") +
      theme_minimal()
  }
}


