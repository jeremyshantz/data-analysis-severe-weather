setwd('~/R/reproducibleResearch/project2')

filename.raw.data <- './repdata_data_StormData.csv.bz2'
url.raw.data <- 'https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2'

suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(lubridate))

if (!file.exists(filename.raw.data)) {
    download.file(url.raw.data, filename.raw.data, method='curl')    
}

if (!exists('storm')) {
    storm <- read.csv('./repdata_data_StormData.csv.bz2')

}


storm$evdate <-sapply(as.character(storm$BGN_DATE), function(x){ strsplit(x, split=c(' '))[[1]][1] })
storm$evdate <- as.Date(storm$evdate, format="%m/%d/%Y")
storm$year <- year(storm$evdate)
storm$decade = paste(substr(storm$year, 0,3), '0', sep='')
storm$fiveyear = paste(substr(storm$year, 0,3), ifelse(substr(storm$year, 4, 4) < 5, 0, 5), sep='')
storm$casualties <- storm$FATALITIES + storm$INJURIES
storm$damages <- storm$PROPDMG + storm$CROPDMG

storm$PROPDMGEXP <- ifelse(storm$PROPDMGEXP == 'm' | storm$PROPDMGEXP == 'M', 'm', 'k')
storm$CROPDMGEXP <- ifelse(storm$CROPDMGEXP == 'm' | storm$CROPDMGEXP == 'M', 'm', 'k')

storms2003 <- filter(storm, evdate > '2002-01-01', evdate < '2003-01-01')
storms2011 <- filter(storm, evdate > '2011-01-01', evdate < '2012-01-01')

# fatalities by decade
with(storm, tapply(FATALITIES, decade, sum, na.rm = TRUE))  

# five year period

# property damage
mn0 <- with(storm, tapply(PROPDMG, fiveyear, sum, na.rm = TRUE))  
mn1 <- with(storm, tapply(FATALITIES, fiveyear, sum, na.rm = TRUE))  
mn2 <- with(storm, tapply(INJURIES, fiveyear, sum, na.rm = TRUE))  
d0 <- data.frame(five.year.period = names(mn0), property.damage = mn0)
d1 <- data.frame(five.year.period = names(mn1), fatalities = mn1)
d2 <- data.frame(five.year.period = names(mn2), injuries = mn2)

fiveyeardata <- merge(d0, d1, by = "five.year.period")
fiveyeardata <- merge(fiveyeardata, d2, by = "five.year.period")
 


plot(mn0[1:12], type='l')

# Top damage - 5 years
recent.damage.nums <- with(storm[storm$fiveyear == '2005',], tapply(PROPDMG, EVTYPE, sum, na.rm = TRUE))
recent.damage <- data.frame(property.damage = recent.damage.nums, event <- names(recent.damage.nums))
recent.damage$property.damage <- as.numeric(recent.damage$property.damage)
recent.damage <- arrange(recent.damage, desc(property.damage))
names(recent.damage) <- c('property.damage', 'event')

# Top casualties - 5 years
recent.casualties.nums <- with(storm[storm$fiveyear == '2005',], tapply(casualties, EVTYPE, sum, na.rm = TRUE))
recent.casualties <- data.frame(casualties = recent.casualties.nums, event <- names(recent.casualties.nums))
recent.casualties$casualties <- as.numeric(recent.casualties$casualties)
recent.casualties <- arrange(recent.casualties, desc(casualties))
names(recent.casualties) <- c('casualties', 'event')

# Top 10 events - casualty  - all time
all.casualties.nums <- with(storm, tapply(casualties, EVTYPE, sum, na.rm = TRUE))
all.casualties <- data.frame(casualties = all.casualties.nums, event <- names(all.casualties.nums))
all.casualties$casualties <- as.numeric(all.casualties$casualties)
all.casualties <- arrange(all.casualties, desc(casualties))
names(all.casualties) <- c('casualties', 'event')


# Top 10 events - damage  - all time
all.damage.nums <- with(storm[storm$fiveyear == '2005',], tapply(damages, EVTYPE, sum, na.rm = TRUE))
all.damage <- data.frame(property.damage = all.damage.nums, event <- names(all.damage.nums))
all.damage$property.damage <- as.numeric(all.damage$property.damage)
all.damage <- arrange(all.damage, desc(property.damage))
names(all.damage) <- c('property.damage', 'event')

# plot
fiveyear.damage.nums <- tapply(storm$damages, storm$fiveyear, sum)
fiveyear.damage <- data.frame(damages = fiveyear.damage.nums[1:12] / 1000, fiveyear = names(fiveyear.damage.nums[1:12]))
fiveyear.plot <- ggplot(data = fiveyear.damage, aes(x=fiveyear, y=damages, width=0.3)) +
    geom_bar(stat='identity') +
    ggtitle("Storm Damage By Five Year Period - 1950-2009") +
    xlab('Data source: U.S. National Oceanic and Atmospheric Administration (NOAA)') +
    ylab('Property and crop damage (millions of dollars') 
print(fiveyear.plot)

# summary(storms2003$FATALITIES)
# summary(storms2011$FATALITIES)
# 
# summary(storms2003$INJURIES)
# summary(storms2011$INJURIES)
# 
# summary(storms2003$PROPDMG)
# summary(storms2011$PROPDMG)
# 
# 
# 
#
# # deaths in 2011    
# plot(filter(tops, FATALITIES > 11, year==2011)$FATALITIES, col = unique(recent$EVTYPE), pch=1)
# legend('topright', legend=unique(tops$EVTYPE), col = unique(recent$EVTYPE), pch=1)


