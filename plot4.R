### Course Project 1 - Exploratory Data Analysis
### Using data from https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip

# Set url and file names to variables
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
fileName <- "household_power_consumption.txt"

# Download file and assign filename
if(!file.exists(fileName)){
        download.file(url = fileURL,
                      destfile = fileName,
                      method = "curl")
}

# Read file to R, assign it to a variable
HHdata <- read.csv(file = fileName,
                   sep = ";",
                   header = TRUE,
                   na.strings = "?")

# Convert Date column using as.Date, setting the correct format
HHdata$Date <- as.Date(HHdata$Date, format = "%d/%m/%Y")

# Select only 1st and 2nd Feb 2007 data
FebData <- subset(HHdata, subset = (Date >= "2007-02-01" & Date <="2007-02-02"))

# Join Date and Time columns, to make a distinct timestamp for all entries.
# Convert merged column DateTime in POSIXct
FebData$DateTime <- paste(FebData$Date, FebData$Time)
FebData$DateTime <- as.POSIXct(FebData$DateTime)



# Make up the required line graph for plot3
# par() sets the parameters for the 4-way plot.  mfrow sets the matrix
# structure we need (2x2), while mar sets the internal margin and oma sets
# the outer margin.  Both go in (bottom, left, top, right) and list the 
# number of lines of text distance (4,2,3,1) etc.
par(mfrow = c(2,2), mar =c(4,3,2,1), oma = c(0,0,0,0))
# Graph top left
# type choses the type of graph; l = line
plot(FebData$Global_active_power ~ FebData$DateTime, type = "l",
     ylab = "Global Active Power (kilowatts)",
     xlab = "")
# Graph top right
plot(FebData$Voltage ~ FebData$DateTime, type = "l",
     ylab = "Voltage",
     xlab = "datetime")
# Graph bottom left
# Plot the one line, then use the function lines() to add additional lines,
# including the specific line colour.  Can use lty and lwd to specify line
# type and width
plot(FebData$Sub_metering_1 ~ FebData$DateTime, type = "l",
     ylab = "Energy sub metering",
     xlab = "")
lines(FebData$Sub_metering_2 ~ FebData$DateTime, col = "red")
lines(FebData$Sub_metering_3 ~ FebData$DateTime, col = "blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lwd =2.5, col=c("black", "red", "blue"), cex = 0.40)
# Graph bottom right
plot(FebData$Global_reactive_power ~ FebData$DateTime, type = "l",
     ylab = "Global_reactive_power",
     xlab = "datetime")

# Save the quadrant output to a png file
dev.copy(png, file ="plot4.png", height = 480, width = 480)
dev.off()
