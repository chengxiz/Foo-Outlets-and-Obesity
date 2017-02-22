library(dplyr)
library(tidyr)
library(sp)
library(spdep)
library(rgdal)
FoodStores<-read.csv("../../Processed Data/Geocoded_Retail_Food_Stores.csv",strip.white = TRUE)
FoodStores<-FoodStores %>%
  filter(!is.na(Longitude)) %>%
  filter(!is.na(Latitude))
drops<-c("License.Number","Operation.Type","Street.Number","Street.Name","Address.Line.2","Address.Line.3")
FoodStores<-FoodStores[,!(names(FoodStores) %in% drops)]

rm(list=c("Stores.List.Supermarkets","Stores.List"))

Obesity<-read.csv("../../Original Data/SWSCR/Student_Weight_Status_Category_Reporting_Results__Beginning_2010.csv",strip.white = TRUE)
LocationArray<-c()
LATITUDE_LIST<-c()
LONGITUDE_LIST<-c()
for (i in 1:dim(Obesity)[1]){
  LATITUDE=NULL
  LONGITUDE=NULL
  tryCatch(
    {
      LocationArray<-unlist(strsplit(toString(Obesity$Location.1[i]),","))
      LATITUDE<-gsub("\\(","",LocationArray[1])
      LONGITUDE<-gsub("\\)","",LocationArray[2])
    },
    error=function(e){
      LATITUDE=NULL
      LONGITUDE=NULL
    },
    finally = {
      LATITUDE_LIST<-c(LATITUDE_LIST,LATITUDE)
      LONGITUDE_LIST<-c(LONGITUDE_LIST,LONGITUDE)
    }
  )
}
Obesity$LATITUDE<-LATITUDE_LIST
Obesity$LONGITUDE<-LONGITUDE_LIST
Obesity.10_12<-filter(Obesity,SCHOOL.YEARS=="2010-2012")
Obesity.12_14<-filter(Obesity,SCHOOL.YEARS=="2012-2014")
rm(list=c("LocationArray","LATITUDE","LONGITUDE","LATITUDE_LIST","LONGITUDE_LIST"))

Per_Lunch<-read.csv("../../Original Data/NYSED/ReportCardDatabase2014/subeset_demo_2014.csv")
colnames(Per_Lunch)[2] <- "AREA.NAME"
LogicalArray<-c()
#Extract school district level data
for (i in 1:dim(Per_Lunch)[1]){
  LogicalArray<-c(LogicalArray,any(grep("^.+0000$", toString(Per_Lunch$ENTITY_CD[i]))))
}
summary(LogicalArray)
Per_Lunch<-Per_Lunch[LogicalArray,]
#Standardize the entity ID
Per_Lunch$ENTITY_CD<-as.integer(substr(Per_Lunch$ENTITY_CD,1,(nchar(Per_Lunch$ENTITY_CD)-12+6)))
colnames(Per_Lunch)[2] <- "LOCATION.CODE"

Per_Lunch.2012=filter(Per_Lunch,YEAR==2012)
Per_Lunch.2013=filter(Per_Lunch,YEAR==2013)
Per_Lunch %>%
  group_by(YEAR) %>%
  summarise(count=n())

# Check the matching situation
tmp2012<-semi_join( Per_Lunch.2012, Obesity.12_14, by = "LOCATION.CODE")
tmp2013<-semi_join( Per_Lunch.2013, Obesity.12_14, by = "LOCATION.CODE")
print(setdiff(tmp2013$LOCATION.CODE,tmp2012$LOCATION.CODE))
print(setdiff(tmp2012$LOCATION.CODE,tmp2013$LOCATION.CODE))
print(setdiff(Obesity.12_14$LOCATION.CODE,tmp2012$LOCATION.CODE))
print(setdiff(tmp2012$LOCATION.CODE,Obesity.12_14$LOCATION.CODE))
# The result is perfect, lunch data have more rows(school districts) than obesity data,but it doesn't matter

#Merge tmp2012 and tmp2013 to clean_lunch
colnames(tmp2012)[5:6] <- c("PER_FREE_LUNCH_2012","PER_REDUCED_LUNCH_2012")
colnames(tmp2013)[5:6] <- c("PER_FREE_LUNCH_2013","PER_REDUCED_LUNCH_2013")
clean_lunch<-inner_join(tmp2012,tmp2013,by="LOCATION.CODE")
summary(clean_lunch$AREA.NAME.x==clean_lunch$AREA.NAME.y)
exceptions<-clean_lunch[!clean_lunch$AREA.NAME.x==clean_lunch$AREA.NAME.y,]
#View(exceptions)
  #Mean value of 2012 and 2013
clean_lunch$PER_FREE_LUNCH_MEAN<-(clean_lunch$PER_FREE_LUNCH_2012+clean_lunch$PER_FREE_LUNCH_2013)/2
clean_lunch$PER_REDUCED_LUNCH_MEAN<-(clean_lunch$PER_REDUCED_LUNCH_2012+clean_lunch$PER_REDUCED_LUNCH_2013)/2
keeps<-c("LOCATION.CODE","PER_FREE_LUNCH_MEAN","PER_REDUCED_LUNCH_MEAN")
clean_lunch<-clean_lunch[keeps]
#Merge clean_lunch with obesity data
Obesity.12_14.lunch<-left_join(Obesity.12_14,clean_lunch,by="LOCATION.CODE")

