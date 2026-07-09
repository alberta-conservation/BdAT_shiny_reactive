options(repos = c(CRAN = "https://cran.rstudio.com"))

required_packages <- c("bslib", "leaflet", "markdown", "rmarkdown", "sf", "shiny", 
                       "shinydashboard", "shinyjs", "terra", "tidyverse")


invisible(lapply(required_packages, library, character.only = TRUE))

load("www/data/sysdata.rda")

osr <- st_transform(st_read("www/data/oil_sands_areas.shp"), crs = 4326)[-5, ]
bcr <- st_transform(st_read("www/data/BCR6S.shp"), crs = 4326)
load("www/data/bam_exposure_metrics.rda")
load("www/data/lease_current_exposure_metrics.rda")
load("www/data/lease_reference_exposure_metrics.rda")
load("www/data/osr_current_exposure_metrics.rda")
load("www/data/osr_reference_exposure_metrics.rda")
bcr_exp <- st_transform(bam_exposure_metrics, crs = 4326)
lease_exp_current <- st_transform(lease_exp_current, crs = 4326) |> 
  mutate(osa = replace_values(osa, "ATHABASCA" ~ "Athabasca", "COLD LAKE" ~ "Cold Lake", "PEACE RIVER AREA 1" ~ "Peace River Area 1", "PEACE RIVER AREA 2" ~ "Peace River Area 2"))
lease_exp_ref <- st_transform(lease_exp_ref, crs = 4326) |> 
  mutate(osa = replace_values(osa, "ATHABASCA" ~ "Athabasca", "COLD LAKE" ~ "Cold Lake", "PEACE RIVER AREA 1" ~ "Peace River Area 1", "PEACE RIVER AREA 2" ~ "Peace River Area 2"))

lease_holders <- data.frame(lease_holder = levels(as.factor(lease_exp_ref$lease_holder)))
