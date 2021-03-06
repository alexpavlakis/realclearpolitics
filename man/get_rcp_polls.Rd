% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_rcp.R
\name{get_rcp_polls}
\alias{get_rcp_polls}
\title{Return table of polls from realclearpolitics web page.}
\usage{
get_rcp_polls(url, ...)
}
\arguments{
\item{url}{the URL of the realclearpolitics page}

\item{...}{Additional arguments}
}
\value{
A tibble version of the realclearpolitics race table
}
\description{
Return table of polls from realclearpolitics web page.
}
\examples{
# Return all polls of Donald Trump's approval rating and "tidy":
d <- get_rcp_polls(
url = "https://www.realclearpolitics.com/epolls/other/president_trump_job_approval-6179.html#polls")
tidied_data <- tidy(d)
}
