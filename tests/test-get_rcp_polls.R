library(realclearpolitics)

# Make sure that get_rcp_polls can pull data
trump_approval <- get_rcp_polls(url = "https://www.realclearpolitics.com/epolls/other/president_trump_job_approval-6179.html#polls")

if(!identical(class(trump_approval), c("rcp_table", "tbl_df", "tbl", "data.frame"))) {
  stop("get_rcp_polls was unable to properly pull polls of Donald Trump's approval rating")
} else {
  print('get_rcp_polls is working as expected')
}
