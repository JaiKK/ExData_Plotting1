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


par("mfrow" = c(1,1))

## Below code will create first plot file
png('plot1.png', width=480, height=480)

hist(dataSub$Global_active_power, 
     main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)", 
     #ylab = "Frequency", 
     col = "red")

#dev.copy(png, "plot1.png")
dev.off()