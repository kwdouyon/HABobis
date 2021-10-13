#' function retrieves OBIS data by species

#' @param species chr, name of species to retrieve
#' @param path chr, path to where data is saved
#' @return tibble of species data


hist(as.numeric(taxon.data$year),
     min(as.numeric(taxon.data$year),na.rm = T):max(as.numeric(taxon.data$year),na.rm = T),
     
     ylab = 'Observations',
     xlab = 'Year',
     main = '')

sst_plot <- function(species = 'Dinophysis acuta',
                     path = "~/Documents/data/habobis/sstplot"){
 
} 


fetch_species <- function(species = 'Dinophysis acuta',
                          path = "~/Documents/data/habobis/rawdata"){
  taxon.data <- robis::occurrence(species[1])
  taxon.name = gsub(" ","_", tolower(species))
  readr::write_csv(taxon.data, file.path(path[1],paste0(taxon.name,".csv.gz")))
  return(taxon.data)
} 

get.observation.number <- function(species = 'Dinophysis acuta',
                          path = "~/Documents/data/habobis/rawdata"){
  taxon.name = gsub(" ","_", tolower(species))
  hab1 <- readr::read_csv(file.path(path[1],paste0(taxon.name,".csv.gz")))
  obs <- dim(hab1)[1]
  return(obs)
} 

sss_plot <- function(species = 'Dinophysis acuta',
                     path = "~/Documents/data/habobis/sssplot"){
  taxon.data <- robis::occurrence(species[1])
  taxon.name = gsub(" ","_", tolower(species))
  readr::write_csv(taxon.data, file.path(path[1],paste0(taxon.name,".csv.gz")))
  return(taxon.data)
} 

