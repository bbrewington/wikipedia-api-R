## get star wars wikipedia page data and create plot

library(scales)
library(dplyr)
library(ggplot2)
pages <- data.frame(page = c("Mark_Hamill","Luke_Skywalker","George_Lucas","Jar_Jar_Binks","Yoda",
                             "Carrie_Fisher","Harrison_Ford","Han_Solo","Alec_Guinness","Obi-Wan_Kenobi",
                             "Star_Wars_Episode_I:_The_Phantom_Menace","Star_Wars_Episode_II:_Attack_of_the_Clones",
                             "Star_Wars_Episode_III:_Revenge_of_the_Sith","Star_Wars_(film)",
                             "The_Empire_Strikes_Back","Return_of_the_Jedi","Star_Wars:_The_Force_Awakens"),
                    category = c("cast", "character", "cast", "character", "character",
                                 "cast", "cast", "character", "cast", "character",
                                 "movie","movie",
                                 "movie","movie",
                                 "movie","movie","movie"))

movies <- data.frame(page = c("Star_Wars_Episode_I:_The_Phantom_Menace","Star_Wars_Episode_II:_Attack_of_the_Clones",
                     "Star_Wars_Episode_III:_Revenge_of_the_Sith","Star_Wars_(film)",
                     "The_Empire_Strikes_Back","Return_of_the_Jedi","Star_Wars:_The_Force_Awakens"),
                     trilogy = c("Ep 1-3","Ep 1-3","Ep 1-3","original","original","original","Ep 7-9"))

star.wars <- data.frame()
for(i in 1:length(pages$page)){
     star.wars <- rbind(star.wars, 
                        get.wikipedia.data(page=pages$page[i], 
                                           start="20150801",end="20151215"))
}

star.wars <- left_join(pages, star.wars, by="page")

## plot of wikipedia page views of star wars episodes 1-7
ggplot(star.wars %>% filter(category=="movie"), 
       aes(mydate, views, color=page))+geom_line(size=1)+
     ggtitle("Star Wars Episodes 1-7: Wikipedia Page Views August-December 2015") + 
     scale_y_continuous(name = "page views",labels=comma) + xlab("Date")

## plot of wikipedia page views of star wars characters and cast
ggplot(star.wars %>% filter(category!="movie"), 
       aes(mydate, views, color=page))+geom_line(size=1)+
     ggtitle("Star Wars: Wikipedia Page Views of characters and cast August-December 2015") + 
     scale_y_continuous(name = "page views",labels=comma) + xlab("Date")
