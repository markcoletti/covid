# Knox COVID-19 visualizations
#
library(COVID19)
library(ggplot2)
library(zoo)

us <- COVID19::covid19(country="US", level=3)

knox <- subset(us, administrative_area_level_3=="Knox" & administrative_area_level_2=="Tennessee")

# Shows the monotonically increasing number of confirmed cases
qplot(knox$date, knox$confirmed)

# This doesn't do what I want because knox$recovered are all zeroes.
# knox$active <- knox$confirmed - (knox$deaths + knox$recovered)

# Use zoo's diff() to compute the day-to-day change; [-1] to skip
# the first day to be in sync with the differences returned from diff()
day.differences = data.frame(date=knox$date[-1], diffs=diff(knox$confirmed))

g <- ggplot(data=day.differences, aes(date,diffs))
g + geom_line() + geom_smooth() + 
    labs(title = 'Day to day confirmed case differences', 
         subtitle = 'for Knoxville')

# New code added by Io from the Knoxville reddit discord server
offset_length = 14

day.differences$offsetdiffs = c(rep(0, offset_length), day.differences$diffs[1:(length(day.differences$diffs) - offset_length)] )
day.differences$revoveredish = cumsum(day.differences$offsetdiffs)

KNOX$activeish = rep(0, length(KNOX$confirmed))
KNOX$activeish[-1] = KNOX$confirmed[-1] - day.differences$revoveredish

qplot(KNOX$date, KNOX$activeish) + geom_line()
