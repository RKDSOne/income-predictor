library(shiny)
library(data.table)
library(ggplot2)
source("common.R")

MINWAGE = 7.25
if (!file.exists("data/model.rds") || !file.exists("data/cps2014clean.rds")) {
    source("buildModel.R")
}
readRDS("data/model.rds")
cpsData <- data.table(readRDS("data/cps2014clean.rds"),
                      key=c("occ", "edu", "sex", "metro"))

shinyServer(function(input, output){
    s <- reactive({sexFactor[as.numeric(input$sex)]})
    a <- reactive({as.numeric(input$age)})
    e <- reactive({eduFactor[as.numeric(input$edu)]})
    o <- reactive({occFactor[as.numeric(input$occ)]})
    m <- reactive({metroFactor[as.numeric(input$metro)]})
    h <- reactive({as.numeric(input$hours)})
    
    prediction <- reactive({
        inputs <- data.frame(
            sex = s(),
            age = a(),
            edu = e(),
            occ = o(),
            metro = m(),
            weeklyHours = h()
        )        
        return(max(h()*MINWAGE, round(predict(model, inputs), 0)))
    })
    
    output$predictedIncome <- renderText({
        validate(
            need(a() >= 16 && a() <= 90, "Invalid age value"),
            need(h() >= 5 && h() <= 112, "Invalid hour value")
        )
        prediction()
    })
    
    output$predictedIncomeAnnual <- renderText({
        validate(
            need(a() >= 16 && a() <= 90, "Invalid age value"),
            need(h() >= 5 && h() <= 112, "Invalid hour value")
        )
        prediction() * 52
    })
    
    # display optional plot
    output$incomeHist <- renderPlot({
        peopleLikeYou <- cpsData[
            cpsData$sex == s() &
                abs(cpsData$age - a()) <= 2 &    
                cpsData$edu == e() &
                cpsData$occ == o() &
                cpsData$metro == m() &
                abs(cpsData$weeklyHours - h()) <= 5,
            weeklyEarnings]
        validate(
            need(length(peopleLikeYou) >= 5, "[Insufficient data]")
        )
        ggplot(data.frame(income=peopleLikeYou)) + theme_bw() + 
            geom_histogram(aes(x = income), fill = "darkgray", breaks = seq(0,4000, by=500)) + 
            geom_vline(xintercept = prediction(), color="darkblue")
    })
})