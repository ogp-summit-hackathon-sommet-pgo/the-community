
library(ggmap)
library(ggthemes)
library(RgoogleMaps)
library(googleway)
library(revgeo)


register_google(key = "AIzaSyDWv3jS3lB8xewu8RtYKxXsl18XEC9ySxo")

v=vector()

for (longs in seq(-75.5918385,-75.7693497,-0.0384535)) {
  
  for (lats in seq(45.4498298,45.3696841,-0.0384535)) {
    
    map <- get_googlemap(center = c(lon=longs,lat=lats), zoom = 14, maptype = "roadmap", 
                         style = '|element:labels|visibility:off')
    
    print(ggmap(map,extent='device'))
    ggsave(paste0('plot',longs,',',lats,'.png'))
    
    map[map!='#C2EDB1'] = NA
    map1 = matrix(map,1280,1280)
    print(length(which(map1!='NA')))
    
  }
  
}