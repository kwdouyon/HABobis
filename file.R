library(dplyr)
library(readr)

#' convert from file name to scientific name
#' 
#' @param x chr, name of file
#' @param ext chr, file extension to be removed
#' @param sep chr, separator of file name
#' @return character vector of latin names
latin.name <- function(x = 'alexandrium_affine.csv.gz', ext = '.csv.gz', sep = '_'){
  x = basename(x)
  x = sub(ext, '', x, fixed = TRUE)
  x = paste0(toupper(substring(x, 1,1)),substring(x, 2))
  x = gsub(sep," ", x, fixed = TRUE)
  x
}

#' convert from scientific name to file name
#' 
#' @param x chr, latin name of species
#' @param ext chr, file extension to be added
#' @param sep chr, separator of file name
#' @param path chr, path of which file is stored
#' @return character vector of file names
file.name <- function(x = 'Alexandrium affine', ext = '.csv.gz', sep = "_", path = '.'){
  x = tolower(x)
  x = gsub(" ", sep, x, fixed = TRUE)
  x = paste0(x, ext)
  x = file.path(path, x)
  x
}

#' counts occurrence within each file
#' 
#' @param species chr, name of species
#' @param path chr, path of which file is stored
#' @param ... , extra arguments for file.name
#' @return occurrence count
get.observation.number <- function(species = 'Dinophysis acuta',
                                   path = "~/Documents/data/habobis/rawdata",
                                   ...){
  filename = file.name(species, path = path, ...)
  hab.species <- suppressMessages(readr::read_csv(filename))
  obs.count <- dim(hab.species)[1]
  return(obs.count)
} 

#' reads content of each file
#' 
#' @param species chr, name of species
#' @param path chr, path of which file is stored
#' @param bb num, spatial extent of data (wrt W,E,S,N)
#' @param marine_only log, will extract only marine species
#' @param ... , extra arguments for file.name
#' @return file contents as a tibble
read.occurence <- function(species = 'Dinophysis borealis',
                           path = "~/Documents/data/habobis/rawdata",
                           bb = c(-180,180,-90,90),
                           marine_only = TRUE,
                           ...){
  filename = file.name(species, path = path, ...)
  hab.species <- suppressMessages(readr::read_csv(filename)) %>%
    dplyr::filter(absence == FALSE &
                    dplyr::between(decimalLongitude, bb[1], bb[2]) &
                    dplyr::between(decimalLatitude, bb[3], bb[4])) #%>%
    #dplyr::mutate(date = as.Date(paste(year,month,day,sep = "-"))) 
  if(marine_only){
    hab.species = hab.species %>% dplyr::filter(marine == TRUE)
  }
    hab.species <- hab.species %>% 
      dplyr::select(scientific_name = scientificName,
                  date = date_start,
                  lon = decimalLongitude,
                  lat = decimalLatitude,
                  genus,
                  eventDate,
                  sst,
                  sss,
                  shoredistance,
                  bathymetry)  %>%
      dplyr::mutate(date = as.POSIXct('1970-01-01 00:00:00', tz = 'UTC') + date/1000) %>%
      dplyr::filter(!is.na(date) & !is.na(eventDate))
  return(hab.species)
}

