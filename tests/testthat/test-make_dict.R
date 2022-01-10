
test_that("make customized dictionary", {
  expect_equal(make_dict(c("a","a","b")),
               data.table(keyword = unique(c("a","a","b")),
                          key = "keyword"))
})
