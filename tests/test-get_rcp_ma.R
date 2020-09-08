library(realclearpolitics)

# Make sure that get_rcp_polls can pull data
obama_romney_ma <- get_rcp_ma(id = 1171)

if(!identical(class(obama_romney_ma), c("rcp_series", "tbl_df", "tbl", "data.frame"))) {
  stop("get_rcp_ma was unable to properly pull polls of Obama-Romney in 2012")
} else {
  print('get_rcp_ma is working as expected')
}
