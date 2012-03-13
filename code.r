
setwd("~/Documents/Research/Code/Projects/kmaps") #! edit to reflect local path

library(maptools); if (!rgeosStatus()) gpclibPermit() # returns TRUE
library(ggplot2)
library(reshape)

eco <- subset(read.csv("eco.csv",header=T,sep=","), iso2!="EU27") #; names(eco)
map <- readShapeSpatial("maps/data/CNTR_RG_60M_2006",proj4string=CRS("+proj=longlat"))
map <- rename(map, c(CNTR_ID="iso2")) #; summary(map)

### 

# issue with fortify method
# breaks at line 19 on R 2.14.2; used to work with R 2.14.0

# scrapped from Hadley Wickham
map@data$id <- rownames(map@data)
map.points <- fortify.SpatialPolygonsDataFrame(map,region="id")
# ERROR: could not find function "fortify.SpatialPolygonsDataFrame"
map.df <- join(map.points,map@data,by="id")
map.df <- join(map.df,eco, by="code")
