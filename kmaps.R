
## @knitr setup, include=FALSE, tidy=FALSE
setwd("~/Documents/Code/R/kmaps") #! edit to reflect local path

library(knitr)
library(maptools)
library(rgeos)
library(ggplot2)
library(RColorBrewer)
library(reshape)

# knitr options

opts_knit$set(out.format = "latex")

knit_theme$set("edit-xcode")

opts_chunk$set(echo=FALSE,
  results    = 'hide',
  out.width  = '0.75\\textwidth',
  out.height = '0.75\\textwidth',
  background = 'white',
  fig.path   = 'figures/map-',
  fig.align  = 'center')

# ggplot2 theme

theme_map <- function(base_size = 12, base_family = "") {
  theme_grey() %+replace% 
    theme(# initial code by Osmo Salomaa
      axis.line            = element_blank(),
      axis.text.x          = element_blank(),
      axis.text.y          = element_blank(),
      axis.ticks           = element_blank(),
      axis.ticks.length    = unit(0.3, "lines"),
      axis.ticks.margin    = unit(0.5, "lines"),
      axis.title.x         = element_blank(),
      axis.title.y         = element_blank(),
      legend.background    = element_rect(fill="white", colour=NA),
      legend.key           = element_rect(colour="white"),
      legend.key.size      = unit(1.2, "lines"),
      legend.justification = c(0,0), # bottom of box
      legend.position      = c(0,0),      # bottom of picture
      legend.text          = element_text(size=base_size*0.8),
      legend.title         = element_text(size=base_size*0.8, face="bold",hjust=0),
      panel.background     = element_blank(),
      panel.border         = element_rect(colour = "grey90", size = 1, fill = NA),
      panel.grid.major     = element_blank(),
      panel.grid.minor     = element_blank(),
      panel.margin         = unit(0, "lines"),
      plot.background      = element_blank(),
      plot.margin          = unit(c(1, 1, 0.5, 0.5), "lines"),
      plot.title           = element_text(size = base_size*1.2),
      strip.background     = element_rect(fill = "grey90", colour = "grey50"),
      strip.text.x         = element_text(size=base_size*0.8),
      strip.text.y         = element_text(size=base_size*0.8, angle=-90))
}

# load data

eco <- subset(read.csv("data/iarc.eco.2008.csv", header = TRUE, sep=","), iso2 != "EU27")
map <- readShapeSpatial("maps/countries/CNTR_RG_60M_2006", proj4string = CRS("+proj=longlat"))
map <- rename(map, c(CNTR_ID = "iso2")) #; summary(map)


## @knitr match, echo=TRUE, background='#F7F7F7'
map@data$id <- rownames(map@data)
map.points <- fortify(map, region = "id")
map.df <- join(map.points, map@data, by = "id")
map.df <- join(map.df, eco, by = "iso2")


## @knitr kmap
kmap <- ggplot(map.df) + 
  coord_cartesian(xlim = c(-24, 35), ylim = c(34, 72)) +  
  aes(long, lat, group = group) +
  geom_path(color = "white") + 
  geom_polygon() + 
  theme_map()


## @knitr mr_m, cache=TRUE
plim <- c(min(eco$mr_m), max(eco$mr_m))
map.df.missing <- subset(map.df, is.na(mr_m))
kmap +
  geom_polygon(data = map.df.missing, aes(long, lat, group = group), fill = "lightgrey") +
  scale_fill_gradient("ASR", limits = plim, low = "yellow", high = "red") +
  aes(fill = mr_m)


## @knitr mr_f, cache=TRUE
plim <- c(min(eco$mr_f),max(eco$mr_f))
map.df.missing <- subset(map.df,is.na(mr_f))
kmap + 
  geom_polygon(data = map.df.missing, aes(long, lat, group = group), fill = "lightgrey") +
  scale_fill_gradient("ASR", limits = plim, low = "yellow", high = "red") +
  aes(fill = mr_f)


