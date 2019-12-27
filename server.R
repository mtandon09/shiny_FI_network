library(shiny)
library(openxlsx)
library(igraph)
library(qgraph)
library(ggnetwork)
library(network)
library(intergraph)
library(RColorBrewer)
library(ggnewscale)
library(maftools)
source("helper_functions.network.R")

interaction_data_file="data/gene_interactions.with_mirna.Rdata"

shinyServer(function(input, output, session) {
  
  # curr_plot <- dev.cur()
  plot_values <- reactiveValues()

    observeEvent(input$make_plot, {
    curr_query_genes <- unlist(strsplit(input$query_gene_list,"\\n|,"))
    plot_values$query_genes <- curr_query_genes
    # print(curr_query_genes)
    
    plot_filename="currplot.png"
    withProgress({
      curr_plot <- plot_interaction_network(query_genes=curr_query_genes, 
                                            get_neighbors=input$include_neighbors,
                                            sources = input$source_checkboxes,
                                            # savename = plot_filename,
                                            gene_interaction_saved_data = interaction_data_file)
      
      setProgress(value=0.9, message="Plotting...")
      if (is.na(curr_plot[1])) {
        showModal(modalDialog(
          title = "No interactions found",
          "Enter more genes or options to find interactions.",
          easyClose = TRUE,
          footer = NULL
        ))
      } else {
        plot_values$curr_plot <- curr_plot
      }
    }, message="Generating network...")
  })
  
  output$net_plot <- renderPlot({
    req(plot_values$curr_plot)
    plot_values$curr_plot
  })
    
  output$download_plot <- downloadHandler (
    filename = function(){
      paste("network_plot",input$save_type, sep=".")
    },
    content = function(ff) {
      req(plot_values$curr_plot)
      ggsave(plot_values$curr_plot, filename = ff,height=8,width=8,units="in")
      
    }
  )
  
  
  # output$net_plot <- renderPlot({
  #   # curr_plot
  #   req(plot_values$curr_plot)
  #   plot_values$curr_plot
  # })
  
  
  
}
)