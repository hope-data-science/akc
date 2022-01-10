test_that("keyword_table", {
  expect_equal(
    bibli_data_table[1:3,] %>%
      keyword_clean(id = "id",keyword = "keyword") %>%
      keyword_group(id = "id",keyword = "keyword") %>%
      keyword_table() %>% pull(2),
    c("continuation will of volunteering (1); contributing intention to the library (1); public library volunteering (1); vfi (1); volunteer function inventory (1); volunteer satisfaction (1); volunteering motivation (1); volunteerism in public library (1)", "austerity (1); community capacity (1); library professional (1); public service delivery (1); volunteer relationship management (1); volunteering (1)", "public libraries (2); comparative librarianship (1); korea (1); library legislation (1); slovenia (1)")
  )
})
