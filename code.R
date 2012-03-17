
## @knitr setup
setwd("~/Documents/Research/Code/Projects/kmaps") #! edit to reflect local path

library(knitr)
library(maptools); if (!rgeosStatus()) gpclibPermit() # allows fortify method
library(ggplot2)
library(grid)
library(RColorBrewer)
library(reshape)

theme_map = function(size=12) # adapted from Osmo Salomaa 
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
           legend.justification=c(0,0), # bottom of box
           legend.position=c(0,0),      # bottom of picture
           legend.text=theme_text(size=size*0.8),
           legend.title=theme_text(size=size*0.8, face="bold",hjust=0),
           panel.background=theme_blank(),
           panel.border=theme_rect(colour = 'grey50',size=1),
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

# Data.
eco <- subset(read.csv("data/iarc.eco.2008.csv",header=T,sep=","), iso2!="EU27")
map <- readShapeSpatial("maps/data/CNTR_RG_60M_2006",proj4string=CRS("+proj=longlat"))
map <- rename(map, c(CNTR_ID="iso2")) #; summary(map)


## @knitr match
# Match.
map@data$id <- rownames(map@data)           # coded by Hadley Wickham (thanks!)
map.points <- fortify(map, region = "id")   # fixed by Roger Peng (thanks!)
map.df <- join(map.points,map@data,by="id") # match map and rows
map.df <- join(map.df,eco, by="iso2")       # match map and data


## @knitr mr_m
# Lung cancer mortality rates, males
plim <- c(min(eco$mr_m),max(eco$mr_m))
map.df.missing <- subset(map.df,is.na(mr_m))
ggplot(map.df) + aes(long,lat,group=group,fill=mr_m) + 
  geom_polygon() + scale_fill_gradient("ASR", limits=plim,low="yellow",high="red") +   
  geom_polygon(data=map.df.missing,aes(long,lat,group=group),fill="lightgrey") +
  coord_cartesian(xlim = c(-24, 35), ylim = c(34, 72))  +  
  geom_path(color="white") + theme_map()


## @knitr mr_f
plim <- c(min(eco$mr_f),max(eco$mr_f))
map.df.missing <- subset(map.df,is.na(mr_f))
ggplot(map.df) + aes(long,lat,group=group,fill=mr_f) + 
  geom_polygon() + scale_fill_gradient("ASR", limits=plim,low="yellow",high="red") +
  geom_polygon(data=map.df.missing,aes(long,lat,group=group),fill="lightgrey") +
  coord_cartesian(xlim = c(-24, 35), ylim = c(34, 72))  +  
  geom_path(color="white") + theme_map()


