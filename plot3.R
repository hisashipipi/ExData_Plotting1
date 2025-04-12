# Download and decompress input data from the following link and save it to the working directory
# "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# 0. Install required packages and load them 
install.packages("lubridate")
install.packages("dplyr")
# Load libraries
library(lubridate)
library(dplyr)

# 1. Read data ("household_power_consumption.txt" saved in the working directory)
df <- read.table("household_power_consumption.txt", sep = ";", header = TRUE)

# 2. Subset data (2007-02-01 and 2007-02-02)
# Transform Date to Date format first
df$Date <- as.Date(df$Date, "%d/%m/%Y")                    
dfs <- subset(df, Date %in% as.Date(c("01/02/2007", "02/02/2007"), "%d/%m/%Y"))    

# 3. Add a column "Date_Time"
Date_Time <- paste(dfs$Date, dfs$Time)
Date_Time <- ymd_hms(Date_Time)                 # Date_Time becomes POSIXct format
dfs2 <- dfs %>% 
        mutate(Date_Time) %>%
        select(Date_Time, everything())

# 4. Plotting plot3
png(file = "plot3.png", width = 480, height = 480)
with(dfs2, plot(Date_Time, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering", xaxt = "n"))
lines(dfs2$Date_Time, dfs2$Sub_metering_2, col = "red")
lines(dfs2$Date_Time, dfs2$Sub_metering_3, col = "blue")
ticks <- ymd_hms(c("2007-02-01 00:00:00","2007-02-02 00:00:00", "2007-02-03 00:00:00"))
axis(1, at = ticks, labels = wday(ticks, label = TRUE))
legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()
