#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tibble)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("People Plotter"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            fileInput("file", label = h3("File input"))
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot"),
           hr(),
           tableOutput("value"), 
           verbatimTextOutput("value2")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   dataInput <- reactive({
     if(is.null(input$file$name)){
       result=tribble(~name, ~age, ~height)
     }
     else{
       result=read.csv(input$file$datapath)
     }
     result
   })
      
    output$value <- renderTable({
       dataInput()
    })
    
    output$value2 <- renderPrint({
      str(input$file$name)
    })

    output$distPlot <- renderPlot({
      ggplot(dataInput(), aes(x=age, y=height)) + 
        geom_point()
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
