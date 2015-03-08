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

yrange<-range(housepowerconsel$Sub_metering_1)
plot(housepowerconsel$DateTime,
     housepowerconsel$Sub_metering_3,
     type = "l",
     xlab = "",
     ylab = "Energy sub metering",
     ylim = yrange,
     col = "blue")
lines(housepowerconsel$DateTime,
      housepowerconsel$Sub_metering_2,
      type = "l",
     col = "red")
lines(housepowerconsel$DateTime,
      housepowerconsel$Sub_metering_1,
      type = "l",
      xlab = "",
      col = "black")

legend("topright", # places a legend at the appropriate place 
       c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       lty=c(1,1,1), # gives the legend appropriate symbols (lines)
       lwd=c(2.5,2.5,2.5),
       x.intersp = 0.1,
       y.intersp= 0.3,
       col=c("black","blue","red"),# gives the legend lines the correct color and width
       cex =0.9)
       
## copy the plot into the png file
dev.copy(png, width = 480, height = 480, file="plot3.png")
dev.off()