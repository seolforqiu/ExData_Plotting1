library(plyr)
library(dplyr)

setwd("/Users/yangqiu/Google Drive/Course/Data Science/ExpDataAnal/project1")

##url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
##download.file(url, destfile = "household_power_consumption.zip", method = "curl")

housepowercon <- read.table("./household_power_consumption.txt", header = TRUE, colClasses = c(rep("character",2), rep("numeric",7)), sep = ";", na.strings = "?")

dates <- housepowercon$Date
times <- housepowercon$Time

x <- paste(dates, times)
datetime <- strptime(x, "%d/%m/%Y %H:%M:%S")

housepowercon <- mutate(housepowercon, DateTime = datetime)
startdate <- strptime("2007-02-01","%Y-%m-%d")
enddate <- strptime("2007-02-03", "%Y-%m-%d")

housepowerconsel <- housepowercon[housepowercon$DateTime>=startdate & housepowercon$DateTime<enddate, ]
housepowerconsel <- housepowerconsel[complete.cases(housepowerconsel$Date),]
housepowerconsel <- select(housepowerconsel, Global_active_power:DateTime)

hist(housepowerconsel$Global_active_power,
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)",
     col = "red")