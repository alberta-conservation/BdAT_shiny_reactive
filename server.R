# Define server logic
server <- function(input, output, session){
  spp_file <- reactive({paste0("Rmd/spp_accounts/text_spp_", spp_tbl[spp_tbl$CommonName == input$spp, ]$SpeciesID, ".md")}) 
  
  output$spp_account <- renderUI({
    req(spp_file)
    
    includeMarkdown(spp_file())
  })
}