library(shiny)
source("common.R")

shinyUI(pageWithSidebar(
    headerPanel("Income Predictor"),
    sidebarPanel(
        p(
            paste(
                "Enter some basic information and I will predict your income.",
                "The model assumes you live in the U.S. and are currently employed."
            )
        ),
        radioButtons("sex", "Sex:", listFromFactor(sexFactor)),
        numericInput("age", "Age:", value = 30, min=16, max=85),
        selectInput("edu", "Education:", listFromFactor(eduFactor), selected = 6),
        selectInput("occ", "Occupation category:", listFromFactor(occFactor), selected = 3),
        numericInput("hours", "Usual hours worked per week:", value=40, min=0, max=80),
        selectInput("metro", "Type of area where you live:", listFromFactor(metroFactor)),
        hr(),
        h4("About the model and data"),
        p("This model is based on the",
          a(href = "http://thedataweb.rm.census.gov/ftp/cps_ftp.html",
            "2014 Current Population Survey public-use microdata.")
        ),
        p("The income prediction is from a Bayesian GLM trained with 4-fold 2x",
          "repeated cross-validation, and the histogram is created from",
          "unweighted record counts from the Current Population Survey.",
          "The histogram includes records where the respondent's age is within",
          "5 years of the input and weekly hours worked are within 10 of the input.")
    ),
    mainPanel(
        h3("Results"),
        p(
            "I'm guessing you make $",
            strong(textOutput("predictedIncome", inline=TRUE)),
            " per week.",
            "($", textOutput("predictedIncomeAnnual", inline=TRUE), 
            "annually)"
        ),
        h3("Income distribution of similar people"),
        p("The blue line is the predicted income."),
        plotOutput("incomeHist")
    )
))