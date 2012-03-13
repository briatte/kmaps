
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

###

# older method, using maptools
# works fine but no ggplot2 graph candy

library(RColorBrewer)
library(classInt)

kmap <- function(v,q=5,xcoord=c(-10,40),ycoord=c(35,70)) {
  
  # quantiles
  colours <- brewer.pal(q, "YlOrRd")
  class <- classIntervals(v, q, style="quantile")
  colcode <- findColours(class, colours)

  # match
  matched.codes<-match(map$iso2,eco$iso2)
  matched.colours<-colcode[matched.codes]
  matched.colours[is.na(matched.colours)] <- "#EEEEEE"
  
  # map
  par(mar=c(0,0,0,0))
  plot(map,col=matched.colours,xlim=xcoord,ylim=ycoord)
  
  # legend
  legend(xcoord[1],ycoord[2],legend=names(attr(colcode,"table")), fill=attr(colcode, "palette"), cex=0.75, bty="n")

  return(class)
  }

# Examples

kmap(eco$mr_lung_f,q=5) # Lung cancer mortality rates for females
kmap(eco$mr_lung_m,q=5) # Lung cancer mortality rates for males


