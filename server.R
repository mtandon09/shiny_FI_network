library(shiny)
library(openxlsx)

shinyServer(function(input, output, session) {
    
  source("helper_functions.network.R")
  
  observeEvent(input$make_plot, {
    print("make plot?")
    curr_query_genes <- unlist(strsplit(input$query_gene_list,"\\n|,"))
    print(curr_query_genes)
    curr_plot <- plot_interaction_network(query_genes=curr_query_genes, get_neighbors=input$include_neighbors)
    output$net_plot <- renderPlot({
      # hist(randomVals())
      req(curr_plot)
      curr_plot
    })
  #   
  })
  
  # output$net_plot <- renderPlot({
  #   hist(runif(50))
  # })
  # 
  curr_plot <- eventReactive(input$make_plot, {
    curr_query_genes <- unlist(strsplit(input$query_gene_list,"\\n|,"))
    print(curr_query_genes)
    
  })
  
  observe({
    output$net_plot <- renderPlot({
      # hist(randomVals())
      req(curr_plot)
      curr_plot
    })
  })
  # print(randomVals)
  # show("mainpanel")
  
  # curr_plot <- plot.new()

  

  }
)