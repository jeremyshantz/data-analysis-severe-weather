# Severe Weather Effects on Health and Property: Recent Trends

## Synopsis
describes and summarizes your analysis in at most 10 complete sentences.

Storms and other severe weather events can cause both public health and economic problems for communities and municipalities. Many severe events can result in fatalities, injuries, and property damage, and preventing such outcomes to the extent possible is a key concern.

This project involves exploring the . This database tracks characteristics of major storms and weather events in the United States, including when and where they occur, as well as estimates of any fatalities, injuries, and property damage.

## Data Processing

We downloaded the U.S. National Oceanic and Atmospheric Administration's (NOAA) storm database from [here](https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2) on 2015-01-10. It contains storm data from 1950 to 2011. We load the raw data from the .csv.bz2 file this way:


```r
if (!exists('storm')) {
    storm <- read.csv('./repdata_data_StormData.csv.bz2')
}
```

### Transformations

We do some transformations based on the beginning date (BGN_DATE) field so we have a proper date format to work with. We create some convenience fields for year, decade and five year period to make it easy to analyse storm data over different aggregated time horizons. The five year periods are the year 00 - 04 and 05 - 09 for each decade and named after the first year in the period.


```r
# split out date from BGN_DATE's date/time factor and cast as Date
storm$evdate <-sapply(as.character(storm$BGN_DATE), function(x){ strsplit(x, split=c(' '))[[1]][1] })
storm$evdate <- as.Date(storm$evdate, format="%m/%d/%Y")
# Create separate year, decade and fiveyear period variables 
storm$year <- year(storm$evdate)
storm$decade = paste(substr(storm$year, 0,3), '0', sep='')
storm$fiveyear = paste(substr(storm$year, 0,3), ifelse(substr(storm$year, 4, 4) < 5, 0, 5), sep='')
```

Sum fatalities and injuries as casualties to simplify analysis of the health effects of storms.

```r
storm$casualties <- storm$FATALITIES + storm$INJURIES
```

Our main focus will be on event type, dates, property damage, and casualties.

```r
storm[sample(1:900000, 5), c(2,6:8, 23:27, 38:42)]
```

```
##                 BGN_DATE COUNTYNAME STATE      EVTYPE FATALITIES INJURIES
## 635545 7/21/2006 0:00:00     LEHIGH    PA FLASH FLOOD          0        0
## 628095 8/26/2006 0:00:00     CAMDEN    NJ   TSTM WIND          0        0
## 368677 4/24/1999 0:00:00   LE FLORE    OK        HAIL          0        0
## 532521 5/27/2004 0:00:00      WAYNE    IN FLASH FLOOD          0        0
## 197100 2/21/1993 0:00:00     OCONEE    GA        HAIL          0        0
##        PROPDMG PROPDMGEXP CROPDMG     evdate year decade fiveyear
## 635545       0                  0 2006-07-21 2006   2000     2005
## 628095       0                  0 2006-08-26 2006   2000     2005
## 368677       0                  0 1999-04-24 1999   1990     1995
## 532521       0                  0 2004-05-27 2004   2000     2000
## 197100       0                  0 1993-02-21 1993   1990     1990
##        casualties
## 635545          0
## 628095          0
## 368677          0
## 532521          0
## 197100          0
```

The EVTYPE field records the type of storm event. It is far from a well-curated taxonomy. 


```r
grep('Wind', unique(storm$EVTYPE), value = TRUE)
```

```
##  [1] "High Wind"           "Tstm Wind"           "Wind"               
##  [4] "Wind Damage"         "Strong Wind"         "Heavy Rain and Wind"
##  [7] "Thunderstorm Wind"   "Strong Winds"        "Gusty Wind"         
## [10] "Gusty Winds"         "Flood/Strong Wind"
```

```r
grep('Snow', unique(storm$EVTYPE), value = TRUE)
```

```
##  [1] "Snow"                 "Snow Squalls"         "Light Snow/Flurries" 
##  [4] "Late-season Snowfall" "Snow squalls"         "Ice/Snow"            
##  [7] "Snow Accumulation"    "Drifting Snow"        "Record May Snow"     
## [10] "Record Winter Snow"   "Late Season Snowfall" "Light Snow"          
## [13] "Snow and Ice"         "Light Snowfall"       "Blowing Snow"        
## [16] "Monthly Snowfall"     "Seasonal Snowfall"    "Lake Effect Snow"    
## [19] "Snow and sleet"       "Mountain Snows"
```

Since our objective is to provide forward guidance to municipal planners, we will focus our investigation on storms trends over the past ten years to 2011.

## Results

The events most harmful to population health are ....
The types of events that have the greatest economic consequences are .....

in which your results are presented.
Do the figure(s) have descriptive captions (i.e. there is a description near the figure of what is happening in the figure)?
Do all the results of the analysis (i.e. figures, tables, numerical summaries) appear to be reproducible?
* show the code for your entire analysis. 
* Your analysis can consist of tables, figures, or other summaries. 
* You may use any R package you want to support your analysis.
* Your data analysis must address the following questions:
    *  Across the United States, which types of events (as indicated in the EVTYPE variable) are most harmful with respect to population health?
    * Across the United States, which types of events have the greatest economic consequences?
* Write your report as if it were to be read by a government or municipal manager who is responsible for preparing for severe weather events and will need to prioritize resources
* no need to make any specific recommendations in your report.
* The analysis document must have at least one figure containing a plot.
* Your analyis must have no more than three figures. Figures may have multiple plots in them (i.e. panel plots), but there cannot be more than three figures total.
