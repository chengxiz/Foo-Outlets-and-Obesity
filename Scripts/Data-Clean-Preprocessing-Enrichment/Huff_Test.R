load("~/Dropbox/Thesis/Thesis/Thesis.Rproj.RData")
library(spatstat)
library(spdep)
library(rgdal)
library(dplyr)
library(Matrix)

# Remove rows with NAs and add Residuals as a new variable
RemoveNAs.AddResid <- function(df,mod.in,coln){
  #Return residuals of FOOD.ENVO.INDEX
  Res<-data.frame(mod.in$residuals)
  colnames(Res)<-coln
  J<-rep(TRUE,nrow(df))
  #Remove the is.na rows and integrae residuals into Data Frame
  J[mod.in$na.action] <- FALSE
  df<- df[J,]
  df<-cbind(df,Res)
  return(df)
}
Huff.model.cal <- function(TYPE.INDEX,NEIGH,SELF,MASS,SCHOOLS,SD.LIST,ramda){
  ALL<-rbind(NEIGH,SELF)
  M.X.Schools = t(apply(as.matrix(SCHOOLS$Location_X),MARGIN=1,function(x) rep(x,nrow(ALL))))
  M.Y.Schools = t(apply(as.matrix(SCHOOLS$Location_Y),MARGIN=1,function(x) rep(x,nrow(ALL))))
  M.X.ALL = apply(as.matrix(ALL$Location_X),MARGIN=1,function(x) rep(x,nrow(SCHOOLS)))
  M.Y.ALL = apply(as.matrix(ALL$Location_Y),MARGIN=1,function(x) rep(x,nrow(SCHOOLS)))
  # Convert from m to km by dividing 1000
  DIS.ALL = sqrt((M.X.Schools - M.X.ALL)^2 + (M.Y.Schools - M.Y.ALL)^2)/1000
  SQ.ALL = apply(as.matrix(ALL[[MASS]]),MARGIN=1,function(x) rep(x,nrow(SCHOOLS)))
  G.ALL<-SQ.ALL* exp((-1*ramda)*DIS.ALL)
  P.ALL<-G.ALL/rowSums(G.ALL)
  # Build a new matrix with j schools and n school districts
  M <- matrix(nrow=nrow(SCHOOLS), ncol=length(SD.LIST))
  colnames(M) <- SD.LIST
  for (j in 1:length(SD.LIST)){
    # Integrate the probabilities of stores within same School districts
    if (is.null(ncol(P.ALL[,ALL$LOCATION_C==SD.LIST[j]]))){
      # In case there is only one school 
      if (nrow(M)==1){
        M[,j]<- sum(P.ALL[,ALL$LOCATION_C==SD.LIST[j]])
      }else{ # in case there is only one store
        M[,j]<- t(P.ALL[,ALL$LOCATION_C==SD.LIST[j]])
      }
    } else{
      M[,j]<- rowSums(P.ALL[,ALL$LOCATION_C==SD.LIST[j]])
    }
  }
  # Set weight matrix based on the # of students from different grades
  WEIGHT.ALL <- (SCHOOLS$X2 + SCHOOLS$X4 + SCHOOLS$X7 + SCHOOLS$X10)/sum(SCHOOLS$X2 + SCHOOLS$X4 + SCHOOLS$X7 + SCHOOLS$X10)
  WEIGHT.ELE <- (SCHOOLS$X2 + SCHOOLS$X4)/sum(SCHOOLS$X2 + SCHOOLS$X4)
  WEIGHT.MID.HI <- (SCHOOLS$X7 + SCHOOLS$X10)/sum(SCHOOLS$X7 + SCHOOLS$X10)
  if (TYPE.INDEX==1){
      M.WEIGHTED <- WEIGHT.ALL %*% M
    } else if (TYPE.INDEX==2){
      M.WEIGHTED <- WEIGHT.ELE %*% M
    } else {
      M.WEIGHTED <- WEIGHT.MID.HI %*% M
    }
  if(is.na(M.WEIGHTED)){
    print("excuse me")
  }
  return(M.WEIGHTED)
}
# i decides the object region
Huff.model.var<- function(TYPE.INDEX,Data,SDL.NB,ramda){
  
  SD.List<-Data$LOCATION_C
  n=nrow(Data)
  M.SD <- Matrix(0, nrow = n, ncol = n, sparse = TRUE)
  colnames(M.SD) <- Data$LOCATION_C
  rownames(M.SD) <- Data$LOCATION_C
  #.SD.ELE <- M.SD.ALL
  #M.SD.MID.HI <- M.SD.ALL
  for (i in 1:length(SD.List)){
    
    Self<-SD.List[i]
    # if (Self==100902|Self==171001|Self==210501){
    #   print("wtf")
    # }
    Neigh.List<-as.numeric(Data$LOCATION_C[SDL.NB[[i]]])
    ALL.List<-c(Neigh.List,Self)
    
    SCHOOLS<-Schools.Pts[Schools.Pts$LOCATION_C %in% Self,]
    # neighbouring food envo 
    NEIGH.FOOD.ENVO<-FST.Pts[FST.Pts$LOCATION_C %in% Neigh.List,]
    # self food envo
    SELF.FOOD.ENVO<-FST.Pts[FST.Pts$LOCATION_C %in% Self,]
    
    #NEIGH<-NEIGH.FOOD.ENVO
    #SELF<-SELF.FOOD.ENVO
    #SD.LIST<-ALL.List
    
    if (!nrow(SCHOOLS)==0){
      MASS.FST="Square_Foo"
      WEIGHTS= Huff.model.cal(TYPE.INDEX,NEIGH.FOOD.ENVO,SELF.FOOD.ENVO,MASS.FST,SCHOOLS,ALL.List,ramda)
      M.SD[as.character(Self),colnames(WEIGHTS)]<-as.numeric(WEIGHTS)      
    } else{
      M.SD[as.character(Self),as.character(Self)]<-1
    }
  }
    
  return(M.SD)  
}

