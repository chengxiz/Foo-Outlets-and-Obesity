library(dplyr)
library(rgdal)
library(spdep)
trim_space <- function (x) gsub("[[:space:]]", "", x)
judge_extreme <- function(x,y){
  error<-qnorm(0.975)*sd(x,na.rm=TRUE)/sqrt(length(x))
  left<-mean(x)-error
  right<-mean(x)+error
  r = tryCatch(
    {
      if (y>right) {r<-"large"}
      else if (y<left) {r<-"small"}
      else {r<-"normal"}
      return (r)
    },
    error = function(e) {
      r<-"normal"
      return (r)
      }
  )
  return(r)
}
Categorize <- function (i,REL.AREA,Logic.AREA.TYPE,Logic.RSD,LOCATION_C){
  Neigh.List<-as.numeric(School.Districts.Poly@data$LOCATION_C[SDL.NB[[i]]])
  ID<-School.Districts.Poly@data$LOCATION_C[i]
  Neigh<-filter(tmp, LOCATION_C %in% Neigh.List)
  Neigh.RSD<-unique(Neigh$REL.STD.DIS)
  Neigh.AREA.M2.<-unique(Neigh$AREA.M2.)
  kk3<-judge_extreme(Neigh.RSD,tmp$REL.STD.DIS[3*i-2])
  kk4<-judge_extreme(Neigh.AREA.M2.,tmp$AREA.M2.[3*i-2])
  AREA<-tmp$AREA.M2.[3*i-2]/max(c(Neigh.AREA.M2.,tmp$AREA.M2.[3*i-2]))
  #print(min(Neigh.AREA.M2.))
  REL.AREA<-c(REL.AREA,AREA)
  Logic.AREA.TYPE<-c(Logic.AREA.TYPE,kk4)
  Logic.RSD<-c(Logic.RSD,kk3)
  LOCATION_C<-c(LOCATION_C,ID)
  return (list(Logic.AREA.TYPE=Logic.AREA.TYPE , Logic.RSD=Logic.RSD , LOCATION_C=LOCATION_C, REL.AREA=REL.AREA))
}

# Huff.model<- function(i){
#   Neigh.List<-as.numeric(School.Districts.Poly@data$LOCATION_C[SDL.NB[[i]]])
#   OBJ.LOCATION_C<-tmp$LOCATION_C[3*i-2]
#   Neigh.Self.List<-c(Neigh.List,OBJ.LOCATION_C)
#   LOCAL.FOOD.ENVO<-filter(FST.FSV@data,LOCATION_C %in% Neigh.Self.List)
#   SELF.FOOD.ENVO<-filter(FST.FSV@data,LOCATION_C == OBJ.LOCATION_C)
#   OBJ.LOCATION<-c(unique(SELF.FOOD.ENVO$X_Coordina),unique(SELF.FOOD.ENVO$Y_Coordina))
#   ramda<-2
#   LOCAL.FOOD.ENVO$Dij<-sqrt((LOCAL.FOOD.ENVO$X_Coord_It- OBJ.LOCATION[1])^2+
#                               (LOCAL.FOOD.ENVO$Y_Coord_It- OBJ.LOCATION[2])^2)
#   SELF.FOOD.ENVO$Dij<-sqrt((SELF.FOOD.ENVO$X_Coord_It- OBJ.LOCATION[1])^2+
#                              (SELF.FOOD.ENVO$Y_Coord_It- OBJ.LOCATION[2])^2)
#   SUM.WEIGHT<-sum(LOCAL.FOOD.ENVO$Area * LOCAL.FOOD.ENVO$Dij^(-1*ramda))
#   SELF.WEIGHT<-sum(SELF.FOOD.ENVO$Area * SELF.FOOD.ENVO$Dij^(-1*ramda))
#   Attractiveness<-SELF.WEIGHT/SUM.WEIGHT
#   return(list(Attractiveness=Attractiveness, LOCATION_C=OBJ.LOCATION_C))
# }

All<-read.csv("ALL.csv")
Obe_10_12<-read.csv("Obesity_12_14.csv")
Obe_10_12_trial<-left_join(Obe_10_12,All,by="LOCATION_C")
Obe_10_12_trial$PCT_OVERWE<-as.character(Obe_10_12_trial$PCT_OVERWE)
Obe_10_12_trial$PCT_OVERWE<-as.numeric(gsub("\\%","",Obe_10_12_trial$PCT_OVERWE))/100
Obe_10_12_trial$PCT_OBESE <-as.character(Obe_10_12_trial$PCT_OBESE)
Obe_10_12_trial$PCT_OBESE<-as.numeric(gsub("\\%","",Obe_10_12_trial$PCT_OBESE))/100
Obe_10_12_trial$PCT_OVER_1 <-as.character(Obe_10_12_trial$PCT_OVER_1)
Obe_10_12_trial$PCT_OVER_1<-as.numeric(gsub("\\%","",Obe_10_12_trial$PCT_OVER_1))/100
Obe_10_12_trial$FOOD.ENVO.INDEX<-as.numeric((Obe_10_12_trial$COUNT.FF+Obe_10_12_trial$COUNT.GROCERY)/(Obe_10_12_trial$COUNT.FF+Obe_10_12_trial$COUNT.NOT.FF+Obe_10_12_trial$COUNT.GROCERY+Obe_10_12_trial$COUNT.SUP))
Obe_10_12_trial$PER_FREE_L<-as.numeric(Obe_10_12_trial$PER_FREE_L)
Obe_10_12_trial$PER_REDUCE<-as.numeric(Obe_10_12_trial$PER_REDUCE)

