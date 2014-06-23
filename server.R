library(UsingR)
#source("http://faculty.ucr.edu/~tgirke/Documents/R_BioCond/My_R_Scripts/mortgage.R")
shinyServer(
  function(input, output) {
    
    loan_amount <- reactive(input$total_cost-input$down_payment)
    down_percent <- reactive(input$down_payment/input$total_cost)
    output$text1 <- renderText({paste("Your down payment of $", prettyNum(input$down_payment*1000, big.mark=",")," represents ", round(down_percent()*100,2), "% of the purchase price, and leaves you needing a total loan of $", prettyNum(loan_amount()*1000, scientific=FALSE, big.mark=","), ".\n", sep="")})
#    P <- reactive(loan_amount)()
#    i <- reactive(input$interest_rate)()
#    n <- reactive(input$mortgage_term)()
    #interest_rate <- reactive((1+(input$interest_rate)/2)^2-1)
    ### Formula for semi-annual interest compounding from http://www.drcalculator.com/mortgage/instructions.html
    #Monthly Pmt = (P*(((1+i/200)^(1/6)-1))/(1-(((1+i/200)^(1/6)))^-(n*12)))
    #monthly_payment <- reactive((input$total_cost-input$down_payment)*(((1+input$interest_rate/200)^(1/6)-1))/(1-(((1+input$interest_rate/200)^(1/6)))^-(input$mortgage_term*12)))
    monthly_payment <- reactive((input$total_cost-input$down_payment)*1000*(((1+input$interest_rate/200)^(1/6)-1))/(1-(((1+input$interest_rate/200)^(1/6)))^-(input$mortgage_term*12)))
    monthly_housing <- reactive(monthly_payment() + input$property_tax/12 + input$strata_fee)
    output$text2 <- renderText({paste("You can afford a monthly payment of up to $", prettyNum(input$monthly_income-input$monthly_expenses, scientific=FALSE, big.mark=","), " and under the current terms (",input$mortgage_term," years and interest rate of",input$interest_rate,"%), your monthly housing cost (mortgage payment of $", prettyNum(round(monthly_payment()), big.mark=","), " plus property tax and strata fees) is roughly $", prettyNum(round(monthly_housing()), big.mark=","), ".", sep="")})
    output$text3 <- renderUI({em(
      if (down_percent() < 0.2){
        paste("Note: As your down payment is less than 20% of the purchase price, you will have to pay an additional CMHC premium if this purchase is in Canada.")
        })
    })
    output$chart1 <- renderPlot({
      colour <- c("grey", "grey", "grey", "black")
      if (input$monthly_income < input$monthly_expenses + monthly_housing()) {
        colour <- c("grey", "grey", "grey", "red")
      }
      data <- c(input$monthly_income, input$monthly_expenses, monthly_housing(), input$monthly_income-input$monthly_expenses-monthly_housing() )  
      bp <-  barplot(data, main="Monthly Affordability", ylab="Dollars", col = colour, names.arg=c("Income", "Expenses", "Housing cost", "Excess/Deficit"))
      text(bp, 0, round(data, 0),cex=1,pos=3)
    })  
  }
)
