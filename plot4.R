filename <- "exdata_data_household_power_consumption.zip"

# Check and download the file if the file has not been downloaded.
if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileURL, filename, method="curl")
}

# Check and create a folder if it does not exist
if (!file.exists("household_power_consumption")) { 
    unzip(filename) 
}
### Create data frames
all_data <- read.table("household_power_consumption.txt", sep = ";", stringsAsFactors=FALSE)
names(all_data) <- lapply(all_data[1, ], as.character)
all_data <- all_data[-1,] 

### Subset data to only 2007-02-01 and 2007-02-02
library(dplyr)
target <- c("1/2/2007", "2/2/2007")
data <- filter(all_data, Date %in% target)

### Plot4
library(lubridate)
library(dplyr)

data$Date <- as.Date(as.character(data$Date), "%d/%m/%Y")
data <- unite(data, "Date_Time", Date, Time, sep = " ", remove=TRUE, na.rm = FALSE)
data$Date_Time <- as.POSIXlt(data$Date_Time, tz = "")

data$Voltage <- as.numeric(data$Voltage)
data$Global_active_power <- as.numeric(data$Global_active_power)
data$Global_reactive_power <- as.numeric(data$Global_reactive_power)

png("plot4.png", width=480, height=480)
par(mfrow = c(2,2), mar = c(4,4,2,1), oma = c(0,0,2,0))
with(data, {
    plot(data$Date_Time, data$Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")
    plot(data$Date_Time, data$Voltage, type="l", xlab="datetime", ylab="Voltage", col = "black")
    plot(data$Date_Time, data$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering", col = "black")
    lines(data$Date_Time, data$Sub_metering_2, col = "red")
    lines(data$Date_Time, data$Sub_metering_3, col = "blue")
    legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col =c("black", "red", "blue"), lty=1)
    plot(data$Date_Time, data$Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power", col = "black")
})
dev.off()
