
test_that("clean keywords", {
  expect_equal(
    bibli_data_table[1:2,] %>%
      keyword_clean(),
    tibble::tribble(
      ~id,                            ~keyword,
      1L,                         "austerity",
      1L,                "community capacity",
      1L,              "library professional",
      1L,                  "public libraries",
      1L,           "public service delivery",
      1L, "volunteer relationship management",
      1L,                      "volunteering",
      2L,         "comparative librarianship",
      2L,                             "korea",
      2L,               "library legislation",
      2L,                  "public libraries",
      2L,                          "slovenia")
  )
})

