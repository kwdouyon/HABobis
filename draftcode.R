library(ggplot2)
#install.packages("extrafont")

library(extrafont)
font_import()

library(Hmisc)

source('~/Documents/GitHub/HABobis/file.R')

hab.list <- list.files(path = "~/Documents/data/habobis/rawdata", pattern = '.csv.gz')
#View(hab.list)
names(hab.list) <- latin.name(hab.list)

if(FALSE){
  obs.list = sapply(names(hab.list), read.occurence, simplify = FALSE)
}

obs.count <- sapply(obs.list, nrow)
var.count <- sapply(obs.list, ncol)

for (j in seq_along(hab.list)) {
  obs.count[j] <- get.observation.number(hab.list[j])
}


obs.count2 <- sapply(hab.list, get.observation.number)

obs.data <- data.frame(Species = hab.list, Observations = obs.count)

obs.data$Species <- gsub("_"," ", obs.data$Species)
obs.data$Species <- gsub(".csv.gz","", obs.data$Species)



top.15hab <- head(obs.data[order(obs.data$Observations,decreasing = TRUE),], 15)


top.15hab <- transform(top.15hab, 
                          Species = reorder(Species, Observations))

top.15hab <- capitalize(top.15hab$Species)

ggplot(data = top.15hab, aes(x = Species, y = Observations)) +
  geom_bar(stat = "identity", fill = "dodgerblue3") +
  geom_text(aes(label= Observations), vjust=.5, color="black", size=2, hjust = -0.1, fontfanily = "Times") +
  labs(title = "Distribution of Top 15 Recorded HAB Species",
       y = "Observation Count",
       x = "Species",
       caption = "Source: OBIS") +
  coord_flip() +
  theme_classic() +
  theme(text = element_text(family = "Times"),
        plot.title = element_text(face = "bold", size = 15),
        axis.text = element_text(size = 11)) 

obs.data <- transform(obs.data, 
                       Species = reorder(Species, Observations))


ggplot(data = top.3hab, aes(x = Species, y = Observations)) +
  geom_bar(stat = "identity", fill = "dodgerblue3") +
  geom_text(aes(label= Observations), vjust=.5, color="black", size=2, hjust = -0.1, fontfanily = "Times") +
  labs(title = "Distribution of Top 15 Recorded HAB Species",
       y = "Observation Count",
       x = "Species",
       caption = "Source: OBIS") +
  coord_flip() +
  theme(text = element_text(family = "Times"),
        plot.title = element_text(face = "bold", size = 15),
        axis.text = element_text(size = 10)) 

top.3hab <- head(obs.data[order(obs.data$Observations,decreasing = TRUE),], 3)


