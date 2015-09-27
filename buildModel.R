source("common.R")

buildModel <- function(dataFile) {
    require(caret)
    require(arm)
    
    cat("Loading and cleaning data...")
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
    
    cat("Fitting model...")
    fit <- train(form = weeklyEarnings ~ ., 
                 data = training,
                 trControl = fitControl,
                 method = "bayesglm"
    )

    testResults <- predict(fit, testing)
    
    print(fit)
    cat(paste("Performance on test set (RMSE):",
              RMSE(testResults, testing$weeklyEarnings), "\n"))
    fit
}

# Reduce model size by clearing out training data etc.
# Borrowed from http://www.r-bloggers.com/trimming-the-fat-from-glm-models-in-r/
stripGlmLR = function(cm) {
    cm$y = c()
    cm$model = c()
    
    cm$residuals = c()
    cm$fitted.values = c()
    cm$effects = c()
    cm$qr$qr = c()  
    cm$linear.predictors = c()
    cm$weights = c()
    cm$prior.weights = c()
    cm$data = c()
    
    cm$family$variance = c()
    cm$family$dev.resids = c()
    cm$family$aic = c()
    cm$family$validmu = c()
    cm$family$simulate = c()
    attr(cm$terms,".Environment") = c()
    attr(cm$formula,".Environment") = c()
    
    cm
}

model <- buildModel("data/cps2014.csv")
model$finalModel <- stripGlmLR(model$finalModel)
cat("Saving model...\n")
saveRDS(model, file="data/model.rds")