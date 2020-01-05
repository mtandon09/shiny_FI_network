library(shiny)
library(openxlsx)
library(igraph)
library(qgraph)
library(ggnetwork)
library(network)
library(intergraph)
library(RColorBrewer)
library(ggnewscale)
library(svgPanZoom)
library(gridSVG)
library(shinycssloaders)
library(shinyWidgets)

library(BiocManager)
library(maftools)

# options(repos = BiocManager::repositories())
options(shiny.maxRequestSize=30*1024^2) 

source("helper_functions.network.R")

interaction_data_file="data/gene_interactions.with_mirna.Rdata"



shinyServer(function(input, output, session) {
  
  plot_values <- reactiveValues()
  plot_values$diff_exp_mat <- NULL
  plot_values$curr_plot <- NA
  
  observeEvent(input$diff_exp_file, {
    req(input$diff_exp_file)
    myfile_path <- input$diff_exp_file$datapath
    file_extension <- tools::file_ext(myfile_path)
    
    print(class(myfile_path))
    print(myfile_path)
    if (grepl("xls",file_extension)) {
      diff_exp_mat <- read.xlsx(myfile_path)
    } else {
      diff_exp_mat <- read.table(myfile_path, sep=input$sep, header=input$header, stringsAsFactors = F)
    }
    
    
    plot_values$diff_exp_mat <- diff_exp_mat
    
    col_names <- colnames(diff_exp_mat)
    gene_col_guess <- grep("symbol", col_names, ignore.case=T,value=T)[1]
    fc_col_guess <- grep("logfc", col_names, ignore.case=T,value=T)[1]
    pval_col_guess <- grep("adj", col_names, ignore.case=T,value=T)[1]
    updateSelectInput(session, inputId = "gene_column", choices = col_names, selected = gene_col_guess)
    updateSelectInput(session, inputId = "fc_column", choices = col_names, selected = fc_col_guess)
    updateSelectInput(session, inputId = "pval_column", choices = col_names, selected = pval_col_guess)
    updateTextAreaInput(session, "query_gene_list", value="")
  })
  
  observeEvent(input$make_plot, {
    curr_query_genes <- unlist(strsplit(input$query_gene_list,"\\n|,| "))
    if (length(curr_query_genes) < 1) {
      curr_query_genes <- NULL
    }
    
    if ((!is.null(plot_values$diff_exp_mat)) && (input$include_neighbors) && (is.null(input$useJustMyGenes)) ) {
      print("do a popup")
      
      confirmSweetAlert(
        session = session,
        inputId = "useJustMyGenes",
        type = "info",
        title = "Are you sure?",
        text=paste0("Do you want to just view interactions among the ",input$top_n, " differentially expressed genes (recommended) or include neighboring genes also?"),
        btn_labels = c("Include Neighbors","Just my genes"),
        # btn_colors = c("#04B404","#FE642E"),
        closeOnClickOutside=T
      )
    }
    if ((! is.null(input$useJustMyGenes)) || (length(curr_query_genes) > 0)) {
      plot_values$query_genes <- curr_query_genes
      plot_values$gene_column <- ifelse(input$gene_column=="","gene",input$gene_column)
      plot_values$fc_column <- ifelse(input$fc_column=="","logFC",input$fc_column)
      plot_values$pval_column <- ifelse(input$pval_column=="","adj.P.Val",input$pval_column)
      
      withProgress({
        plot_results <- plot_interaction_network(query_genes=plot_values$query_genes, 
                                              get_neighbors=input$include_neighbors,
                                              sources = input$source_checkboxes,
                                              diff_exp_results = plot_values$diff_exp_mat,
                                              pval_cutoff=input$pval_thresh, n_genes_cutoff=input$top_n,
                                              gene_column=plot_values$gene_column,fc_column=plot_values$fc_column,pval_column=plot_values$pval_column,
                                              # savename = plot_filename,
                                              gene_interaction_saved_data = interaction_data_file)
        
        curr_plot <- plot_results[[1]]
        plot_values$n_plotted_genes <- plot_results[[2]]
        setProgress(value=0.9, message="Plotting...")
        if (is.na(curr_plot[1])) {
          showModal(modalDialog(
            title = "No interactions found",
            "Enter more genes or different options to find interactions.",
            easyClose = TRUE,
            footer = NULL
          ))
          plot_values$curr_plot <- NULL
        } else {
          plot_values$curr_plot <- curr_plot
        }
        
        updateTabsetPanel(session, "plot_types", 
                       selected = ifelse(plot_values$n_plotted_genes <= 250, "Zoomable Plot","Static Plot")
        )
      }, message="Generating network...")
    }
  })

  observeEvent(input$useJustMyGenes, {
    print(input$useJustMyGenes)
    updateCheckboxInput(session, "include_neighbors", value = !input$useJustMyGenes)
    click("make_plot")
  })
  
  output$static_plot <- renderPlot({
    req(plot_values$n_plotted_genes)
    validate(need(!is.na(plot_values$curr_plot), message=FALSE))
    validate(need(plot_values$n_plotted_genes > 250,"Making zoomable plot"))
    plot_values$curr_plot
  })

  ## Output with svgPanZoom
  output$net_plot <- renderSvgPanZoom({
    req(plot_values$n_plotted_genes)
    validate(need(!is.na(plot_values$curr_plot), message=FALSE))
    validate(need(plot_values$n_plotted_genes <= 250,"Making static plot.\n(Just download it in like PDF or SVG and go zoom yourself)"))
  
    plot_filename="currplot.svg"
    ggsave(plot_values$curr_plot, filename = plot_filename,
           height=8,width=8,units="in", bg="white", pointsize=1)
    svgPanZoom(plot_filename,controlIconsEnabled = T)
  })
    
  output$download_plot <- downloadHandler (
    filename = function(){
      paste("network_plot",input$save_type, sep=".")
    },
    content = function(ff) {
      req(plot_values$curr_plot)
      ggsave(plot_values$curr_plot, filename = ff,height=input$save_height,width=input$save_width,units="in")
      
    }
  )
})
