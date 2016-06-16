# WK8 Interactive Data Visualization

## Install packages (if error message like 
## "Warning in install.packages : package 'rCharts' 
## is not available", google search the package 
## and manually download and install)
install.packages("devtools")
library(devtools)
install.packages("ggvis")
install.packages("googleVis")
require(devtools)
library(Rcpp)
install_github('rCharts', 'ramnathv')
install.packages("plotly")
install.packages("dplyr")
install.packages("tidyr")
install.packages("knitr")

# Load packages
library("ggvis")
library("googleVis")
library("rCharts")
library("plotly")
library("dplyr")
library("tidyr")
library("knitr")


# Define image sizes
img.width = 450
img.height = 300
options(RCHART_HEIGHT = img.height, RCHART_WIDTH = img.width)
opts_chunk$set(fig.width=6, fig.height=4)


# Use mtcars data
data(mtcars)
mtcars$cyl = factor(mtcars$cyl)
mtcars$am = factor(mtcars$am)
# Compute mean mpg per cyl and am
mtcars.mean = mtcars %>% group_by(cyl, am) %>% 
  summarise(mpg_mean=mean(mpg)) %>% 
  select(cyl, am, mpg_mean) %>% ungroup()

hist.ggplot = ggplot(mtcars, aes(x=mpg)) + geom_histogram(binwidth=1)
hist.ggplot

hist.ggvis = mtcars %>% ggvis(x = ~mpg) %>% layer_histograms(width=1) %>% 
  set_options(width = img.width, height = img.height)
hist.ggvis




# rCharts histogram needs manual binning and counting!
hist.rcharts = rPlot(x="bin(mpg,1)", y="count(id)", data=mtcars, type="bar")
# Use this with 'Knit HTML' button
# hist.rcharts$print(include_assets=TRUE)
# Use this with jekyll blog
hist.rcharts$show('iframesrc', cdn=TRUE)

## Please note that by default the googleVis plot command
## will open a browser window and requires an internet
## connection to display the visualisation.

df <- data.frame(country=c("US", "GB", "BR"),
                 val1=c(1,3,4),
                 val2=c(23,12,32))

## Bar chart
Bar1 <- gvisBarChart(df, xvar="country", yvar=c("val1", "val2"))
plot(Bar1)

## Stacked bar chart
Bar2 = gvisBarChart(df, xvar="country", yvar=c("val1", "val2"),
                     options=list(isStacked=TRUE))
plot(Bar2)

## Please note that by default the googleVis plot command
## will open a browser window and requires an internet
## connection to display the visualisation.

CityPopularity
## Add the mean
CityPopularity$Mean=mean(CityPopularity$Popularity)

C1 <- gvisComboChart(CityPopularity, xvar="City",
                     yvar=c("Mean", "Popularity"),
                     options=list(seriesType="bars",
                                  title="City Popularity",
                                  series='{0: {type:"line"}}'))
plot(C1)

## Changing the width of columsn
C2 <- gvisComboChart(CityPopularity, xvar="City",
                     yvar=c("Mean", "Popularity"),
                     options=list(seriesType="bars",
                                  bar="{groupWidth:'100%'}",
                                  title="City Popularity",
                                  series='{0: {type:"line"}}'))
plot(C2)

## Scatter chart
Scatter1 <- gvisScatterChart(women)
plot(Scatter1)

## Using optional arguments
Scatter2 <- gvisScatterChart(women, 
                             options=list(legend="none",lineWidth=2, pointSize=2,title="Women", 
                                          vAxis="{title:'weight (lbs)'}",crosshair="{ trigger: 'both' }",
                                          hAxis="{title:'height (in)'}", width=500, height=400))

plot(Scatter2)


df=data.frame(x=sin(1:100/3),
              Circle=cos(1:100/3),
              Ellipse=cos(1:100/3)*0.5)

## Plot several variables as smooth curves
Scatter3 <- gvisScatterChart(df,
                             options=list(curveType='function',
                                          pointSize=0,
                                          lineWidth=2))
plot(Scatter3)

## Two series in the same plot with different
## x-values
df <- data.frame(x=c(2,2,1,3,4),
                 y1=c(0,3,NA,NA,NA),
                 y2=c(NA,NA,0,3,2))
Scatter4 <- gvisScatterChart(df,
                             options=list(lineWidth=2,
                                          pointSize=2))
plot(Scatter4)

## Customize points
M <- matrix(nrow=6,ncol=6)
M[col(M)==row(M)] <- 1:6
dat <- data.frame(X=1:6, M)
SC <- gvisScatterChart(dat,
                       options=list(
                         title="Customizing points",
                         legend="right",
                         pointSize=30,
                         series="{
                             0: { pointShape: 'circle' },
                             1: { pointShape: 'triangle' },
                             2: { pointShape: 'square' },
                             3: { pointShape: 'diamond' },
                             4: { pointShape: 'star' },
                             5: { pointShape: 'polygon' }
                             }"))
plot(SC)

bubble1 <- gvisBubbleChart(Fruits, idvar="Fruit", xvar="Sales", yvar="Expenses")
plot(bubble1)

## Set color and size
bubble2 <- gvisBubbleChart(Fruits, idvar="Fruit", xvar="Sales", yvar="Expenses",
                           colorvar="Location", sizevar="Profit",
                           options=list(hAxis='{minValue:75, maxValue:125}'))

plot(bubble2)

## Use year to color the bubbles
bubble3 <- gvisBubbleChart(Fruits, idvar="Fruit", xvar="Sales", yvar="Expenses",
                           colorvar="Year", sizevar="Profit",
                           options=list(hAxis='{minValue:75, maxValue:125}'))
plot(bubble3)

## Gradient colour example
bubble4 <- gvisBubbleChart(Fruits, idvar="Fruit", xvar="Sales", yvar="Expenses",
                           sizevar="Profit",
                           options=list(hAxis='{minValue:75,  maxValue:125}',
                                        colorAxis="{colors: ['lightblue', 'blue']}"))
plot(bubble4)

## Moving bubble chart over time, aka motion chart
data("Fruits")
M <- gvisMotionChart(Fruits, "Fruit", "Year")
plot(M)


## Example data set
OpenClose

C1 <- gvisCandlestickChart(OpenClose, xvar="Weekday", low="Low",
                           open="Open", close="Close",
                           high="High",
                           options=list(legend='none'))

plot(C1)


## Doughnut chart
Pie2 <- gvisPieChart(CityPopularity, options=list(
  slices="{4: {offset: 0.2}, 0: {offset: 0.3}}",
  title='City popularity',
  legend='none',
  pieSliceText='label',
  pieHole=0.5))
plot(Pie2)

