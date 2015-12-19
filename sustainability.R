## sustainability.R: get daily user view data for each page link on the Index of Sustainability Articles
library(rvest)
library(dplyr)
library(magrittr)
library(ggplot2)

get.sustainability.data <- function(end.date = gsub("-","",today())){
     fileurl <- "https://en.wikipedia.org/wiki/Index_of_sustainability_articles"
     
     doc <- read_html(fileurl)
     
     sustainability.pages <- 
          doc %>% 
          html_nodes("#mw-content-text > p > a") %>% 
          html_attr(name="href") %>% substr(7,nchar(.))
     
     sustainability.pages <- sustainability.pages[!grepl("redlink",sustainability.pages)]
     
     source("https://raw.githubusercontent.com/bbrewington/wikipedia-api-R/master/get.wikipedia.data.R")
     wikipedia.sustainability <- data.frame()
     
     for(i in 1:length(sustainability.pages)){
          wikipedia.sustainability <- rbind(wikipedia.sustainability, get.wikipedia.data(page = sustainability.pages[i], end.date))
     }
}

if(!file.exists("sustainability.Rda")){
     sustainability <- get.sustainability.data()
} else {
     load("sustainability.Rda")
}

sustainability %<>% mutate(weekday = wday(mydate),
                                    monthday = mday(mydate),
                                    month = month(mydate),
                                    week = week(mydate),
                                    year = year(mydate),
                                    quarter = quarter(mydate))

page.volume <- sustainability %>% 
     group_by(page) %>% 
     summarise(mean.views = mean(views)) %>% 
     top_n(15, mean.views) %>% mutate(volume = "top")
     
sustainability %<>% left_join(page.volume, by="page")

date.seq <- seq(mdy("8/1/15"), mdy("12/9/15"), by = "1 day")
week.xref <- data.frame(start.date = date.seq,
                        week = week(date.seq),
                        weekday = wday(date.seq)) %>% 
                              filter(weekday==1) %>% 
                              select(-weekday)

ggplot(sustainability %>% filter(volume == "top") %>% group_by(week,page) %>% summarise(weekly.views = sum(views)) %>% left_join(week.xref, by="week"),
            aes(start.date, weekly.views)) +
     geom_line(size=1) + facet_wrap(~page) + ylab("Weekly Page Views") + xlab("Month") +
     ggtitle("Weekly View count of Top 5 Sustainability Articles (2015 Aug - Dec)")