Matrix.Clean<- function(Weight.Matrix,Data){
  # Set Wieight Matrix
  wm<-as.matrix(Weight.Matrix)
  tmp1<-is.na(Data$SP.FST.INDEX)
  Data<-Data[!tmp1,]
  tmp1<-which(tmp1, arr.ind = FALSE, useNames = TRUE)
  tmp2<-is.na(Data$SP.FSV.INDEX)
  Data<-Data[!tmp2,]
  tmp2<-which(tmp2, arr.ind = FALSE, useNames = TRUE)
  n=nrow(Data.USING)
  tmp3<-c(1:n) %in% c(tmp1,tmp2)
  tmp3<-c(1:n)[!tmp3]
  wm<-wm[tmp3,tmp3]
  return(list(wm,Data))
}

Select.Data<- function(TPI){
  if (TPI==1){
    Data.USING<- Data_10_12.DISTRICT.TOTAL
  } else if (TPI==2){
    Data.USING<- Data_10_12.ELEMENTARY
  } else if (TPI==3){
    Data.USING<- Data_10_12.MIDDLE.HIGH
  } else {
    print("errors in type selection")
    break
  }
  # makes sure every school district exists in neighbour list and vice versa
  Data.Poly<- School.Districts.Poly[School.Districts.Poly@data$LOCATION_C %in% Data.USING$LOCATION_C,]
  Data.USING<-Data.USING[Data.USING$LOCATION_C %in% Data.Poly@data$LOCATION_C,]
  SDL.NB<-poly2nb(Data.Poly
                ,row.names=Data.Poly@data$LOCATION_C)
  #print (SDL.NB)
  SDL.NB.USING=SDL.NB
  return(list(TPI,Data.Poly,SDL.NB.USING,Data.USING))
}
# Data.USING<- Data_10_12.DISTRICT.TOTAL
# Data<- School.Districts.Poly[School.Districts.Poly@data$LOCATION_C %in% Data.USING$LOCATION_C,]
# TPI=1
# SDL.NB<-SDL.NB.TOTAL

