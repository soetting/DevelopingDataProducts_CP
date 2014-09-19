library(shiny)

shinyUI(pageWithSidebar(
    headerPanel("Stock Option Pricing Application"),
    sidebarPanel(
        h3("Parameter Input"),
        radioButtons('option.type', "Type of Option", c("Call" = "c", "Put" = "p"), 
                           selected = "c", inline = TRUE),
        numericInput('stock.price', 'Current Stock Price', 10, min = 0, max = 1000 ),
        numericInput('exercise.price', 'Exercise Price', 10, min = 0, max = 1000),
        dateInput('exercise.date', "Expiration Date:", value = Sys.Date() + 30 ),
        sliderInput('interest.rate', 'Current Interest Rate', 0.01, min = 0, max = 0.1, step = .001),
        sliderInput('carry.interest.rate', 'Carry Interest Rate', 0.05, min = 0 , max = 0.1, step = .001),
        sliderInput('sigma', 'Volatility of the Stock', .20, 
                    min = 0, max = 2, step = 0.05),
        h4("Select which variable to observe how the option value changes over its range"),
        radioButtons('variable.type', label = NULL, choices = 
                     c("Exercise Price" = "ep", "Volatility" = "v", 
                        "Interest Rate" = "ir", "Carry Rate" = "cr"),
                     selected = "ep", inline = FALSE)
        
    ),
    mainPanel(
        h4("Value of the Option"),
        verbatimTextOutput('option.price'),
        h4("Profit/Loss Plot"),
        plotOutput("payout.plot"),
        h4("Value of the Option"),
        plotOutput("variable.plot")
        
    )
))