## sustainability.R: get daily user view data for each page link on the Index of Sustainability Articles

fileurl <- "https://en.wikipedia.org/wiki/Index_of_sustainability_articles"

doc <- read_html(fileurl)

sustainability.pages <- 
     doc %>% 
     html_nodes("#mw-content-text > p > a") %>% 
     html_attr(name="href") %>% substr(7,nchar(.))

sustainability.pages <- sustainability.pages[!grepl("redlink",sustainability.pages)]

source("https://raw.githubusercontent.com/bbrewington/wikipedia-api-R/master/get.wikipedia.data.R")
mydf <- data.frame()

for(i in 1:length(sustainability.pages)){
     mydf <- rbind(mydf, get.wikipedia.data(page = sustainability.pages[i], end="20151215"))
}
