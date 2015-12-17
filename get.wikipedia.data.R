## wikipedia API with R (using httr)
## Pass values to wikipedia RESTbase API, and retrieve page view data (for agent = user)

# doc: https://wikimedia.org/api/rest_v1/?doc#!/Pageviews_data/get_metrics_pageviews_top_project_access_year_month_day

get.wikipedia.data <- function(url.base = "https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article/en.wikipedia/all-access/user",
                               page, granularity = "daily", start="20150801", end){
                                                            # the start and end arguments should be of format "YYYYMMDD"
     
     # load packages and set up GET request with constructed url from function arguments
     require(httr)
     require(dplyr)
     require(lubridate)
     url.call <- paste(url.base, page, granularity, start, end, sep="/")
     response <- GET(url.call, accept_json())
     response.content <- content(response, as="parsed")
     
     # extract and clean "views" information from GET request
     views <- as.data.frame(
          t(
               sapply(response.content$items, 
                      function(x) list(x$timestamp, x$views))))
     
     names(views) <- c("timestamp", "views")
     
     views$timestamp <- as.character(views$timestamp)
     views$views <- as.numeric(views$views)
     
     # return a data frame of date, views, and the function argument "page"
     views %>% 
          mutate(   year = as.numeric(substring(timestamp, 1, 4)),
                    month = as.numeric(substring(timestamp, 5, 6)),
                    day = as.numeric(substring(timestamp, 7, 8))) %>% 
          mutate(mydate = mdy(paste(month, day, year, sep="/")),
                 page = page) %>%
               select(mydate, views, page)
}
