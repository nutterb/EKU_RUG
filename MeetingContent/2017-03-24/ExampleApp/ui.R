shinyUI(
  fluidPage(
    useShinyjs(),
    sidebarLayout(
      sidebarPanel(
        # Select a dataset
        # selectInput(inputId = "sidebar_data_select",
        #             label = "Select a dataset",
        #             choices = c("mtcars", "iris", "presidential")),
        
        fileInput(inputId = "sidebar_file_select",
                  label = "Select a data file"),
        selectInput(inputId = "sidebar_filetype",
                    label = "Delimiter",
                    choices = c("csv", "tab")),
        actionButton(inputId = "btn_load_datafile",
                     label = "Load Data"),
        
        # Select how to display the data (table or plot)
        selectInput(inputId = "sidebar_data_display",
                    label = "Display data as:",
                    choices = c("table", "plot")),
        
        div(
          id = "sidebar_div_plot_option",
          radioButtons(inputId = "sidebar_plot_type",
                       label = "Plot type:",
                       choices = c("Histogram",
                                   "Scatterplot",
                                   "Boxplot")),
          
          checkboxInput(inputId = "show_regression",
                        label = "Show regression"),
          
          div(
            id = "sidebar_div_xvar",
            uiOutput("data_xvar_name"),
            uiOutput("data_xvar_convert"),
            uiOutput("data_xvar_label")
          ),
          
          div(
            id = "sidebar_div_yvar",
            uiOutput("data_yvar_name"),
            uiOutput("data_yvar_convert"),
            uiOutput("data_yvar_label")
          )
        )
      ),
      
      
      
      mainPanel(
        tableOutput("data_table"),
        plotOutput("data_plot")
      )
    )
  )
)