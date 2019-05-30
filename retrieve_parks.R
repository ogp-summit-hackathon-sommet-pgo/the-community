

library(RgoogleMaps)
library(googleway)
library(revgeo)
library(sp)
library(rgdal)
library(rgeos)
library(dplyr)
library(magrittr)




parks = data.frame(matrix(NA,0,3))

for (lon in seq(-76.35,-75.25,0.02)) {
  
  for (lat in seq(44.96,45.53,0.02)) {
    
    general_result <- google_places(search_string = 'park',
                                    location = c(lat, lon),
                                    radius = 0.3,
                                    key = google_key)
    
    temp = data.frame(name = general_result$results$name,
                      lat = general_result$results$geometry$location$lat,
                      lon = general_result$results$geometry$location$lng)
    
    parks = rbind(parks,temp)
    parks = unique(parks)
    
  }
  
}

parks$name = as.character(parks$name)
parks %<>% arrange(name)
parks$id = 1:nrow(parks)

parks_copy = parks

shp_ogr = readOGR('ger_000b11a_e/ger_000b11a_e.shp')
ottawa = subset(shp_ogr,ERNAME=='Ottawa')

coordinates(parks_copy) <- ~ lon + lat

proj4string(parks_copy) <- proj4string(ottawa)
inside_check = over(parks_copy, ottawa)[,1]
idx = which(!is.na(inside_check))
parks_inside = parks[idx,]
parks_outside = subset(parks,!(parks$id %in% idx))

write.csv(parks_inside,'parks_ottawa.csv',row.names=FALSE)



