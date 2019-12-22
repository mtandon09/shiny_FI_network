library(shiny)
# library(DT)
library(shinyjs)
library(shinyBS)

# Define UI for data upload app ----
shinyUI(fluidPage(
  
    # App title ----
    titlePanel("Annotated Functional Gene Interaction Network"),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
      
      # Sidebar panel for inputs ----
      sidebarPanel(
        
        # Input: Select a file ----
        textAreaInput("query_gene_list", "Enter genes to make a network from:",
                  placeholder="e.g. BRCA2, MSH2"),
        tags$hr(),
        checkboxInput("include_neighbors", "Include neighboring genes?", TRUE),
        
        tags$br(),
        actionButton("make_plot", "Make Plot"),
        
        tags$hr(),
        tags$em("[Optional]"),
        tags$hr(),
        # Input: Select a file ----
        fileInput("diff_exp_file", "Choose differential expression file",
                  multiple = FALSE,
                  accept = c("text/csv",
                             "text/comma-separated-values,text/plain",
                             ".csv","xlsx",".xls")),
        
        # Horizontal line ----
        # tags$hr(),
        
        # Input: Checkbox if file has header ----
        checkboxInput("header", "Header", TRUE),
        
        # Input: Select separator ----
        radioButtons("sep", "Separator",
                     choices = c(Comma = ",",
                                 Semicolon = ";",
                                 Tab = "\t"),
                     selected = ","),
        
        # Horizontal line ----
        tags$hr(),
        
        # Input: Select a file ----
        fileInput("maf_file", "Choose MAF file",
                  multiple = FALSE,
                  accept = c("text/csv",
                             "text/comma-separated-values,text/plain",
                             ".csv","xlsx",".xls")),
        
        # Horizontal line ----
        tags$hr(),
        
        # Input: Checkbox if file has header ----
        # checkboxInput("header", "Header", TRUE),
        # 
        # # Input: Select separator ----
        # radioButtons("sep", "Separator",
        #              choices = c(Comma = ",",
        #                          Semicolon = ";",
        #                          Tab = "\t"),
        #              selected = ","),
        
        # Horizontal line ----
        tags$hr()
        
      ),
      
      # Main panel for displaying outputs ----
      hidden(
        
        mainPanel(id="mainpanel",
                  
                  tabsetPanel(id="tab", type="pills",
                              
                              #Somatic Mutation Prevalence
                              tabPanel("Network Plot",value="contents",
                                       br(),
                                       # plotOutput("net_plot", width = "100%", height = "400px", click = NULL,
                                       plotOutput("net_plot", width = "90%", height = "600px", click = NULL,
                                                  dblclick = NULL, hover = NULL, hoverDelay = NULL,
                                                  hoverDelayType = NULL, brush = NULL, clickId = NULL,
                                                  hoverId = NULL, inline = FALSE),
                                       
                                       br(),
                                       downloadButton("download_smp_plot_ID",label="Download plot"),
                                       bsModal("modal_smp","Download plot","download_smp_plot_ID",
                                               radioButtons("type_smp_plot","Format",c("pdf","png","tiff"),selected="pdf"),
                                               downloadButton("download_smp_plot","OK")),
                                       # downloadButton("download_smp_table",label="Download table"),
                                       p()
                                       # DTOutput("contents")
                              ),
                              
                              #Plot profile 96 changes                  
                              # tabPanel("Pick Colors",value="color_picker",
                              #          br(),
                              #          # downloadButton("download_prof96_plot_ID",label="Download plot"),
                              #          # bsModal("modal_prof96","Download plot","download_prof96_plot_ID",
                              #          #         radioButtons("type_prof96_plot","Format",c("pdf","png","tiff"),selected="pdf"),
                              #          #         downloadButton("download_prof96_plot","OK")),
                              #          # downloadButton("download_prof96_table",label="Download table"),
                              #          selectInput("anno_col_name","Annotation Column",
                              #                      choices=NULL,selected = NULL, multiple = FALSE),
                              #          # br(),
                              #          tableOutput("column_head"),
                                       br(),
                                       p()#,
                                       # plotOutput("prof96")
                                       
                              )
                  )
        )
      )
    )
  )
# )