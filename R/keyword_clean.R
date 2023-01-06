
#' @title Automatic keyword cleaning and transfer to tidy format
#'
#' @description Carry out several keyword cleaning processes automatically and return a tidy table with
#' document ID and keywords.
#' @param df A data.frame containing at least two columns with document ID and keyword strings with separators.
#' @param id Quoted characters specifying the column name of document ID.Default uses "id".
#' @param keyword Quoted characters specifying the column name of keywords.Default uses "keyword".
#' @param sep Separator(s) of keywords. Default uses ";".
#' @param rmParentheses Remove the contents in the parentheses (including the parentheses) or not. Default
#' uses TRUE.
#' @param rmNumber Remove the pure number sequence or no. Default uses TRUE.
#' @param lemmatize Lemmatize the keywords or not. Lemmatization is supported by `lemmatize_strings` function
#' in `textstem` package.Default uses FALSE.
#' @param lemmatize_dict A dictionary of base terms and lemmas to use for replacement.
#'  Only used when the \bold{lemmatize} parameter is \code{TRUE}.
#'  The first column should be the full word form in lower case
#'  while the second column is the corresponding replacement lemma.
#'  Default uses \code{NULL}, this would apply the default dictionary used in
#'  \code{\link[textstem]{lemmatize_strings}} function.
#' @details The entire cleaning processes include:
#' 1.Split the text with separators;
#' 2.Remove the contents in the parentheses (including the parentheses);
#' 3.Remove white spaces from start and end of string and reduces repeated white spaces inside a string;
#' 4.Remove all the null character string and pure number sequences;
#' 5.Convert all letters to lower case;
#' 6.Lemmatization.
#' Some of the procedures could be suppressed or activated with parameter adjustments.
#' Default setting did not use lemmatization, it is suggested to use \code{\link[akc]{keyword_merge}} to
#' merge the keywords afterward.
#' @return A tbl with two columns, namely document ID and cleaned keywords.
#' @seealso \code{\link[akc]{keyword_merge}}
#' @import stringr
#' @import dplyr
#' @importFrom tidytext unnest_tokens
#' @importFrom textstem lemmatize_strings
#' @importFrom tibble as_tibble
#' @export
#' @examples
#' library(akc)
#'
#' bibli_data_table
#'
#' bibli_data_table %>%
#'   keyword_clean(id = "id",keyword = "keyword")

keyword_clean = function(df,id = "id",keyword = "keyword",
                          sep = ";",
                          rmParentheses = TRUE,
                          rmNumber = TRUE,
                          lemmatize = FALSE,
                         lemmatize_dict = NULL){
  df %>%
    as_tibble() %>%
    transmute(id = .data[[id]],keyword = .data[[keyword]]) %>%
    unnest_tokens(keyword,keyword,token = str_split,pattern = sep) %>%
    mutate(keyword = str_squish(keyword)) %>%
    filter(keyword != "") -> dt

  if(rmParentheses == TRUE) {
    dt = dt %>% mutate(keyword = str_replace_all(keyword,"\\(.+?\\)",""))
  }

  if(rmNumber == TRUE) dt = dt %>% filter(!str_detect(keyword,"^[:digit:]*$"))

  if(lemmatize == TRUE) {
    if(is.null(lemmatize_dict))
      dt = dt %>% mutate(keyword = lemmatize_strings(keyword))
    else
      dt = dt %>% mutate(keyword = lemmatize_strings(keyword,dictionary = lemmatize_dict))
  }

  dt
}
