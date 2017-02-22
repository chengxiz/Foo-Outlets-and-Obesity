FoodServices_Spatial<-FoodServices %>%
  #filter(COUNTY=="ERIE") %>%
  select(LONGITUDE,LATITUDE) %>%
  as.matrix() %>%
  SpatialPointsDataFrame(subset(data.frame(FoodServices),select=-c(LONGITUDE,LATITUDE)),proj4string=CRS("+proj=longlat +datum=WGS84"))

Subset.Groceries_Spatial<-Subset.Groceries %>%
  select(Longitude,Latitude) %>%
  as.matrix() %>%
  SpatialPointsDataFrame(subset(data.frame(Subset.Groceries),select=-c(Longitude,Latitude)),proj4string=CRS("+proj=longlat +datum=WGS84"))

Subset.Supermarkets_Spatial<-Subset.Supermarkets %>%
  select(Longitude,Latitude) %>%
  as.matrix() %>%
  SpatialPointsDataFrame(subset(data.frame(Subset.Supermarkets),select=-c(Longitude,Latitude)),proj4string=CRS("+proj=longlat +datum=WGS84"))

NYSD=readOGR(dsn="../Original Data/NYSD", layer="NYSD")
SDL_10_12<-Obesity.10_12.lunch[175:2235,]
SDL_10_12$Location.1<-as.character(SDL_10_12$Location.1)
LNG<-c()
LAT<-c()
for (i in SDL_10_12$Location.1){
  tryCatch(
    {LNG<-c(LNG,strsplit(i,", ")[[1]][2])
    LAT<-c(LAT,strsplit(i,", ")[[1]][1])
    },
    error = function(e){
      LNG<-c(LNG,NULL)
      LAT<-c(LAT,NULL)
    }
  )
}
SDL_10_12$LONGITUDE<-gsub("\\)","",LNG)
SDL_10_12$LATITUDE<-gsub("\\(","",LAT)
SDL_10_12<-SDL_10_12[!is.na(SDL_10_12$ZIP.CODE),]
write.csv(SDL_10_12,"SDL_10_12.csv")

SDL_12_14<-Obesity.12_14.lunch[175:2229,]
SDL_12_14$Location.1<-as.character(SDL_12_14$Location.1)
LNG<-c()
LAT<-c()
for (i in SDL_12_14$Location.1){
  tryCatch(
    {LNG<-c(LNG,strsplit(i,", ")[[1]][2])
    LAT<-c(LAT,strsplit(i,", ")[[1]][1])
    },
    error = function(e){
      LNG<-c(LNG,NULL)
      LAT<-c(LAT,NULL)
    }
  )
}
SDL_12_14$LONGITUDE<-gsub("\\)","",LNG)
SDL_12_14$LATITUDE<-gsub("\\(","",LAT)
SDL_12_14<-SDL_12_14[!is.na(SDL_12_14$ZIP.CODE),]
write.csv(SDL_12_14,"SDL_12_14.csv")

write.csv(FoodServices,"FoodServices.csv")
write.csv(FoodStores,"FoodStores.csv")

### All the data are imported into ArcGIS to clean
### Obesity_12_14_cleaned.csv
### Obesity_10_12_cleaned.csv
### FoodServices_Geo_Cleaned.csv
### FoodStores_Geo_Cleaned.csv

### ARE THE FINAL CLEANED DATA