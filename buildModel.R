source("common.R")

buildModel <- function(dataFile) {
    require(caret)
    
    rawCPS <- read.csv(dataFile)
    # Remove records w/o good hours-worked numbers ("hours vary")
    rawCPS <- rawCPS[rawCPS$PEHRUSL1 != -4 & rawCPS$PEHRUSL2 != -4 & rawCPS$PRERNWA > 0, ]
    cleanCPS <- data.frame(
        weeklyEarnings = rawCPS$PRERNWA / 100.0, # 2 implied decimals in raw data
        sex = sexFactor[rawCPS$PESEX],
        age = as.numeric(rawCPS$PRTAGE),
        edu = eduFactor[unlist(eduRecodeList[as.character(rawCPS$PEEDUCA)])],
        occ = occFactor[rawCPS$PRDTOCC1],
        metro = metroFactor[rawCPS$GTMETSTA],
        weeklyHours = as.numeric(rawCPS$PEHRUSL1) + as.numeric(rawCPS$PEHRUSL2)
    )
    saveRDS(cleanCPS, "data/cps2014clean.rds")
    
    set.seed(33)
    inTraining <- createDataPartition(cleanCPS$weeklyEarnings, p = .75, 
                                      list = FALSE)
    training <- cleanCPS[ inTraining, ]
    testing  <- cleanCPS[-inTraining, ]
    fitControl <- trainControl(
        method = "repeatedcv",
        number = 4,
        repeats = 2
    )
    
    fit <- train(weeklyEarnings ~ ., 
                 data = training,
                 method = "bayesglm",
                 trControl = fitControl
    )

    testResults <- predict(fit, testing)
    
    print(fit)
    cat(paste("Performance on test set:",
              RMSE(testResults, testing$weeklyEarnings)))
    fit
}

model <- buildModel("data/cps2014.csv")
save(model, file="data/model.dat")