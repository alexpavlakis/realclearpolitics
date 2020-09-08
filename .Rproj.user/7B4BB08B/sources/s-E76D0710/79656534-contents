#' Return table of polls from realclearpolitics web page.
#'
#' @param url the URL of the realclearpolitics page
#' @param ... Additional arguments
#'
#' @return A tibble version of the realclearpolitics race table
#'
#' @import rvest
#' @import xml2
#' @import dplyr
#' @import ggplot2
#' @import jsonlite
#' @importFrom generics tidy
#' @importFrom tidyr gather
#'
#' @examples
#' # Return all polls of Donald Trump's approval rating and "tidy":
#' d <- get_rcp_polls(
#' url = "https://www.realclearpolitics.com/epolls/other/president_trump_job_approval-6179.html#polls")
#' tidied_data <- tidy(d)
#' @export
get_rcp_polls <- function(url, ...) {
  results <- url %>%
    xml2::read_html() %>%
    rvest::html_table() %>%
    tail(1) %>%
    .[[1]]
  structure(results, class = c("rcp_table", "tbl_df", "tbl", "data.frame"))
}

#' @export
generics::tidy

format_pollster <- function(pollster) {
  res <- gsub("\r\n                            ", " ",
              pollster)
  res <- paste(strsplit(res, "")[[1]][1:round(nchar(res)/2)], collapse = "")
  gsub("[*]", "", res)
}

#' Tidy rcp table
#'
#' @param x an object of class rcp_table
#' @param ... additional arguments.
#' @export
tidy.rcp_table <- function(x, ...) {
  suppressWarnings(
    results <- x %>%
      dplyr::filter(Sample != '--') %>%
      dplyr::mutate(poll_start = sapply(strsplit(Date, " - "), head, 1),
             poll_end = sapply(strsplit(Date, " - "), tail, 1),
             sample_size = as.numeric(sapply(strsplit(Sample, " "), head, 1)),
             sample_type = sapply(strsplit(Sample, " "), tail, 1)) %>%
      rename(pollster = Poll) %>%
      dplyr::select(-one_of('Date', 'Spread', 'Sample', 'MoE')) %>%
      tidyr::gather(answer, pct,
                    -c(pollster, poll_start, poll_end, sample_size, sample_type)) %>%
      mutate(pct = round(pct/100, 2)) %>%
      select(pollster, poll_start, poll_end, sample_size, sample_type, answer, pct) %>%
      arrange(pollster, poll_start, answer)
  )
  results$pollster <- sapply(results$pollster, format_pollster, USE.NAMES = FALSE)
  structure(results, class = c("tbl_df", "tbl", "data.frame"))
}





#' Return realclearpolitics moving average based on the id of the race
#'
#' @param id The RCP id of the race
#' @param ... Additional arguments
#'
#' @return A tibble with the question, answer, date, and percent
#'
#' @import rvest
#' @import xml2
#' @import dplyr
#' @import ggplot2
#' @import jsonlite
#' @importFrom generics tidy
#' @importFrom tidyr gather
#'
#' @examples
#' # Time series RCP moving average for the 2018 senate race between Sherrod Brown and Jim Renacci.
#' d <- get_rcp_ma(id = 6331)
#' @export
get_rcp_ma <- function(id = NULL, ...) {
  # Build URL
  if(!is.null(id)) {
    url <- paste0("https://www.realclearpolitics.com/epolls/json/", id, "_historical.js")
  }
  # Load raw data
  raw_data <- NULL
  tryCatch({
    raw_data <- suppressWarnings(readLines(url))
  },
    error = function(e) print(e)
  )
  if(is.null(raw_data)) {
    stop(paste0("Unable to access RCP moving averages for race id ", id, "."))
  }
  # Drop `return_json` function call from string and extract json
  json_data <- raw_data %>%
    gsub("return_json[(]", "", .) %>%
    gsub("[)];", "", .) %>%
    jsonlite::fromJSON()
  # Extract the dates and values from the json blob
  vals <- dplyr::bind_rows(json_data[[1]][[1]][[1]]) %>%
    dplyr::as_tibble()
  dates <- rep(json_data[[1]][[1]][[2]], each = n_distinct(vals$name))

  # Combine into a data frame.  This is the RCPP 5-poll moving average
  results <- vals %>%
    dplyr::mutate(date = as.Date(tolower(substr(dates, 6, 16)), "%d %b %Y"),
           pct = round(as.numeric(value)/100, 2),
           question = json_data$poll$title) %>%
    dplyr::select(question, date, answer = name, pct)
  structure(results, class = c("rcp_series", "tbl_df", "tbl", "data.frame"))
}

#' @export
plot.rcp_series <- function(x, ...) {
  x %>%
    ggplot2::ggplot() +
    ggplot2::aes(x = date, y = pct, col = answer) +
    ggplot2::geom_line() +
    ggplot2::theme_minimal() +
    ggplot2::labs(title = x$question[1], col = NULL,
         x = NULL, y = NULL) +
    ggplot2::theme(legend.position = 'bottom',
          panel.grid.minor = element_blank(),
          axis.text.x = element_text(angle = 45, hjust = 1))
}

