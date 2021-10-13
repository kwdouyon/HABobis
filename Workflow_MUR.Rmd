MUR Extraction
================

## Read in observations

``` r
species <- c('Alexandrium catenella','Karenia brevis', 'Karenia mikimotoi', 'Pseudo-nitzschia seriata', 'Pseudo-nitzschia australis','Dinophysis borealis')

path = "/mnt/ecocast/projectdata/students/kenny/habobis/rawdata"

bb = cofbb::get_bb("nwa2")

x <- lapply(species,
             function(specie) {
               x = read.occurence(species = specie, 
                                  bb = bb, 
                                  path = path)  %>%
                   dplyr::mutate(date = as.Date(date))
               return(x)
})  %>% 
  dplyr::bind_rows()

x
```

    ## # A tibble: 3,031 × 10
    ##    scientific_name       date         lon   lat genus   eventDate      sst   sss
    ##    <chr>                 <date>     <dbl> <dbl> <chr>   <chr>        <dbl> <dbl>
    ##  1 Alexandrium catenella 1988-05-25 -66.8  45.0 Alexan… 1988-5-25 0…  8.5   30.0
    ##  2 Alexandrium catenella 1992-06-08 -69.4  41.9 Alexan… 1992-06-08   11.8   32.0
    ##  3 Alexandrium catenella 1988-06-28 -66.8  45.0 Alexan… 1988-6-28 0…  8.48  30.0
    ##  4 Alexandrium catenella 1989-10-11 -66.8  45.1 Alexan… 1989-10-11 …  8.5   30.0
    ##  5 Alexandrium catenella 1988-09-21 -67.1  45.1 Alexan… 1988-9-21 0…  8.42  30.1
    ##  6 Alexandrium catenella 1989-08-02 -66.8  45.1 Alexan… 1989-8-2 0:…  8.5   30.0
    ##  7 Alexandrium catenella 1989-09-20 -66.8  45.0 Alexan… 1989-9-20 0…  8.5   30.0
    ##  8 Alexandrium catenella 2000-07-14 -55.4  49.6 Alexan… 2000-07-14    5.41  31  
    ##  9 Alexandrium catenella 1988-07-28 -67.1  45.1 Alexan… 1988-7-28 0…  8.42  30.1
    ## 10 Alexandrium catenella 1988-07-19 -67.0  45.0 Alexan… 1988-7-19 0…  8.45  30.1
    ## # … with 3,021 more rows, and 2 more variables: shoredistance <dbl>,
    ## #   bathymetry <dbl>

## Determine temporal range

``` r
range(x$date)
```

    ## [1] "1915-06-09" "2020-04-06"

## Load MUR database

``` r
murpath = murtools::mur_path("nwa")
murdb = murtools::read_database(murpath)
murdb
```

    ## # A tibble: 19,473 × 7
    ##    date       year  mmdd  per   param     res   file                            
    ##    <date>     <chr> <chr> <chr> <chr>     <chr> <chr>                           
    ##  1 2004-01-01 2004  0101  DAY   sst       0.01d 20040101090000-JPL-L4_GHRSST-SS…
    ##  2 2004-01-01 2004  0101  DAY   sst_slope 0.01d 20040101090000-JPL-L4_GHRSST-SS…
    ##  3 2004-01-01 2004  0101  DAY   sst_cum   0.01d 20040101090000-JPL-L4_GHRSST-SS…
    ##  4 2004-01-02 2004  0102  DAY   sst       0.01d 20040102090000-JPL-L4_GHRSST-SS…
    ##  5 2004-01-02 2004  0102  DAY   sst_slope 0.01d 20040102090000-JPL-L4_GHRSST-SS…
    ##  6 2004-01-02 2004  0102  DAY   sst_cum   0.01d 20040102090000-JPL-L4_GHRSST-SS…
    ##  7 2004-01-03 2004  0103  DAY   sst       0.01d 20040103090000-JPL-L4_GHRSST-SS…
    ##  8 2004-01-03 2004  0103  DAY   sst_slope 0.01d 20040103090000-JPL-L4_GHRSST-SS…
    ##  9 2004-01-03 2004  0103  DAY   sst_cum   0.01d 20040103090000-JPL-L4_GHRSST-SS…
    ## 10 2004-01-04 2004  0104  DAY   sst       0.01d 20040104090000-JPL-L4_GHRSST-SS…
    ## # … with 19,463 more rows

## Finding MUR temporal range

Find the MUR temporal range and filter the observations to match

``` r
mur_date_range <- range(murdb$date)
x = x %>% dplyr::filter(dplyr::between(date,mur_date_range[1],mur_date_range[2]))
dplyr::count(x, scientific_name)
```

    ## # A tibble: 3 × 2
    ##   scientific_name              n
    ##   <chr>                    <int>
    ## 1 Alexandrium catenella       51
    ## 2 Dinophysis acuminata        80
    ## 3 Pseudo-nitzschia seriata   839