#Clean Food Services data
FoodServices<-read.csv("../../Original Data/NYSDOH/Food_Service_Establishment__Last_Inspection.csv")
keeps<-c("FACILITY","ADDRESS","DESCRIPTION","COUNTY","FACILITY.ADDRESS","CITY","ZIP.CODE","Location1")
FoodServices<-FoodServices[keeps]
LocationArray<-c()
LATITUDE_LIST<-c()
LONGITUDE_LIST<-c()
for (i in 1:dim(FoodServices)[1]){
  LATITUDE=NULL
  LONGITUDE=NULL
  tryCatch(
    {
      LocationArray<-unlist(strsplit(toString(FoodServices$Location1[i]),","))
      LATITUDE<-gsub("\\(","",LocationArray[1])
      LONGITUDE<-gsub("\\)","",LocationArray[2])
    },
    error=function(e){
      LATITUDE=NA
      LONGITUDE=NA
    },
    finally = {
      LATITUDE_LIST<-c(LATITUDE_LIST,LATITUDE)
      LONGITUDE_LIST<-c(LONGITUDE_LIST,LONGITUDE)
    }
  )
}
FoodServices$LONGITUDE<-as.numeric(LONGITUDE_LIST)
FoodServices$LATITUDE<-as.numeric(LATITUDE_LIST)
summary(FoodServices$LATITUDE)
summary(FoodServices$LONGITUDE)
keeps<-c("FACILITY","ADDRESS","COUNTY","CITY","ZIP.CODE","LONGITUDE","LATITUDE")
FoodServices<-FoodServices[keeps]

#Standardize county name "ST. LAWRENCE" and remove counties of NYC

tmp2<-FoodServices %>%
  group_by(COUNTY) %>%
  summarise(count=n()) %>%
  arrange(desc(count))

FoodServices$COUNTY<-as.character(FoodServices$COUNTY)
FoodServices$COUNTY[FoodServices$COUNTY=="ST LAWRENCE"]<-"ST. LAWRENCE"
FoodServices$COUNTY<-as.factor(FoodServices$COUNTY)

Obesity.12_14.lunch$COUNTY<-as.character(Obesity.12_14.lunch$COUNTY)
Obesity.12_14.lunch$COUNTY[Obesity.12_14.lunch$COUNTY=="ST.LAWRENCE"]<-"ST. LAWRENCE"
Obesity.12_14.lunch$COUNTY<-as.factor(Obesity.12_14.lunch$COUNTY)

Obesity.10_12.lunch$COUNTY<-as.character(Obesity.10_12.lunch$COUNTY)
Obesity.10_12.lunch$COUNTY[Obesity.10_12.lunch$COUNTY=="ST.LAWRENCE"]<-"ST. LAWRENCE"
Obesity.10_12.lunch$COUNTY<-as.factor(Obesity.10_12.lunch$COUNTY)

FoodStores$County<-as.factor(toupper(FoodStores$County))
rm.list<-setdiff(FoodStores$County,FoodServices$COUNTY)
FoodStores<-FoodStores[!FoodStores$County %in% rm.list,]

tmp1<-FoodStores %>%
  group_by(County) %>%
  summarise(count=n()) %>%
  arrange(desc(count))

print(setdiff(tmp1$County,tmp2$COUNTY))

Stores.List<-FoodStores %>%
  group_by(Entity.Name) %>%
  summarise(count=n(),mean.Square.Footage=mean(Square.Footage)) %>%
  arrange(desc(count))
Stores.List.Supermarkets<-filter(Stores.List,mean.Square.Footage>20000)
plot(Stores.List.Supermarkets$count,Stores.List.Supermarkets$mean.Square.Footage)

Stores.List.Supermarkets %>%
  group_by(Establishment.Type) %>%
  summarise(count=n()) %>%
  arrange(desc(count))
Subset.Supermarkets<-semi_join(FoodStores,Stores.List.Supermarkets,by="Entity.Name")
Subset.Groceries<-anti_join(FoodStores,Stores.List.Supermarkets,by="Entity.Name")



rm(list=setdiff(ls(), c("FoodStores","FoodServices","Subset.Groceries","Subset.Supermarkets","Obesity.12_14.lunch","Obesity.10_12.lunch")))

# FFRL: Fast Food Resaurant list
FFRL<-read.csv("FastFoodResaurantsList.csv")
Add<-data.frame(c("pizza","burger","PIZZERIA"))
colnames(Add)<-"FastFoodResaurant"
FFRL<-rbind(Add,FFRL)
# trim "'"
trim <- function (x) gsub("'", "", x)
# trim all whitespace
trim_space <- function (x) gsub("[[:space:]]", "", x)
FFRL$FastFoodResaurant<-trim_space(FFRL$FastFoodResaurant)
FFRL$FastFoodResaurant<-trim(FFRL$FastFoodResaurant)
# In case of "MC DONALD'S WALMART"
FoodServices$FACILITY.TRIMED<-trim_space(as.character(FoodServices$FACILITY))
FoodServices$FACILITY.TRIMED<-trim(FoodServices$FACILITY.TRIMED)

FASTFOOD<-c()
for (i in FoodServices$FACILITY.TRIMED){
  FFRL_EXIST<-c()
  for (j in FFRL$FastFoodResaurant){
    FFRL_EXIST<-c(FFRL_EXIST,(grepl(j,i,ignore.case = TRUE)))
  }
  #print(FFRL_EXIST)
  #print(length((FFRL_EXIST)))
  FASTFOOD<-c(FASTFOOD,(TRUE %in% FFRL_EXIST))
}

summary(FASTFOOD)
FoodServices$IS.FFR<-FASTFOOD
