RAW_DATA_FILE = "data/cps2014.csv"
CLEAN_DATA_FILE = "data/cps2014clean.rds"
MODEL_FILE = "data/model.rds"

# Factors to represent data values...

# PESEX
sexFactor <- as.factor(c("male" = 1, "female" = 2))

# PEEDUCA (original)
eduRecodeList <- list(
    "31" = 1, # LESS THAN 1ST GRADE
    "32" = 1, # 1ST, 2ND, 3RD OR 4TH GRADE
    "33" = 1, # 5TH OR 6TH GRADE
    "34" = 1, # 7TH OR 8TH GRADE
    "35" = 1, # 9TH GRADE
    "36" = 1, # 10TH GRADE
    "37" = 1, # 11TH GRADE
    "38" = 1, # 12TH GRADE NO DIPLOMA
    "39" = 2, # HIGH SCHOOL GRAD-DIPLOMA OR EQUIV (GED)
    "40" = 3, # SOME COLLEGE BUT NO DEGREE
    "41" = 4, # ASSOCIATE DEGREE-OCCUPATIONAL/VOCATIONAL
    "42" = 5, # ASSOCIATE DEGREE-ACADEMIC PROGRAM
    "43" = 6, # BACHELOR'S DEGREE (EX: BA, AB, BS)
    "44" = 7, # MASTER'S DEGREE (EX: MA, MS, MEng, MEd, MSW)
    "45" = 8, # PROFESSIONAL SCHOOL DEG (EX: MD, DDS, DVM)
    "46" = 9  # DOCTORATE DEGREE (EX: PhD, EdD)
)

# education recoded
eduFactor <- ordered(as.factor(c(    
    "Less than high school"     = 1,
    "High school / GED"         = 2,
    "Some college"              = 3,
    "2-year degree (vocational)"= 4,
    "2-year degree (academic)"  = 5,
    "4-year degree"             = 6,
    "Master's degree"           = 7,
    "Professional degree (MD, JD, ...)" = 8,
    "Doctoral degree (PhD)"     = 9
)))

# PRDTOCC1 - Occupation group
occFactor <- as.factor(c(
    "Management" = 1,
    "Business and financial operations" = 2,
    "Computer and mathematical science" = 3,
    "Architecture and engineering" = 4,
    "Life, physical, and social science" = 5,
    "Community and social service" = 6,
    "Legal" = 7,
    "Education, training, and library" = 8,
    "Arts, design, entertainment, sports, and media" = 9,
    "Healthcare practitioner and technical" = 10,
    "Healthcare support" = 11,
    "Protective service" = 12,
    "Food preparation and serving related" = 13,
    "Building and grounds cleaning and maintenance" = 14,
    "Personal care and service" = 15,
    "Sales and related" = 16,
    "Office and administrative support" = 17,
    "Farming, fishing, and forestry" = 18,
    "Construction and extraction" = 19,
    "Installation, maintenance, and repair" = 20,
    "Production (manufacturing)" = 21,
    "Transportation and material moving" = 22,
    "Armed Forces" = 23
))

# PRHRUSL - Usual hours worked per week
hoursFactor <- ordered(as.factor(c(
    "0-20 hours" = 1,
    "21-34 hours " = 2,
    "35-39 hours" = 3,
    "40 hours" = 4,
    "41-49 hours" = 5,
    "50 or more hours" = 6,
    "Varies, Full Time" = 7,
    "Varies, Part Time" = 8
)))

# GTMETSTA - metro/nonmetro area of residence
metroFactor <- as.factor(c(
    "Metropolitan area" = 1,
    "Nonmetro/Rural/small-town area" = 2,
    "Not sure" = 3
))

#
# Turns factor into list suitable for selectInput
listFromFactor <- function(fac) {
    as.list(setNames(as.numeric(levels(fac)), names(fac)))
}