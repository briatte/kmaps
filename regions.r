
## @knitr setup
setwd("~/Documents/Code/R/kmaps") #! edit to reflect local path

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
df1 <- subset(read.csv("data/eurostat.km.csv",encoding="UTF-8",na.strings="NA"))
reg <- readShapeSpatial("maps/regions/NUTS_RG_60M_2006",proj4string=CRS("+proj=longlat"))
reg <- rename(reg, c(NUTS_ID="nutsid"))

df2 <- subset(read.csv("data/iarc.eco.2008.csv",header=T,sep=","), iso2!="EU27")
nat <- readShapeSpatial("maps/countries/CNTR_RG_60M_2006",proj4string=CRS("+proj=longlat"))
nat <- rename(nat, c(CNTR_ID="iso2"))

## @knitr match
# Match.
reg@data$id <- rownames(reg@data)           # coded by Hadley Wickham (thanks!)
reg.points <- fortify(reg, region = "id")   # fixed by Roger Peng (thanks!)
reg.df <- join(reg.points,reg@data,by="id") # match map and rows
reg.df <- join(reg.df,df1, by="nutsid")       # match map and data

nat@data$id <- rownames(nat@data)           # coded by Hadley Wickham (thanks!)
nat.points <- fortify(nat, region = "id")   # fixed by Roger Peng (thanks!)
nat.df <- join(nat.points,nat@data,by="id") # match map and rows
nat.df <- join(nat.df,df2, by="iso2")       # match map and data

summary(plim <- c(min(df1$X2006_2008,na.rm=TRUE),max(df1$X2006_2008,na.rm=TRUE)))
str(reg.df <- subset(reg.df,!is.na(reg.df$X2006_2008)))
str(nat.df.1 <- subset(nat.df,!is.na(nat.df$mr)))
str(nat.df.0 <- subset(nat.df,is.na(mr)))

ggplot() + 
  geom_polygon(data=nat.df.0,aes(long,lat,group=group),fill="lightgrey") +
  geom_polygon(data=nat.df.1,aes(long,lat,group=group,fill=mr)) +
  geom_polygon(data=reg.df,aes(long,lat,group=group,fill=X2006_2008)) +
  coord_cartesian(xlim = c(-24, 35), ylim = c(34, 72)) + 
  scale_fill_gradient("ASR", limits=plim,low="yellow",high="red") +
  geom_path(data=nat.df,aes(long,lat,group=group),color="white") +
  theme_map()