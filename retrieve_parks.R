

# load libraries
library(RgoogleMaps)
library(googleway)
library(revgeo)
library(sp)
library(rgdal)
library(rgeos)
library(dplyr)
library(magrittr)



## retrieve parks


# create shell set for parks
parks = data.frame(matrix(NA,0,3))

# retrieve park names and locations
for (lon in seq(-76.35,-75.25,0.02)) {
  
  for (lat in seq(44.96,45.53,0.02)) {
    
    general_result <- google_places(search_string = 'park',
                                    location = c(lat, lon),
                                    radius = 0.3,
                                    key = gkey)
    
    temp = data.frame(name = general_result$results$name,
                      lat = general_result$results$geometry$location$lat,
                      lon = general_result$results$geometry$location$lng)
    
    parks = rbind(parks,temp)
    parks = unique(parks)
    
  }
  
}

# formatting
parks$name = as.character(parks$name)
parks %<>% arrange(name)
parks$id = 1:nrow(parks)

# create parks set copy
parks_copy = parks



## create shape file of ottawa


# read shape file of canadian cities
shp_ogr = readOGR('ger_000b11a_e/ger_000b11a_e.shp')

# select shape file of ottawa
ottawa = subset(shp_ogr,ERNAME=='Ottawa')

# retrieve coordinates of parks
coordinates(parks_copy) <- ~ lon + lat

# project park locations onto ottawa shapefile
proj4string(parks_copy) <- proj4string(ottawa)

# determine if park location is inside ottawa 
inside_check = over(parks_copy, ottawa)[,1]

# select parks inside ottawa
idx = which(!is.na(inside_check))

# create sets: parks inside/outside ottawa
parks_inside = parks[idx,]
parks_outside = subset(parks,!(parks$id %in% idx))



## out


# write ottawa parks to project folder
write.csv(parks_inside,'parks_ottawa.csv',row.names=FALSE)



