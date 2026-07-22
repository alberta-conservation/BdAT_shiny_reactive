tagList(
  navbarPage(
    theme = bslib::bs_theme(version = 5, bootswatch = "lux"),
    id = 'tabs',
    collapsible = TRUE,
    
    # Describes the top header bar with tabs
    header = tagList(
      tags$head(tags$link(href = "css/style_blank_II.css", rel = "stylesheet")
      ), 
      
      tags$div(
        style = "position: absolute; right: 20px; top: 10px;",
        actionButton(
          "reload_btn",
          label = "Reload",
          icon = icon("refresh"),
          style = "color: white; background-color: rgb(30, 80, 85); border: none; font-size: 16px; margin-top: 8px;"
        ),
        style = "position: absolute; right: 20px; top: 10px;" # adjust position
      )
    ),
    title = HTML('<div style="margin-top: 0px;"><a href="https://github.com/alberta-conservation" target="_blank"><img src="abc-program-logo.png" height="50"></a></div>'),
    windowTitle = "OSR Biodiversity Assessment tool",
    tabPanel("Welcome", value = 'intro'),
    tabPanel("Vulnerability assessment", value = 'vulnerability'),
    tabPanel("Risk Assessment", value = 'risk'),
    tabPanel("Recommendations", value = 'recommendations'), 
    navbarMenu("Species of Special Concern", 
               tabPanel("Overview", value = "soc"), 
               tabPanel("Pileated Woodpecker", value = "piwo"), 
               tabPanel("Yellow Rail", value = "yera"), 
               tabPanel("Rusty Blackbird", value = "rubl"), 
               tabPanel("Canadian Toad", value = "cato"), 
               tabPanel("Sharp-tailed Grouse", value = "stgr"), 
               tabPanel("Whooping Crane", value = "whcr"), 
    )
  ),
  
  tags$div(
    
    useShinyjs(),
    
    conditionalPanel(
      condition="input.tabs == 'intro'",
      div(style = "background-color: white; width: 100vw; margin: 0; padding: 0; display: flex; justify-content: center;",
          tags$img(src = "osr.png", height = "300px",  style = "display: block; object-fit: contain; width: 100%; max-width: none;")),
    
      fluidRow(
        column(2, layout_sidebar(
          sidebar = sidebar(
            position = "left"
          )
        )),
        
        column(10, div(id = "markdown-content", includeMarkdown("Rmd/text_intro_tab.md")))
      )
    ), 
  
  
  # Layout for vulnerability and risk tabs
  conditionalPanel(
    condition = "input.tabs == 'vulnerability' || input.tabs == 'risk'", 
    fluidRow(
      column(3, 
             conditionalPanel(
               condition = "input.tabs == 'vulnerability'", 
               tabsetPanel(
                 tabPanel("Tool", 
                          selectInput(
                            inputId = "spp", 
                            label = "Select a species", 
                            choices = spp_tbl$CommonName, 
                            selected = "Black-throated Green Warbler"),
                          checkboxGroupInput(
                            inputId = "prod_field",
                            label = "Choose the Oil Sands Area:",
                            choices = c("Athabasca", "Cold Lake", "Peace River Area 1", "Peace River Area 2"),
                            selected = "Athabasca" # Optional: pre-select an item
                          ), 
                          selectInput(
                            inputId = "app_holder", 
                            label = "Select a lease holder:", 
                            choices = lease_holders$lease_holder, 
                            selected = "Suncor Energy Inc."
                          ), 
                          actionButton(inputId = "co_prodField", 
                                       label = "Show selected AOI and leases", 
                                       icon = icon(name = "fas fa-crow", lib = "font-awesome"), 
                                       style="width:200px;"
                          ), 
                          
                          actionButton(inputId = "render_report", 
                                       label = "Create report", 
                                       style="margin-top: 20px; width: 200px;"
                          )
                 ), 
                 tabPanel("Instructions", 
                          icon = icon("circle-info"), 
                          div(style = "color: white !important; font-size: 14px; font-family: 'Cormorant Garamond', serif;", 
                              includeMarkdown("./Rmd/gtext_exposure.Rmd")
                          )
                 )
               )
             ), 
             conditionalPanel(
               condition = "input.tabs == 'risk'", 
               tabsetPanel(
                 tabPanel("Tool",  
                          selectInput(
                            inputId = "risk_spp", 
                            label = "Select a species", 
                            choices = risk_species$CommonName, 
                            selected = "Ovenbird"),
                          selectInput(
                            inputId = "lease_name", 
                            label = "Select total area or lease area:", 
                            choices = c("Total area", "All leases", risk_leases$lease_name), 
                            selected = "Suncor Energy Inc."
                          ), 
                          actionButton(inputId = "spp_lease", 
                                       label = "Show selected species and area", 
                                       icon = icon(name = "fas fa-crow", lib = "font-awesome"), 
                                       style="width:200px"), 
                          
                          actionButton(inputId = "render_risk_report", 
                                       label = "Create report", 
                                       style="margin-top: 20px; width: 200px;"
                          )
                 ), 
                 tabPanel("Instructions", 
                          icon = icon("circle-info"), 
                          div(style = "color: white !important; font-size: 14px; font-family: 'Cormorant Garamond', serif;", 
                              includeMarkdown("./Rmd/gtext_risk.Rmd")
                          )
                 )
               )
             )
      ), 
      column(6, 
             conditionalPanel(
               condition = "input.tabs == 'vulnerability'", 
               tabsetPanel(id ="centerPanel",
                           tabPanel("Reference Exposure", 
                                    leafletOutput(outputId = "map", width = "100%", height = "400px") 
                           ),
                           tabPanel("Current Exposure",
                                    leafletOutput(outputId = "map_current", width = "100%", height = "400px")
                           ), 
                           tabPanel("Methods", 
                                    div(id = "markdown-content", includeMarkdown("Rmd/text_vulnerability_methods.Rmd"))
                           )
               )
             ), 
             conditionalPanel(
               condition = "input.tabs == 'risk'", 
               tabsetPanel(
                 tabPanel("Density distributions", 
                          plotOutput("dens_plot")
                 ),
                 tabPanel("Risk estimates",
                          plotOutput("decline_plot")
                 ) , 
                 tabPanel("Methods", 
                          div(id = "markdown-content", includeMarkdown("Rmd/text_risk_methods.Rmd"))
                 )
               )
             )
      ), 
      column(3, 
             conditionalPanel(
               condition = "input.tabs == 'vulnerability'",
               div(id = "markdown-content", includeMarkdown("Rmd/data_download_tab.md")),
               actionButton(inputId = "dwnld_dta", 
                            label = "Download Data", 
                            style="width: 250px;"), 
               
               actionButton(inputId = "dwnld_report", 
                            label = "Download report", 
                            style="margin-top: 20px;  width: 250px;")
             ), 
             conditionalPanel(
               condition = "input.tabs == 'risk'",
               div(id = "markdown-content", includeMarkdown("Rmd/risk_download_tab.md")), 
               actionButton(inputId = "dwnld_dta", label = "Download Data", icon = icon(name = "fas fa-crow", lib = "font-awesome"), style="width:250px"), 
               
               actionButton(inputId = "dwnld_report", 
                            label = "Download report", 
                            style="margin-top: 20px;  width: 250px;")
             )
      ), 
      column(12,  
             conditionalPanel(
               condition = "input.tabs == 'vulnerability'", 
               
             ) # conditionalPanel(
      ) # column(12,
    )
  )
  ), 
  
  tags$head(
    tags$style(HTML("
    #shiny-notification-panel {
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      bottom: unset;
      right: unset;
      position: fixed;
    }
  "))
  )
  
)



