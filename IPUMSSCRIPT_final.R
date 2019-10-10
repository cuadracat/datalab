######create weighted frequency counts from IPUMS data####### 
setwd("/Users/f0049jv/Desktop/R/IPUMS")
library(ipumsr)
ddi <- read_ipums_ddi("usa_00024.xml")
data <- read_ipums_micro(ddi)
library(dplyr)
library(questionr)
###these are unweighted frequencies of the condo fees
w = table(data$CONDOFEE)
d = as.data.frame(w)
names(d)[1] = 'Condo Fee'
#####experiment 1, weighted condo fees by person
w2 = wtd.table(x = data$CONDOFEE, weights = data$PERWT)
d2 = as.data.frame(w2)
names(d2)[1] = 'Condo Fee'
#### experiment 2, weighted condo fees by household
w3 = wtd.table(x = data$CONDOFEE, weights = data$HHWT)
d3 = as.data.frame(w3)
names(d3)[1] = 'Condo Fee'
#### experiment 3, weighted condo fees by person and ownership
###step one, weighted ownership numbers 
w4 = wtd.table(x = data$OWNERSHP, weights = data$PERWT)
d4 = as.data.frame(w4)
names(d4)[1] = 'Tenure'
d4
#####step two two way frequency table
w5= wtd.table(data$CONDOFEE, data$OWNERSHP, weights=data$PERWT)
d5 = as.data.frame(w5)
names(d5)[1] = 'Condo Fee'
names(d5)[2] = 'Tenure'
sum(d5$Freq) 
write.csv(d5, file = "condofeesbyperson.csv")
#the sum at the end ensures that the number of observations remains the same across 
#data manipulation
#### experiment 4, weighted condo fees by household and ownership
w6= wtd.table(data$CONDOFEE, data$OWNERSHP, weights=data$HHWT)
d6 = as.data.frame(w6)
names(d6)[1] = 'Condo Fee'
names(d6)[2] = 'Tenure'
sum(d6$Freq)
###household data
###because household data includes multiple people from the same household, we will subset
###our data for the variable PERNUM 1  which is the first person in each household
household <- subset(data, PERNUM  == 1, select=c(HHWT, CONDOFEE, OWNERSHP))
w7 = wtd.table(household$CONDOFEE, household$OWNERSHP, weights=household$HHWT)
d7 = as.data.frame(w7)
names(d7)[1] = 'Condo Fee'
names(d7)[2] = 'Tenure'
sum(d7$Freq)
write.csv(d7, file = "condofeesbyhousehold.csv")
