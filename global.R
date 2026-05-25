options(repos = c(CRAN = "https://cran.rstudio.com"))

required_packages <- c("bslib", "leaflet", "markdown", "rmarkdown", "sf", "shiny", 
                       "shinydashboard", "shinyjs", "terra", "tidyverse")


invisible(lapply(required_packages, library, character.only = TRUE))

load("www/data/sysdata.rda")


