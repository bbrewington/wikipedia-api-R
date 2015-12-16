## wikipedia API with R (using httr)
# doc: https://wikimedia.org/api/rest_v1/?doc#!/Pageviews_data/get_metrics_pageviews_top_project_access_year_month_day

get.wikipedia.data <- function(url.base = "https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article/en.wikipedia/all-access/all-agents",
                               page, granularity = "daily", start, end){
     require(httr)
     require(dplyr)
     require(magrittr)
     require(lubridate)
     
     url.call <- paste(url.base, page, granularity, start, end, sep="/")
     
     response <- GET(url.call, accept_json())
     response.content <- content(response, as="parsed")
     
     views <- as.data.frame(
          t(
               sapply(response.content$items, 
                      function(x) list(x$timestamp, x$views))))
     
     names(views) <- c("timestamp", "views")
     
     views$timestamp <- as.character(views$timestamp)
     views$views <- as.numeric(views$views)
     
     views %>% 
          mutate(   year = as.numeric(substring(timestamp, 1, 4)),
                    month = as.numeric(substring(timestamp, 5, 6)),
                    day = as.numeric(substring(timestamp, 7, 8))) %>% 
          mutate(mydate = mdy(paste(month, day, year, sep="/")))
}
