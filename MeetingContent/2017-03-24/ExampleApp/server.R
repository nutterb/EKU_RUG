shinyServer(function(input, output, session){
  
# Passive Observers -------------------------------------------------
  
  observe({
    toggle(id = "data_table",
           condition = input$sidebar_data_display == "table")
    toggle(id = "data_plot",
           condition = input$sidebar_data_display == "plot")
    toggle(id = "sidebar_div_plot_option",
           condition = input$sidebar_data_display == "plot")
  })
  
  observe({
    toggle(id = "sidebar_div_yvar",
           condition = input$sidebar_plot_type != "Histogram")
    toggle(id = "show_regression",
           condition = input$sidebar_plot_type == "Scatterplot")
  })
  

  
# Reactive Values ---------------------------------------------------
  
  # data <- reactive({
  #   get(input$sidebar_data_select)
  # })
  
  data <- eventReactive(
    input$btn_load_datafile,
    {
      sep = switch(input$sidebar_filetype,
                   "csv" = ",",
                   "tab" = "\t")
      read.table(input$sidebar_file_select$datapath,
                 sep = sep,
                 header = TRUE)
    }
  )
  
  plot_base <- reactive({
    ggplot(data = data())
  })
  
  xvar_convert <- reactive({
    req(input$sidebar_xvar_convert)
    switch(input$sidebar_xvar_convert,
      "numeric" = as.numeric,
      "factor" = factor,
      "Date" = as.Date,
      "POSIXct" = as.POSIXct
    )
  })
  
  yvar_convert <- reactive({
    req(input$sidebar_yvar_convert)
    switch(input$sidebar_yvar_convert,
           "numeric" = as.numeric,
           "factor" = factor,
           "Date" = as.Date,
           "POSIXct" = as.POSIXct
    )
  })
  
  plot_layer <- reactive({
    req(input$sidebar_plot_type)

    switch(input$sidebar_plot_type,
           "Histogram" = geom_histogram(mapping = aes_string(x = input$sidebar_xvar)),
           "Scatterplot" = geom_point(mapping = aes_string(x = input$sidebar_xvar,
                                                           y = input$sidebar_yvar)),
           "Boxplot" = geom_boxplot(mapping = aes_string(x = input$sidebar_xvar,
                                                         y = input$sidebar_yvar)),
           list()
    )
  })
  
# Output Slots ------------------------------------------------------
  
  output$data_table <- 
    renderTable({
      data()
    })

  output$data_plot <- 
    renderPlot({
      
      local_data <- data()
      local_data[[input$sidebar_xvar]] <- 
        xvar_convert()(local_data[[input$sidebar_xvar]])
      
      if (!is.null(input$sidebar_yvar)) # don't execute if a yvar isn't chosen
      {
        local_data[[input$sidebar_yvar]] <- 
          yvar_convert()(local_data[[input$sidebar_yvar]])
      }
      
      p <- ggplot(data = local_data) + 
        plot_layer()
      
      if (input$show_regression)
        p <- p + geom_line(mapping = aes_string(x = input$sidebar_xvar,
                                                y = input$sidebar_yvar),
                           stat = "smooth", method = "lm")
      
      p + 
        xlab(input$sidebar_xvar_label) + 
        ylab(input$sidebar_yvar_label)
    })
  
  
  output$data_xvar_name <- 
    renderUI({
      selectInput(inputId = "sidebar_xvar",
                  label = "X-variable",
                  choices = names(data()))
    })
  
  output$data_yvar_name <- 
    renderUI({
      selectInput(inputId = "sidebar_yvar",
                  label = "Y-variable",
                  choices = names(data()))
    })
  
  output$data_xvar_convert <- 
    renderUI({
      req(input$sidebar_xvar)  # Don't render unless this input has a value
      
      current_class <- 
        if (inherits(class(data()[[input$sidebar_xvar]]), "numeric"))
          "numeric"
        else if (inherits(class(data()[[input$sidebar_xvar]]), "factor"))
          "factor"
        else if (inherits(class(data()[[input$sidebar_xvar]]), "Date"))
          "Date"
        else if (inherits(class(data()[[input$sidebar_xvar]]), "POSIXct"))
          "POSIXct"
      
      selectInput(inputId = "sidebar_xvar_convert",
                  label = "Convert X to",
                  choices = c("numeric", 
                              "factor",
                              "POSIXct"),
                  selected = current_class)
    })
  
  output$data_yvar_convert <- 
    renderUI({
      req(input$sidebar_yvar)  # Don't render unless this input has a value
      
      current_class <- 
        if (inherits(class(data()[[input$sidebar_yvar]]), "numeric"))
          "numeric"
      else if (inherits(class(data()[[input$sidebar_yvar]]), "factor"))
        "factor"
      else if (inherits(class(data()[[input$sidebar_yvar]]), "Date"))
        "Date"
      else if (inherits(class(data()[[input$sidebar_yvar]]), "POSIXct"))
        "POSIXct"
      
      selectInput(inputId = "sidebar_yvar_convert",
                  label = "Convert Y to",
                  choices = c("numeric", 
                              "factor",
                              "POSIXct",
                              "Date"),
                  selected = current_class)
    })
  
  output$data_xvar_label <- 
    renderUI({
      textInput(inputId = "sidebar_xvar_label",
                label = "X-axis label",
                value = input$sidebar_xvar)
    })
  
  output$data_yvar_label <- 
    renderUI({
      textInput(inputId = "sidebar_yvar_label",
                label = "Y-axis label",
                value = input$sidebar_yvar)
    })
  
})