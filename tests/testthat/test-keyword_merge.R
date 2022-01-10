test_that("merge keywords", {
  expect_equal(
    bibli_data_table[1:3,] %>%
      keyword_clean(lemmatize = FALSE) %>%
      keyword_merge(reduce_form = "stem") %>%
      pull(keyword) %>% head(),
    c("austerity", "community capacity", "comparative librarianship", "continuation will of volunteering", "contributing intention to the library", "korea")
  )
})
