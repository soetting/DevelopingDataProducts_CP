library(shiny)
library(fOptions)
library(ggplot2)
library(scales)
shinyServer(
function(input, output) {
        
    output$option.price = renderText(dollar(
            BSAmericanApproxOption(TypeFlag = input$option.type, 
                        S = input$stock.price, X = input$exercise.price, 
                        Time = as.numeric(input$exercise.date - Sys.Date())/365, 
                        r = input$interest.rate, b = input$carry.interest.rate, 
                        sigma = input$sigma)@price)
        )
    
    output$payout.plot = renderPlot({  
    
    # Payout plot for a call option   
    if(input$option.type == "c") {
        option.price.c =  BSAmericanApproxOption("c", S = input$stock.price, 
                X = input$exercise.price,
                Time = as.numeric(input$exercise.date - Sys.Date())/365, 
                r = input$interest.rate, b = input$carry.interest.rate, 
                sigma = input$sigma)@price
        ep = input$exercise.price
        xvalue = seq( max(ep * .75,1), max(ep * 1.25,2), length.out = 100)
        yvalue = ifelse(xvalue > ep, xvalue - ep, 0) - option.price.c
        yvalue.abs = ifelse(yvalue > 0 , "pos", "neg")
        df = data.frame( xvalue, yvalue, yvalue.abs )
        ggplot( df, aes( x = xvalue, y = yvalue)) + geom_line(lwd = 2) +
                geom_area( aes(fill = yvalue.abs), alpha = .5 ) +
                scale_fill_manual(values = c("red", "dark green")) +
                geom_hline(yintercept = 0) +
                guides(fill = FALSE) +
                ylab("Profit/Loss") + xlab("Stock Price at Expiration") +
                theme(axis.title.x=element_text( face = "bold.italic", 
                                                 color = "darkblue",
                                                 size = 18)) +
                theme(axis.title.y=element_text( face = "bold.italic",
                                                 color = "darkblue",
                                                 size = 18)) +
                scale_x_continuous(labels = dollar) +
                scale_y_continuous(labels = dollar) + 
                theme(axis.text.x= element_text( face = "bold", size = 12)) +
                theme(axis.text.y= element_text( face = "bold", size = 12))
        }
    
    # Payout plot for a put option
    else {  
        option.price.p =  BSAmericanApproxOption("p", S = input$stock.price, 
                X = input$exercise.price,
                Time = as.numeric(input$exercise.date - Sys.Date())/365, 
                r = input$interest.rate, b = input$carry.interest.rate, 
                sigma = input$sigma)@price
        ep = input$exercise.price
        xvalue = seq( max(ep * .75,1), max(ep * 1.25,2), length.out = 100)
        yvalue = ifelse(xvalue > ep, 0, ep - xvalue) - option.price.p
        yvalue.abs = ifelse(yvalue > 0 , "pos", "neg")
        df = data.frame( xvalue, yvalue, yvalue.abs )
        ggplot( df, aes( x = xvalue, y = yvalue)) + geom_line(lwd = 2) +
                geom_area( aes(fill = yvalue.abs), alpha = .5 ) +
                scale_fill_manual(values = c("red", "dark green")) +
                geom_hline(yintercept = 0) +
                guides(fill = FALSE) +
                ylab("Profit/Loss") + xlab("Stock Price at Expiration") +
                theme(axis.title.x=element_text( face = "bold.italic", 
                                                 color = "darkblue",
                                                 size = 18)) +
                theme(axis.title.y=element_text( face = "bold.italic",
                                                 color = "darkblue",
                                                 size = 18)) +
                scale_x_continuous(labels = dollar) +
                scale_y_continuous(labels = dollar) + 
                theme(axis.text.x= element_text( face = "bold", size = 12)) +
                theme(axis.text.y= element_text( face = "bold", size = 12))
        }
    })

    
    output$variable.plot = renderPlot({
        
        # Calculate Values for the maximum y-axis amount
        
        ep.multiplier = ifelse(input$option.type == "c", .8, 1.12)
        up.y.lim = BSAmericanApproxOption( TypeFlag = input$option.type,
                                            S = input$stock.price, 
                                            X = ep.multiplier * input$exercise.price,
                                            Time = as.numeric(input$exercise.date - Sys.Date())/365, 
                                            r = .10, b = .10, 
                                            sigma = 2.0)@price
        
        
        if ( input$variable.type == "ep" ) { 
            e = input$exercise.price
            xvalue = seq( e * .75, e * 1.25, length.out = 100)
            for ( i in 1:100 ) {
                yvalue[i] = BSAmericanApproxOption( TypeFlag = input$option.type,
                                S = input$stock.price, 
                                X = xvalue[i],
                                Time = as.numeric(input$exercise.date - Sys.Date())/365, 
                                r = input$interest.rate, b = input$carry.interest.rate, 
                                sigma = input$sigma)@price
                }
            df = data.frame( xvalue, yvalue )
            ggplot( df, aes( x = xvalue, y = yvalue)) + geom_line(lwd = 2) +
                ylab("Option Value") + xlab("Exercise Price") +
                theme(axis.title.x=element_text( face = "bold.italic", 
                                                 color = "darkblue",
                                                 size = 18)) +
                theme(axis.title.y=element_text( face = "bold.italic",
                                                 color = "darkblue",
                                                 size = 18)) +
                scale_x_continuous(labels = dollar) +
                scale_y_continuous(labels = dollar, limits = c( 0, up.y.lim)) + 
                theme(axis.text.x= element_text( face = "bold", size = 12)) +
                theme(axis.text.y= element_text( face = "bold", size = 12))
            }
        else if ( input$variable.type == "v" ) {    
            xvalue = seq( .001, 2, length.out = 100)
            for ( i in 1:100 ) {
                yvalue[i] = BSAmericanApproxOption( TypeFlag = input$option.type ,
                                S = input$stock.price, 
                                X = input$exercise.price,
                                Time = as.numeric(input$exercise.date - Sys.Date())/365, 
                                r = input$interest.rate, b = input$carry.interest.rate, 
                                sigma = xvalue[i])@price
                }
            df = data.frame( xvalue, yvalue )
            ggplot( df, aes( x = xvalue, y = yvalue)) + geom_line(lwd = 2) +
                ylab("Option Value") + xlab("Volatility Value") +
                theme(axis.title.x=element_text( face = "bold.italic", 
                                                 color = "darkblue",
                                                 size = 18)) +
                theme(axis.title.y=element_text( face = "bold.italic",
                                                 color = "darkblue",
                                                 size = 18)) +
                scale_x_continuous(labels = percent) +
                scale_y_continuous(labels = dollar, limits = c( 0, up.y.lim)) + 
                theme(axis.text.x= element_text( face = "bold", size = 12)) +
                theme(axis.text.y= element_text( face = "bold", size = 12))
            }
        else if ( input$variable.type == "ir" )  {    
            xvalue = seq( 0.005, 0.10, length.out = 100)
            for ( i in 1:100 ) {
                yvalue[i] = BSAmericanApproxOption(TypeFlag = input$option.type,
                                S = input$stock.price, 
                                X = input$exercise.price,
                                Time = as.numeric(input$exercise.date - Sys.Date())/365, 
                                r = xvalue[i], b = input$carry.interest.rate, 
                                sigma = input$sigma)@price
            }
            df = data.frame( xvalue, yvalue )
            ggplot( df, aes( x = xvalue, y = yvalue)) + geom_line(lwd = 2) +
                ylab("Option Value") + xlab("Interest Rate") +
                theme(axis.title.x=element_text( face = "bold.italic", 
                                                 color = "darkblue",
                                                 size = 18)) +
                theme(axis.title.y=element_text( face = "bold.italic",
                                                 color = "darkblue",
                                                 size = 18)) +
                scale_x_continuous(labels = percent) +
                scale_y_continuous(labels = dollar, limits = c( 0, up.y.lim)) + 
                theme(axis.text.x= element_text( face = "bold", size = 12)) +
                theme(axis.text.y= element_text( face = "bold", size = 12))
        }        
        else if ( input$variable.type == "cr" ) {    
            xvalue = seq( 0.005, 0.1, length.out = 100)
            for ( i in 1:100 ) {
                yvalue[i] = BSAmericanApproxOption(TypeFlag = input$option.type,
                                S = input$stock.price, 
                                X = input$exercise.price,
                                Time = as.numeric(input$exercise.date - Sys.Date())/365, 
                                r = input$interest.rate, b = xvalue[i], 
                                sigma = input$sigma)@price
            }
            df = data.frame( xvalue, yvalue )
            ggplot( df, aes( x = xvalue, y = yvalue)) + geom_line(lwd = 2) +
                ylab("Option Value") + xlab("Carry Rate") +
                theme(axis.title.x=element_text( face = "bold.italic", 
                                                 color = "darkblue",
                                                 size = 18)) +
                theme(axis.title.y=element_text( face = "bold.italic",
                                                 color = "darkblue",
                                                 size = 18)) +
                scale_x_continuous(labels = percent) +
                scale_y_continuous(labels = dollar, limits = c( 0, up.y.lim)) + 
                theme(axis.text.x= element_text( face = "bold", size = 12)) +
                theme(axis.text.y= element_text( face = "bold", size = 12))
        }        
    })
        
        
        
    }
)