SchoolDir<-read.csv("../../Processed Data/Geocoding Schools 2010-2012/MergedDataTrial.csv")
#View(SchoolDir)
SchoolDir<-SchoolDir[SchoolDir$INST.TYPE.CODE==16,]
colnames(SchoolDir)[1] <- "LOCATION_C"
SchoolDir$LOCATION_C<-as.character(trim_space(SchoolDir$LOCATION_C))
SchoolDir$LOCATION_C<-as.integer(substr(SchoolDir$LOCATION_C,1,(nchar(SchoolDir$LOCATION_C)-12+6)))
keeps<-c("LOCATION_C","COM.TYPE.CODE","COM.TYPE.DESC")
SchoolDir<-SchoolDir[keeps]
tmp<-left_join(Obe_10_12_trial,SchoolDir,by="LOCATION_C")
tmp2<-tmp[is.na(tmp$COM.TYPE.DESC),]
for (i in 538:540){
  tmp$COM.TYPE.CODE[i]=77
  tmp$COM.TYPE.DESC[i]="SMALL CENTRAL DISTRICTS"
}
for (i in 610:615){
  tmp$COM.TYPE.CODE[i]=76
  tmp$COM.TYPE.DESC[i]="MEDIUM CENTRAL DISTRICTS"
  }
for (i in 805:807){
  tmp$COM.TYPE.CODE[i]=77
  tmp$COM.TYPE.DESC[i]="SMALL CENTRAL DISTRICTS"
}
tmp2<-tmp[is.na(tmp$COM.TYPE.DESC),]
# Create Food Environment Food Service Index 
tmp$FOOD.ENVO.FSV.INDEX<-tmp$COUNT.FF/(tmp$COUNT.FF+tmp$COUNT.NOT.FF+tmp$COUNT.GROCERY+tmp$COUNT.SUP)
# Create Food Environment Food Stores Index
tmp$FOOD.ENVO.FST.INDEX<-tmp$COUNT.GROCERY/(tmp$COUNT.FF+tmp$COUNT.NOT.FF+tmp$COUNT.GROCERY+tmp$COUNT.SUP)
# Create Count of student 
tmp$COUNT.STUDENT<-as.integer(tmp$NO__OVER_1/tmp$PCT_OVER_1)
# Create Dummy Variables from D.1 to D.5 and initialize them
# If D1. to D.5 are all equal to 0 ,it is a Small central district
tmp$D.1 <- 0 
tmp$D.2 <- 0 
tmp$D.3 <- 0 
tmp$D.4 <- 0 
tmp$D.5 <- 0 
tmp$D.1[tmp$COM.TYPE.CODE==72] <- 1 # D.1=1 if the school district is a Large cities district; Otherwise the school district is any type of district other than Large cities district
tmp$D.2[tmp$COM.TYPE.CODE==73] <- 1 # ~Medium cities district
tmp$D.3[tmp$COM.TYPE.CODE==74] <- 1 # ~Small cities district
tmp$D.4[tmp$COM.TYPE.CODE==75] <- 1 # ~Large central district
tmp$D.5[tmp$COM.TYPE.CODE==76] <- 1 # ~Medium central district

# FST<-readOGR(dsn="../Shapefile/FoodStores_Project_SpatialJo.shp", layer="FoodStores_Project_SpatialJo")
# FST.UNTRIMMED<-readOGR(dsn="../Shapefile/FoodStores_Project.shp", layer="FoodStores_Project")
# tmp_FST<- left_join(FST@data,FST.UNTRIMMED@data, by="Field1")
# tmp_FST<- tmp_FST[c(colnames(FST@data),"Square_Foo")]
# Area<-c()
# for (i in 1:nrow(tmp_FST)){
#   if (is.na(tmp_FST$Square_Foo[i])||tmp_FST$Square_Foo[i]==0){
#     Area<-c(Area,1000)
#   }
#   else{
#     Area<-c(Area,tmp_FST$Square_Foo[i])
#   }
# }
# tmp_FST$Area<-Area
# keeps3<-c(colnames(FST@data)[1:7],colnames(tmp_FST)[10])
# tmp_FST<- tmp_FST[keeps3]
# FST@data<- tmp_FST
# FSV<-readOGR(dsn="../Shapefile/FoodServices_Project_Spatial.shp", layer="FoodServices_Project_Spatial")
# FSV@data$Area=1000
# FST.FSV<-rbind(FST,FSV)



