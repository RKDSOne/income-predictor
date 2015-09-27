library(shiny)
source("common.R")

shinyUI(pageWithSidebar(
    headerPanel("Income Predictor"),
    sidebarPanel(
        h4("How to use this app"),
        p(
            "This tool is easy to use. Just enter some basic information",
            "about a person and it will try to predict that person's income.",
            "In addition, if enough data are available, it will show you the",
            "distribution of incomes for people with those characteristics.",
            "The model based on 2014 data and is only valid for employed persons",
            "living in the U.S."
        ),
        radioButtons("sex", "Sex:", listFromFactor(sexFactor)),
        numericInput("age", "Age (16-90):", value = 30, min=16, max=85),
        selectInput("edu", "Education:", listFromFactor(eduFactor), selected = 6),
        selectInput("occ", "Occupation category:", listFromFactor(occFactor), selected = 3),
        numericInput("hours", "Usual hours worked per week (5-100):", value=40, min=0, max=80),
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
          "5 years of the input and weekly hours worked are within 5 of the input."),
        p("As you can see from the histograms, actual incomes tend to spread",
          "in a wide range around the predictions, which indicates that we",
          "may be able to find better predictors. The model RMSE is about $475",
          "for the weekly income prediction.")
    ),
    mainPanel(
        h3("Results"),
        p(
            "People like this earn about $",
            strong(textOutput("predictedIncome", inline=TRUE)),
            " per week.",
            "($", textOutput("predictedIncomeAnnual", inline=TRUE), 
            "annually)"
        ),
        h3("Income distribution of similar people"),
        p("Note: The blue line is the predicted income."),
        plotOutput("incomeHist")
    )
))