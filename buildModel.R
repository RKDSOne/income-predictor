source("common.R")

buildModel <- function(dataFile) {
    require(plyr)
    require(caret)
    
    rawCPS <- read.csv(dataFile)
    # Remove records w/o good "hours worked" numbers
    rawCPS <- rawCPS[rawCPS$PEHRUSL1 != -4 & rawCPS$PEHRUSL2 != -4, ]
    cleanCPS <- data.frame(
        weeklyEarnings = rawCPS$PRERNWA / 100.0,
        sex = sexFactor[rawCPS$PESEX],
        age = as.numeric(rawCPS$PRTAGE),
        edu = eduFactor[unlist(eduRecodeList[as.character(rawCPS$PEEDUCA)])],
        occ = occFactor[rawCPS$PRDTOCC1],
        metro = metroFactor[rawCPS$GTMETSTA],
        #weeklyHours = hoursFactor[rawCPS$PRHRUSL]
        weeklyHours = as.numeric(rawCPS$PEHRUSL1) + as.numeric(rawCPS$PEHRUSL2)
    )
    saveRDS(cleanCPS, "cps2014clean.rds")
    
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
                 #,ntree=200, maxnodes = 10
    )
#     fit <- train(weeklyEarnings ~ ., data = training,
#                  method = "knnreg",
#                  trControl = fitControl
#     )

#     fit <- knnreg(weeklyEarnings ~ ., data = training, k = 12)
    testResults <- predict(fit, testing)
    
    print(fit)
    cat("Performance on test set:\n")
    print(RMSE(testResults, testing$weeklyEarnings))
    fit
}

model <- buildModel("cps2014.csv")
save(model, file="model.dat")