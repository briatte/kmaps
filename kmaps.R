
## @knitr setup, include=FALSE, tidy=FALSE
setwd("~/Documents/Code/R/kmaps") #! edit to reflect local path

require(maptools)
require(rgeos)
require(ggplot2)
require(RColorBrewer)
require(reshape)

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
source("themes.R")

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


## @knitr r knit, include=FALSE
require(knitr)
purl("kmaps.Rnw")