FST.Pts=readOGR(dsn="../Shapefile/FoodStores_Project_SpatialJo.shp", layer="FoodStores_Project_SpatialJo")@data
#FST=readOGR(dsn="../Shapefile/FoodStores_Project_SpatialJo.shp", layer="FoodStores_Project_SpatialJo")@data

# Set those area is zero to 100
FST.Pts[FST.Pts$Square_Foo==0,]$Square_Foo<-100
Schools.Pts=readOGR(dsn="../Shapefile/Schools_Project_SpatialJoin.shp", layer="Schools_Project_SpatialJoin")@data
Schools.Pts$LOCATION_C<-as.integer(substr(Schools.Pts$SED_CODE,1,(nchar(Schools.Pts$SED_CODE)-12+6)))

Students.Pop=read.csv("../../Original Data/NYSED/BEDS Day Enrollment2012.csv")

colnames(Students.Pop)[1] <- "SED_CODE"
# Extract populations of students in grade 2,4,7,10 
Students.Pop.Avg<-Students.Pop[Students.Pop$YEAR==2012,c(1,2,8,10,13,16)]
# Join by SEDCODE
Schools.Pts<-left_join(Schools.Pts,Students.Pop.Avg,by="SED_CODE")
# Remove school district observations
Schools.Pts<-Schools.Pts[!Schools.Pts$GRADE_LEVE=="DISTRICT TOTAL",]
# Make sure that populations of students in grade 2,4,7,10 are not NAs
Schools.Pts<-Schools.Pts[!is.na(Schools.Pts$X2)&
                           !is.na(Schools.Pts$X4)&
                           !is.na(Schools.Pts$X7)&
                           !is.na(Schools.Pts$X10),]
Schools.Pts<-Schools.Pts[!Schools.Pts$OBJECTID==975,]
Schools.Pts[Schools.Pts$OBJECTID==3188,]$Location_X <- 1800000
Schools.Pts[Schools.Pts$OBJECTID==3189,]$Location_X <- 1800000
Schools.Pts[Schools.Pts$OBJECTID==3188,]$Location_Y <- 2400000
Schools.Pts[Schools.Pts$OBJECTID==3189,]$Location_Y <- 2400000

ptm <- proc.time()
#TPI is TYPE.INDEX
#SDL.NB<-poly2nb(School.Districts.Poly
 #               ,row.names=School.Districts.Poly@data$LOCATION_C)

#Return List R.L
R.L<-Select.Data(1)
Data.USING<-R.L[[4]]







