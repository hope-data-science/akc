test_that("group keywords", {
  expect_equal(
    bibli_data_table %>%
      keyword_clean(id = "id",keyword = "keyword") %>%
      keyword_group(id = "id",keyword = "keyword") %>%
      as_tibble() %>%
      head(),
    tibble::tribble(
      ~name, ~freq, ~group,
      "information literacy",   58L,     4L,
      "academic libraries",  133L,     1L,
      "archives",   12L,     4L,
      "higher education",   16L,     4L,
      "bibliometrics",   31L,     3L,
      "assessment",   15L,     2L
    )
  )
})
