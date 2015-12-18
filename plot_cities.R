## Plot wikipedia page views for 3 different cities

library(ggplot2)

cities <- data.frame()
pages <- data.frame(page = c("St._Louis","Atlanta","Austin,_Texas"))

for(i in 1:length(pages$page)){
     cities <- rbind(cities, 
                        get.wikipedia.data(page=pages$page[i], 
                                           start="20150801",end="20151215"))
}

# Wikipedia page views for Austin, Atlanta, St. Louis
ggplot(cities, aes(mydate, views, color=page))+geom_line()+ggtitle("Wikipedia page views for Atlanta, Austin, St. Louis (8/1/15 - 12/15/15)")+ylim(c(0,6000))
