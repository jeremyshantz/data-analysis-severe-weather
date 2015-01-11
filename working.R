setwd('~/R/reproducibleResearch/project2')

filename.raw.data <- './data/repdata_data_StormData.csv.bz2'
url.raw.data <- 'https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2'

library(lubridate)

if (!file.exists(filename.raw.data)) {
    download.file(url.raw.data, filename.raw.data)    
}

if (!exists('storm')) {
    storm <- read.csv(filename.raw.data)    
    storm$plddate <-sapply(as.character(storm$BGN_DATE), function(x){ strsplit(x, split=c(' '))[[1]][1] })
    storm$ddate <- as.Date(storm$ddate, format="%m/%d/%Y")
    
}

storm$year = year(storm$ddate)

recent <- filter(storm, ddate > '2011-01-01
                 ')
tops <- storm  %>% group_by(EVTYPE, year) %>% summarise_each(funs(sum), FATALITIES) %>% arrange(desc(year)) %>% filter(FATALITIES > 0)