# FST.FSV<-FST.FSV[order( FST.FSV@data$LOCATION_C ),]

# writeOGR( School.Districts.Poly,dsn="../Shapefile/FSTFSV.shp", layer="Res_Weight_Area",driver="ESRI Shapefile" )

# FST.FSV@data$D.ic.SQR <- (FST.FSV@data$X_Coord_It - FST.FSV@data$X_Coordina)^2 + (FST.FSV@data$Y_Coord_It - FST.FSV@data$Y_Coordina)^2
# tmp2<-FST.FSV@data
# std.dis<-c()
# for (i in 1:nrow(tmp)){
#   tmp3<-filter(tmp2,LOCATION_C==tmp$LOCATION_C[i])
#   #print(tmp$LOCATION_C[i])
#   std.dis<-c(std.dis,sqrt(sum(tmp3$D.ic.SQR)/nrow(tmp3)))
# } 
# tmp$STD.DIS<-std.dis
# tmp$REL.STD.DIS<-tmp$STD.DIS/sqrt(tmp$AREA.M2./pi)



# School.Districts.Poly=readOGR(dsn="../Shapefile/EventualALL.shp", layer="EventualALL")
# School.Districts.Poly <-School.Districts.Poly[order(School.Districts.Poly@data$LOCATION_C),]

# # STEP 5
# SDL.NB<-poly2nb(School.Districts.Poly
#                 ,row.names=School.Districts.Poly@data$LOCATION_C)
# print (SDL.NB)

# # STEP 6
# SDL.listw<-nb2listw(SDL.NB,style="W",zero.policy=NULL)



# list_tmp<-list()
# for (i in 1:nrow(School.Districts.Poly@data)){
#   list_tmp<-Categorize(i,list_tmp$REL.AREA,list_tmp$Logic.AREA.TYPE,list_tmp$Logic.RSD,list_tmp$LOCATION_C)
# }
# tt<-data.frame(Logic.AREA.TYPE=list_tmp$Logic.AREA.TYPE,Logic.RSD=list_tmp$Logic.RSD,LOCATION_C=list_tmp$LOCATION_C, REL.AREA=list_tmp$REL.AREA)
# tmp<- left_join(tmp,tt,by="LOCATION_C")

# Attr.List<-c()
# LOCATION_C.List<-c()
# for (region.i in 1:nrow(School.Districts.Poly@data)){
#   re<- Huff.model(region.i)
#   Attr.List<-c( Attr.List,re$Attractiveness)
#   LOCATION_C.List<-c(LOCATION_C.List,re$LOCATION_C)
# }
# Attr<-data.frame(Attractiveness=Attr.List, LOCATION_C=LOCATION_C.List)
# tmp<- left_join(tmp,Attr,by="LOCATION_C")

Obe_10_12_trial<-tmp

write.csv(Obe_10_12_trial,"Obesity_12_14_cleaned.csv")
Obe_10_12.DISTRICT.TOTAL<-Obe_10_12_trial[Obe_10_12_trial$GRADE_LEVE=="DISTRICT TOTAL",]
Obe_10_12.ELEMENTARY<-Obe_10_12_trial[Obe_10_12_trial$GRADE_LEVE=="ELEMENTARY",]
Obe_10_12.MIDDLE.HIGH<-Obe_10_12_trial[Obe_10_12_trial$GRADE_LEVE=="MIDDLE/HIGH",]

base.model.OW_OB.DISTRICT.TOTAL<-lm(PCT_OVER_1~FOOD.ENVO.INDEX+PER_FREE_L+PER_REDUCE,data = Obe_10_12.DISTRICT.TOTAL)
summary(base.model.OW_OB.DISTRICT.TOTAL)

base.model.OB.ELEMENTARY<-lm(PCT_OBESE~FOOD.ENVO.INDEX+PER_FREE_L+PER_REDUCE,data = Obe_10_12.ELEMENTARY)
summary(base.model.OB.ELEMENTARY)
base.model.OW_OB.ELEMENTARY<-lm(PCT_OVER_1~FOOD.ENVO.INDEX+PER_FREE_L+PER_REDUCE,data = Obe_10_12.ELEMENTARY)
summary(base.model.OW_OB.ELEMENTARY)

base.model.OB.MIDDLE.HIGH<-lm(PCT_OBESE~FOOD.ENVO.INDEX+PER_FREE_L+PER_REDUCE,data = Obe_10_12.MIDDLE.HIGH)
summary(base.model.OB.MIDDLE.HIGH)
base.model.OW_OB.MIDDLE.HIGH<-lm(PCT_OVER_1~FOOD.ENVO.INDEX+PER_FREE_L+PER_REDUCE,data = Obe_10_12.MIDDLE.HIGH)
summary(base.model.OW_OB.MIDDLE.HIGH)


#weights=1/sqrt($StudentsCount)