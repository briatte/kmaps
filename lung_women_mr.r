# what: map cancer mortality rates for women in EU-27 countries in 2008
# who/when: François Briatte, 2011-04-09

# libraries
library(maptools)
library(RColorBrewer)
library(classInt)
library(reshape)

setwd("~/Desktop/kmaps")

# load data
data <- read.table("ecodata.csv",header=T,sep=",")
names(data)
# drop non-EU27 countries
cancer <- subset(data, data$eu27 == 1) 
cancer$country
# select one variable
v <- cancer$lung_women_mr

# load map
europe<- readShapeSpatial("eu_shape/CNTR_RG_60M_2006.shp",proj4string=CRS("+proj=longlat"))
summary(europe)
# setup map
# eu27 <- europe$CNTR_ID %in% cancer$code
xcoord <- c(-10,40)
ycoord <- c(35,70)

# load variable and assign colours to equals steps
nclr <- 5
colours <- brewer.pal(nclr, "YlOrRd")
# quartile intervals
class <- classIntervals(v, nclr, style="quantile")
colcode <- findColours(class, colours)

# match map and data
matched.codes<-match(europe$CNTR_ID,cancer$code)
matched.colours<-colcode[matched.codes]
matched.colours[is.na(matched.colours)] <- "#EEEEEE"

# map
par(mar=c(0,0,0,0))
plot(europe,col=matched.colours,xlim=xcoord,ylim=ycoord)
# legend
legend(-10,70,legend=names(attr(colcode,"table")), fill=attr(colcode, "palette"), cex=0.75, bty="n")