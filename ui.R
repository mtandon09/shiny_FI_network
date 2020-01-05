library(shiny)
library(shinyjs)
library(shinyBS)
library(svgPanZoom)
library(shinycssloaders)
library(shinyalert)

# Define UI for data upload app ----
shinyUI(fluidPage(
  useShinyjs(),
    # App title ----
    titlePanel("Functional Networks of Gene Interactions (FuNGIn)"),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
      
      # Sidebar panel for inputs ----
      sidebarPanel(
        
        # Input: Select a file ----
        textAreaInput("query_gene_list", "Enter genes to make a network from:",
                  placeholder="e.g. BRCA2, MSH2"),
        tags$hr(),
        checkboxInput("include_neighbors", "Include neighboring genes?", TRUE),
        
        # tags$hr(),
        checkboxGroupInput("source_checkboxes","Select Sources",
                           choices=c("Reactome_FI","mirTarBase"),selected = "Reactome_FI"),
        
        tags$br(),
        actionButton("make_plot", "Make Network"),
        
        tags$hr(),
        
        bsCollapse(id = "diff_exp_options", open = NULL,
                   bsCollapsePanel("Add Expression Data", 
                                   style="primary",
                                    # Input: Select a file ----
                                   fileInput("diff_exp_file", "Choose differential expression file",
                                             multiple = FALSE,
                                             accept = c("text/csv",
                                                        "text/comma-separated-values,text/plain",
                                                        ".csv","xlsx",".xls")),
                                   
                                   # Input: Checkbox if file has header ----
                                   checkboxInput("header", "Header", TRUE),
                                   
                                   # Input: Select separator ----
                                   radioButtons("sep", "Separator",
                                                choices = c(Tab = "\t",
                                                            Comma = ","),
                                                selected = "\t"),
                                   
                                   numericInput("pval_thresh","Adj P-value Cutoff", value=0.05, min=0, max=1, step=0.01),
                                   numericInput("top_n","Limit to top N genes", value=250, min=1, max=1000, step=1),
                                   selectInput("gene_column", "Gene Symbol Column", choices=NULL),
                                   selectInput("fc_column", "Fold-Change Column",choices=NULL),
                                   selectInput("pval_column", "P-Value Column",choices=NULL)
                                   ),
                   bsCollapsePanel("Add Mutation Data",
                                   style="primary")),

        # Horizontal line ----
        tags$hr(),
        
        # Input: Select a file ----
        fileInput("maf_file", "Choose MAF file",
                  multiple = FALSE,
                  accept = c("text/csv",
                             "text/comma-separated-values,text/plain",
                             ".csv","xlsx",".xls")),
        
        # Horizontal line ----
        tags$hr()
        
      ),
      
      # Main panel for displaying outputs ----
      mainPanel(id="mainpanel",
                
                # tabsetPanel(id="tab", type="pills",
                            
                            #Somatic Mutation Prevalence
                            tabPanel("Network Plot",value="contents",
                                     br(),
                                     tabsetPanel(id = "plot_types", type="tabs",
                                                 tabPanel("Zoomable Plot", 
                                                       conditionalPanel(
                                                         condition="output.makeStaticPlot==FALSE",
                                                         withSpinner(svgPanZoomOutput("net_plot", width = "90%", height = "800px"), type=4)
                                                       )),
                                                 tabPanel("Static Plot", 
                                                       conditionalPanel(
                                                         condition="output.makeStaticPlot==TRUE",
                                                         plotOutput("static_plot", width = "90%", height = "800px", click = NULL,
                                                                    dblclick = NULL, hover = NULL, hoverDelay = NULL,
                                                                    hoverDelayType = NULL, brush = NULL, clickId = NULL,
                                                                    hoverId = NULL, inline = FALSE)
                                                         
                                                       ))
                                     ),
                                     br(),
                                     downloadButton("download_plot_button",label="Download plot"),
                                     bsModal("modal_smp","Download plot","download_plot_button",
                                             radioButtons("save_type","Format",c("pdf","png","tiff","svg"),selected="pdf"),
                                             numericInput("save_width", "Width (in)",value=8, min=2, max=50, step=0.5),
                                             numericInput("save_height", "Height (in)",value=8, min=2, max=50, step=0.5),
                                             downloadButton("download_plot","Download")),
                                     p()
                            ),
                                     br(),
                                     p()
                            # )
                )
      )
    )
  )
# )