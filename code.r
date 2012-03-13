
setwd("~/Documents/Research/Code/Projects/kmaps") #! edit to reflect local path

### setRepositories(ind=1:2); install.packages("rgdal") ###
library(maptools); if (!rgeosStatus()) gpclibPermit() # returns TRUE
library(ggplot2)
library(reshape)
#library(grid)

# scrapped from Osmo Salomaa 
theme_map = function(size=12)
{
  o = list(axis.line=theme_blank(),
           axis.text.x=theme_blank(),
           axis.text.y=theme_blank(),
           axis.ticks=theme_blank(),
           axis.ticks.length=unit(0.3, "lines"),
           axis.ticks.margin=unit(0.5, "lines"),
           axis.title.x=theme_blank(),
           axis.title.y=theme_blank(),
           legend.background=theme_rect(fill="white", colour=NA),
           legend.key=theme_rect(colour="white"),
           legend.key.size=unit(1.2, "lines"),
           legend.position="right",
           legend.text=theme_text(size=size*0.8),
           legend.title=theme_text(size=size*0.8, face="bold",hjust=0),
           panel.background=theme_blank(),
           panel.border=theme_blank(),
           panel.grid.major=theme_blank(),
           panel.grid.minor=theme_blank(),
           panel.margin=unit(0, "lines"),
           plot.background=theme_blank(),
           plot.margin=unit(c(1, 1, 0.5, 0.5), "lines"),
           plot.title=theme_text(size=size*1.2),
           strip.background=theme_rect(fill="grey90",colour="grey50"),
           strip.text.x=theme_text(size=size*0.8),
           strip.text.y=theme_text(size=size*0.8, angle=-90))
  
  return(structure(o, class="options")) 
}

eco <- subset(read.csv("eco.csv",header=T,sep=","), iso2!="EU27") #; names(eco)
map <- readShapeSpatial("maps/data/CNTR_RG_60M_2006",proj4string=CRS("+proj=longlat"))
map <- rename(map, c(CNTR_ID="iso2")) #; summary(map)

### 

# issue with fortify method
# breaks at line 19 on R 2.14.2; used to work with R 2.14.0

# scrapped from Hadley Wickham
map@data$id <- rownames(map@data)
###map.points <- fortify.SpatialPolygonsDataFrame(map,region="id")
map.points <- fortify(map, region = "id")

map.df <- join(map.points,map@data,by="id")
map.df <- join(map.df,eco, by="iso2")

plim <- c(min(eco$mr_lung_m),max(eco$mr_lung_m))
map.df.missing <- subset(map.df,is.na(mr_lung_m))
mr_lung_m <- ggplot(map.df) + aes(long,lat,group=group,fill=mr_lung_m) + 
  geom_polygon(data=map.df.missing,aes(long,lat,group=group),fill="lightgrey") +
  geom_polygon() + geom_path(color="white") + 
  coord_cartesian(xlim = c(-24, 35), ylim = c(34, 72))  +  
  scale_fill_gradient("", limits=plim,low="yellow",high="red") +
  theme_map() + opts(aspect.ratio = .54); mr_lung_m

mr_lung_m + 
  geom_hline(aes(yintercept=72), colour="blue") + 
  geom_hline(aes(yintercept=34),colour="red") + 
  geom_vline(aes(xintercept=-24), colour="blue") + 
  geom_vline(aes(xintercept=35),colour="red")
