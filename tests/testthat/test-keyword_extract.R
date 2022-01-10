test_that("extract keywords", {
  expect_equal(
    bibli_data_table[1,] %>%
      keyword_extract(id = "id",text = "abstract") %>%
      head(),
    tibble::tribble(
      ~id,                       ~keyword,
      1L,                      "english",
      1L,               "english public",
      1L,     "english public libraries",
      1L, "english public libraries are",
      1L,                       "public",
      1L,             "public libraries"
    )
  )
})
