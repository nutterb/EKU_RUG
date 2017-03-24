# Notes

1. Three files in a directory
    - `ui.R` (User Interface)
    - `server.R` (Server Processing)
    - `global.R` (packages and objects to make available in both)
2. Core libraries
    - `shiny`
    - `shinyjs`
3. Sidebar Layout
4. `useShinyjs()`
5. Dataset selector
6. Display option selector (data or plot)
7. make placeholders for data and plot
8. Make table output slot
9. Make plot output slot
10. Make an observer to turn on and off the table and plot

## Making a customizable plot

1. Make the data reactive (reactives are recipes)
    - Make sure you change the output slots.
2. Make a reactive for the plot base.
3. Make a div (division) for plot options in the sidebar. 
    - add a toggle so it is only visible when the plot is output
4. Add Radio Button for plot type
5. Add a div for the x-variable and conversion
6. Create a reactive for the x-variable conversion function
7. Start a reactive for the plot layer. This will only give histogram
8. Add data conversion and plot layer to output$data_plot
9. Add a div for the y-variable and conversion. 
    - Add the out elements 
    - Add the yvar conversion reactive
10. Add a toggle for the y-variable, it should only show when plot type is not histogram.
11. Modify the plot layer reactive for scatterplot
12. Modify the plot layer reactive for boxplot
13. Add a checkbox to add the regression line. Include a toggle and add the geom_line to the output.
14. Add text inputs for the x and y axis labels

## Create a file import

