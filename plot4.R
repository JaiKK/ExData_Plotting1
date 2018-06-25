library("lubridate")
library("dplyr")

fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
dataFile <- "dataFile.zip"

if(!file.exists(dataFile)){
  download.file(url = fileurl, destfile = dataFile)
}

data <- read.table(unz("dataFile.zip","household_power_consumption.txt"), 
                   header = TRUE, 
                   sep = ";",
                   #nrows = 25,
                   na.strings = "?",
                   colClasses = c("Date" = "character", 
                                  "Time" = "character",
                                  "Global_active_power" = "numeric",
                                  "Global_reactive_power" = "numeric",
                                  "Voltage" = "numeric",
                                  "Global_intensity" = "numeric",
                                  "Sub_metering_1" = "numeric",
                                  "Sub_metering_2" = "numeric",
                                  "Sub_metering_3" = "numeric")
                   )

dataSub <- subset(data, data$Date %in% c("1/2/2007", "2/2/2007"))
dataSub <- mutate(dataSub, ts = as.POSIXct( dmy(Date) + hms(Time)) )


## Below code will create forth plot file
png('plot4.png', width=480, height=480)

par("mfrow" = c(2,2))

## plot of top left (1,1)
plot(dataSub$ts, dataSub$Global_active_power, ylab = "Global Active Power", xlab = '', type = 'l')

## plot of top right (1,2)
plot(dataSub$ts, dataSub$Voltage, ylab = "Voltage", xlab = 'datetime', type = 'l')

## plot of bottom left (2,1)
plot(dataSub$ts, dataSub$Sub_metering_1, type = 'l', xlab = '', ylab = "Energy Sub metering")
lines(dataSub$ts, dataSub$Sub_metering_2, col = "red")
lines(dataSub$ts, dataSub$Sub_metering_3, col = "blue")
legend("topright", legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lty = "solid", col = c("black","red","blue"), bty = "n")

## plot of bottom right (2,2)
plot(dataSub$ts, dataSub$Global_reactive_power, ylab = "Global_reactive_power", xlab = 'datetime', type = 'l')

#dev.copy(png, "plot4.png")
dev.off()