OB.List<-list()
OWOB.List<-list()
Index.List<-c()
for (step in c(seq(0.02,0.08,0.02),seq(0.1,3,0.1),seq(3.2,5,0.2))){
  p<- Huff.model.var(R.L[[1]],R.L[[2]] ,R.L[[3]],step)
  Index.List<-c(Index.List,step)
  print(step)
  print(proc.time() - ptm)
  w.all<-as.matrix(p)
  #summary(rowSums(as.matrix(p[[1]])))

  w.and.Data<- Matrix.Clean(p,Data.USING)
  w.all<-w.and.Data[[1]]
  Data.USING<-w.and.Data[[2]]
  diag.vector<-diag(w.all)

  Data.USING$STAR.SP.FSV.INDEX<- w.all %*% Data.USING$SP.FSV.INDEX
  Data.USING$STAR.SP.FST.INDEX<- w.all %*% Data.USING$SP.FST.INDEX

  # which(is.na(Data.USING$STAR.SP.FST.INDEX))
  Data.USING <- Data.USING[!is.na(Data.USING$STAR.SP.FSV.INDEX)
                           &!is.na(Data.USING$STAR.SP.FST.INDEX),]
  # Iterate from obese to obese+overweight                         
  for (j in 1:2){
    ifelse(
      j==1
      ,
      {
        Model<-lm(
          PCT_OBESE~
          STAR.SP.FSV.INDEX+
          STAR.SP.FST.INDEX+
          # SP.FSV.INDEX+
          # SP.FST.INDEX+
          D.1+D.2+D.3+D.4+D.5+
          PER_LUNCH
          ,
          data = Data.USING
          ,
          weights =
          sqrt(Data.USING$COUNT.STUDENT)
          #*
          #1/(Data.USING$AREA.M2.)
            )
        Name.Suffix <- "OB"
        }
      ,
      {
        Model<-lm(
          PCT_OVER_1~
          STAR.SP.FSV.INDEX+
          STAR.SP.FST.INDEX+
          # SP.FSV.INDEX+
          # SP.FST.INDEX+
          D.1+D.2+D.3+D.4+D.5+
          PER_LUNCH
          ,
          data = Data.USING
          ,
          weights =
          sqrt(Data.USING$COUNT.STUDENT)
          #*
          #1/(Data.USING$AREA.M2.)
          )
        Name.Suffix <- "OWOB"
        }
        )
    Name=paste('Ramda',toString(step),Name.Suffix,sep="_")
    tmp.list<-summary(Model)

    ###Calculate Global Moran's I
    # Remove observations with NAs by regression
    Data.Spautoco <- RemoveNAs.AddResid(Data.USING,Model,coln=Name)
    # Remove corresponding polygons
    Result <- Clean.Sort(Data.Spautoco,R.L[[2]],"LOCATION_C")
    Data.Spautoco <- Result$df.new
    Poly<-Result$poly.new
    SDL.NB<-poly2nb(Poly
                ,row.names=Poly@data$LOCATION_C)
    #print(SDL.NB)
    # Delete the one without neighbourhood
    Data.Spautoco<-Data.Spautoco[!(Data.Spautoco$LOCATION_C==580306|Poly@data$LOCATION_C==490804),]
    Poly<-Poly[!(Poly@data$LOCATION_C==580306|Poly@data$LOCATION_C==490804),]
    SDL.NB<-poly2nb(Poly
                    ,row.names=Poly@data$LOCATION_C)
    #print(SDL.NB)
    SDL.listw<-nb2listw(SDL.NB,style="W",zero.policy=NULL)
    ifelse(
      j==1
      ,
      {
        Model.Spautoco<-lm(
          PCT_OBESE~
          STAR.SP.FSV.INDEX+
          STAR.SP.FST.INDEX+
          # SP.FSV.INDEX+
          # SP.FST.INDEX+
          D.1+D.2+D.3+D.4+D.5+
          PER_LUNCH
          ,
          data = Data.Spautoco
          ,
          weights =
          sqrt(Data.Spautoco$COUNT.STUDENT)
          #*
          #1/(Data.Spautoco$AREA.M2.)
            )
        }
      ,
      {
        Model.Spautoco<-lm(
          PCT_OVER_1~
          STAR.SP.FSV.INDEX+
          STAR.SP.FST.INDEX+
          # SP.FSV.INDEX+
          # SP.FST.INDEX+
          D.1+D.2+D.3+D.4+D.5+
          PER_LUNCH
          ,
          data = Data.Spautoco
          ,
          weights =
          sqrt(Data.Spautoco$COUNT.STUDENT)
          #*
          #1/(Data.Spautoco$AREA.M2.)
          )
        }
        )
    print(lm.morantest(Model.Spautoco,SDL.listw))
    tmp.list[["spautocor"]] <- lm.morantest(Model.Spautoco,SDL.listw)
    tmp.list[["diagonal"]] <- diag.vector
    
    ifelse(
      j==1
      ,
      OB.List[[Name]] <- tmp.list
      ,
      OWOB.List[[Name]] <- tmp.list
      )
    }
    }





