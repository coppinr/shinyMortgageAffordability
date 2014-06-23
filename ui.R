price <<- 300
shinyUI(pageWithSidebar(
  
  headerPanel("Mortgage affordability calculator"),

  sidebarPanel(
    #p("This ShinyApp will help you figure out if you can afford that condo, loft, townhouse or house you're after; but ultimately, the decision is up to what you already have saved, what the seller is willing to go with, and what terms a lender will offer you. Individual results will vary."),
    p("This ShinyApp will help you figure out if you can afford that condo, loft, townhouse or house you're after."),
    
    #Mortgage and property information
    h4("The property"),
    
    numericInput("total_cost", "Price (in thousands)", price, min=0),
    #uiOutput("total_cost_widget"),
    helpText("Accepted offer price, in thousands (so $300,000 is just '300')."),
    numericInput("property_tax", 'Annual property tax (dollars)', 1500, min=0),
    #uiOutput("down_payment_widget"),
    #sliderInput('down_payment', 'Downpayment (in thousands)',value = 15, min = 0, max = price, step = 5,),
    numericInput("strata_fee", 'Monthly strata/maintenance fees (dollars)', 250, min=0),
    
    #Mortgage information
    h4("The mortgage"),
    numericInput("interest_rate", "Interest rate (%)", 3.04, min=0.01),
    helpText("Start at the current prime rate if you don't know what your bank will offer you. We are going to assume semi-anual compounding"),

    sliderInput('mortgage_term', 'Term (years)',value = 25, min = 5, max = 35, step = 5),
    
    
    #Your information
    h4("Your finances"),
    numericInput("down_payment", 'Downpayment (in thousands)', price/20, min=0),
    helpText("Cash you have saved, in thousands, minus a few thousand for closing costs"),
    
    numericInput("monthly_income", 'Your monthly income (dollars)', 3200, min=0),
    numericInput("monthly_expenses", 'Your monthly expenses (dollars)', 1900, min=0),
    helpText("Don't include rent, but include food, transportation, power, and any other existing living expenses.")
    
  ),
  mainPanel(
    textOutput("text1"),
    textOutput("text2"),
    htmlOutput("text3"),
    plotOutput("chart1")
    
  )
))