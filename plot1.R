library(plyr)
library(dplyr)

## make sure to set working directory to the folder containing the data

## read data into a data.frame housepowercon
housepowercon <- read.table("./household_power_consumption.txt", header = TRUE, colClasses = c(rep("character",2), rep("numeric",7)), sep = ";", na.strings = "?")

## extract the date and time in
dates <- housepowercon$Date
times <- housepowercon$Time

## combine Date and Time information into a single POSIXlt vector
x <- paste(dates, times)
datetime <- strptime(x, "%d/%m/%Y %H:%M:%S")

## add the POSIXlt vector as a new collumn into the data frame
housepowercon <- plyr::mutate(housepowercon, DateTime = datetime)

## section the data set and let it only contain results in 2007-02-01 and 2007-02-02
startdate <- strptime("2007-02-01","%Y-%m-%d")
enddate <- strptime("2007-02-03", "%Y-%m-%d")
housepowerconsel <- housepowercon[housepowercon$DateTime>=startdate & housepowercon$DateTime<enddate, ]
housepowerconsel <- housepowerconsel[complete.cases(housepowerconsel$Date),]
housepowerconsel <- select(housepowerconsel, Global_active_power:DateTime)

## make the histogram plot
hist(housepowerconsel$Global_active_power,
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)",
     col = "red")

## copy the plot into the png file
dev.copy(png, width = 480, height = 480, file="plot1.png")
dev.off()