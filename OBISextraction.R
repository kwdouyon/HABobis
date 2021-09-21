#' function retrieves OBIS data by species

#' @param species chr, name of species to retrieve
#' @param path chr, path to where data is saved
#' @return tibble of species data

library(dplyr)

hab <- read.csv('~/Documents/data/habobis/habslist.csv')

hab.species.only <- hab %>% filter(grepl(' ', ScientificName))

species.list <- hab.species.only$ScientificName

for (j in 1:319) {
  taxon.data <- robis::occurrence(as.character(species.list[j]))
fetch_species(as.character(species.list[j]))
}


fetch_species <- function(species = 'Dinophysis acuta',
                          path = "~/Documents/data/habobis"/"rawdata"){
  taxon.data <- robis::occurrence(species[1])
  taxon.name = gsub(" ","_", tolower(species))
  readr::write_csv(taxon.data, file.path(path[1],paste0(taxon.name,".csv.gz")))
  return(taxon.data)
} 

