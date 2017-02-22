
library(dplyr)
library(spdep)
library(rgdal)

#Independence and right hand side variables
ResidualVsXPlots <- function(mod.in){
  var.names <- names(mod.in$coefficients)
  n.x.vars <- length(var.names)
  mod.e <- residuals(mod.in)
  
  for (i in 2:n.x.vars){
    plot (mod.in$model[,var.names[i]], mod.e, xlab = var.names[i], ylab = "residuals")
    lines(lowess(mod.in$model[,var.names[i]],mod.e, f=3/4), col="red")
    locator(1)
  }
}

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

# Clean rows with Different ID and sort all rows by ID
Clean.Sort <- function(df,poly,kw){
  # Obtain rows with same keyword "kw", which generally is ID
  set.equal <- intersect(poly@data[[kw]], #[[kw]] is equal to data$kw
                         df[[kw]])
  # Clean rows with keyword
  poly.new <- poly[poly@data[[kw]] %in% set.equal,]
  df.new <- df[df[[kw]] %in% set.equal,]
  # Sort all rows by keyword
  poly.new <-poly.new[order(poly.new@data[[kw]]),]
  df.new <- df.new[order(df.new[[kw]]),]
  # Return new polygons and data.frame
  return(list(poly.new=poly.new,df.new=df.new))
}

Draw.boxplot <- function(df,Resid,Main.Title){
  City.L<-df[[Resid]][df$COM.TYPE.CODE==72]
  City.M<-df[[Resid]][df$COM.TYPE.CODE==73]
  City.S<-df[[Resid]][df$COM.TYPE.CODE==74]
  District.L<-df[[Resid]][df$COM.TYPE.CODE==75]
  District.M<-df[[Resid]][df$COM.TYPE.CODE==76]
  District.S<-df[[Resid]][df$COM.TYPE.CODE==77]
  boxplot(City.L,City.M,City.S,District.L,District.M,District.S,
        horizontal=TRUE,
        names=c("Large cities","Medium cities","Small cities","Large central district","Medium central districts","Small central districts"),
        col=c("red1","red2","red3","blue1","blue2","blue3"),
        xlab="Residuals",
        main=Main.Title)
}
Draw.boxplot.2 <- function(df1,df2,Resid,Main.Title){
  Region1.Rel.L<-df1[[Resid]][df1$Logic.AREA.TYPE =="large"]
  Region1.Rel.M<-df1[[Resid]][df1$Logic.AREA.TYPE =="normal"]
  Region1.Rel.S<-df1[[Resid]][df1$Logic.AREA.TYPE =="small"]
  Region2.Rel.L<-df2[[Resid]][df2$Logic.AREA.TYPE =="large"]
  Region2.Rel.M<-df2[[Resid]][df2$Logic.AREA.TYPE =="normal"]
  Region2.Rel.S<-df2[[Resid]][df2$Logic.AREA.TYPE =="small"]
  boxplot(Region1.Rel.L,Region2.Rel.L,
          Region1.Rel.M,Region2.Rel.M,
          Region1.Rel.S,Region2.Rel.S,
          horizontal=TRUE,
          names=c("With.L","Without.L",
                  "With.M","Without.M",
                  "With.S","Without.S"),
          col=c("lightcyan1","darkolivegreen1",
                "lightcyan2","darkolivegreen2",
                "lightcyan3","darkolivegreen3"),
          xlab="Residuals",
          main=Main.Title)
}
Draw.boxplot.3 <- function(df1,df2,Resid,Main.Title){
  Region1.Rel.L<-df1[[Resid]][df1$Logic.RSD =="large"]
  Region1.Rel.M<-df1[[Resid]][df1$Logic.RSD =="normal"]
  Region1.Rel.S<-df1[[Resid]][df1$Logic.RSD =="small"]
  Region2.Rel.L<-df2[[Resid]][df2$Logic.RSD =="large"]
  Region2.Rel.M<-df2[[Resid]][df2$Logic.RSD =="normal"]
  Region2.Rel.S<-df2[[Resid]][df2$Logic.RSD =="small"]
  boxplot(Region1.Rel.L,Region2.Rel.L,
          Region1.Rel.M,Region2.Rel.M,
          Region1.Rel.S,Region2.Rel.S,
          horizontal=TRUE,
          names=c("H.RSD.W","H.RSD.WO",
                  "N.RSD.W","N,RSD.WO",
                  "S.RSD.W","S.RSD.WO"),
          col=c("cyan1","darkseagreen1",
                "cyan2","darkseagreen2",
                "cyan3","darkseagreen3"),
          xlab="Weighted Residuals",
          main=Main.Title)
}
School.Districts.Poly=readOGR(dsn="Shapefile/EventualALL_Project.shp", layer="EventualALL_Project")
School.Districts.Poly <-School.Districts.Poly[order(School.Districts.Poly@data$LOCATION_C),]
Data_12_14<-read.csv("CleanData/Obesity_12_14_cleaned.csv")

Data_12_14$PCT_OBESE <- Data_12_14$PCT_OBESE*100
Data_12_14$PCT_OVERWE <- Data_12_14$PCT_OVERWE*100
Data_12_14$PCT_OVER_1 <- Data_12_14$PCT_OVER_1*100
Data_12_14$PER_FREE_L <- Data_12_14$PER_FREE_L*100
Data_12_14$PER_REDUCE <- Data_12_14$PER_REDUCE*100

Data_12_14$PER_LUNCH<- Data_12_14$PER_FREE_L+ Data_12_14$PER_REDUCE
Data_12_14$SP.FSV.INDEX<-Data_12_14$COUNT.FF/
  (Data_12_14$COUNT.FF+Data_12_14$COUNT.NOT.FF)
Data_12_14$SP.FST.INDEX<-Data_12_14$COUNT.GROCERY/
  (Data_12_14$COUNT.GROCERY+Data_12_14$COUNT.SUP)

Data_12_14.DISTRICT.TOTAL<-Data_12_14[Data_12_14$GRADE_LEVE=="DISTRICT TOTAL",]
Data_12_14.ELEMENTARY<-Data_12_14[Data_12_14$GRADE_LEVE=="ELEMENTARY",]
Data_12_14.MIDDLE.HIGH<-Data_12_14[Data_12_14$GRADE_LEVE=="MIDDLE/HIGH",]

#Data.USING<-Data_12_14.DISTRICT.TOTAL
#Data.USING<-Data_12_14.ELEMENTARY
Data.USING<-Data_12_14.MIDDLE.HIGH

######Part 1 :10_12
  ######Part 1.1: DISTRICT.TOTAL
    ######Part 1.1.1: OBESE


# STEP 0
#build a model
Data.USING$Adj_Dis<-1/sqrt(Data.USING$REL.AREA)
Data.USING$Rev.Size<-1/(Data.USING$AREA.M2.)


base.model.10_12.OB.DISTRICT.TOTAL<-lm(
  PCT_OBESE~
  #PCT_OVER_1~
    FOOD.ENVO.FSV.INDEX+
    FOOD.ENVO.FST.INDEX+
    D.1+D.2+D.3+D.4+D.5
  #+
#    Adj_Dis+
    #PER_FREE_L+PER_REDUCE
    ,
  data = Data.USING
#  ,weights = 1/sqrt(Data.USING$AREA.M2.) 
#  *
#Data.USING$REL.STD.DIS
)

# STEP 1
Data.USING <- RemoveNAs.AddResid(Data.USING,base.model.10_12.OB.DISTRICT.TOTAL,"LOCATION_C",coln="Res.Raw.OB")

# STEP 2
Result <- Clean.Sort(Data.USING,School.Districts.Poly,"LOCATION_C")
School.Districts.Poly_12_14 <- Result$poly.new
Data.USING <- Result$df.new

# STEP 3
# Check whether there is region with no neighbourhood
SDL.NB<-poly2nb(School.Districts.Poly_12_14
                ,row.names=School.Districts.Poly_12_14@data$LOCATION_C)
print(SDL.NB)
# The region whose LOCATION CODE is 580306 has no neighbourhood

# STEP 4
# Delete the one without neighbourhood
Data.USING<-Data.USING[
  !(Data.USING$LOCATION_C==580306),]
School.Districts.Poly_12_14<-School.Districts.Poly_12_14[
  !(School.Districts.Poly_12_14@data$LOCATION_C==580306),]

# STEP 5
SDL.NB<-poly2nb(School.Districts.Poly_12_14
                ,row.names=School.Districts.Poly_12_14@data$LOCATION_C)
print (SDL.NB)

# STEP 6
SDL.listw<-nb2listw(SDL.NB,style="W",zero.policy=NULL)
# After Clean data again, redo the OLS and add residuals
base.model.10_12.OB.DISTRICT.TOTAL<-lm(
  PCT_OBESE~
  #PCT_OVER_1~
    #FOOD.ENVO.FSV.INDEX+
    SP.FSV.INDEX+
    #FOOD.ENVO.FST.INDEX+
    SP.FST.INDEX+
    D.1+D.2+D.3+D.4+D.5
  +
   #REL.STD.DIS+
    #REL.STD.DIS+
    PER_LUNCH
    
    #PER_FREE_L+PER_REDUCE
  ,
  data = Data.USING
  ,weights =
    sqrt(Data.USING$COUNT.STUDENT)
   #*1/(0.5*Data.USING$STD.DIS+0.5*sqrt(Data.USING$AREA.M2.))^2
  #*1/Data.USING$STD.DIS
  *1/(Data.USING$AREA.M2.)
  #*Data.USING$Attractiveness
  )
#Data.USING <- RemoveNAs.AddResid(Data.USING,base.model.10_12.OB.DISTRICT.TOTAL,"LOCATION_C",coln="Res.OLS.OVER")

OB.DISTRICT.TOTAL.moran <- lm.morantest(base.model.10_12.OB.DISTRICT.TOTAL,SDL.listw)
print(OB.DISTRICT.TOTAL.moran)

# STEP 7
summary(base.model.10_12.OB.DISTRICT.TOTAL)

Data_12_14.DISTRICT.TOTAL<-Data.USING
SDL.NB.TOTAL<- SDL.NB
Data_12_14.ELEMENTARY<-Data.USING
SDL.NB.ELE<- SDL.NB
Data_12_14.MIDDLE.HIGH<- Data.USING
SDL.NB.MIDDLE.HIGH<- SDL.NB
#Perform the diagnostic plots
#plot(base.model.10_12.OB.DISTRICT.TOTAL)

#Plot the residuals versus the independent variables
#ResidualVsXPlots(base.model.10_12.OB.DISTRICT.TOTAL)


Result <- Clean.Sort(Data.USING,School.Districts.Poly,"LOCATION_C")
School.Districts.Poly_12_14 <- Result$poly.new
School.Districts.Poly_12_14@data<- Data.USING
Data.USING <- Result$df.new
Data.USING$Weighted.Res<- Data.USING$Res.OLS.OVER_1*(sqrt(Data.USING$COUNT.STUDENT) * 
                                                       1/(Data.USING$AREA.M2.))
Draw.boxplot(Data.USING,"Weighted.Res","Comparsion of 3; Residuals of OLS")

Draw.boxplot.2(df.best, df.raw,"Res.OLS.OB.LATEST","Comparsion of 3; Residuals of OLS")
Draw.boxplot.3(df.best, df.raw,"Res.OLS.OB.LATEST","Comparsion of 3; Residuals of OLS")

# STEP 8
#Boxplots for the categorical variables: different size
Draw.boxplot( df.best ,"Res.OLS.OB.LATEST","Residuals of OLS")
#png(filename="//home//chengxi//Dropbox//Thesis//Thesis//Plots//10_12.DISTRICT_TOTAL_OB_OLS.png",
#    width=600, height=480, units="px")
Data_12_14.OB.DISTRICT.TOTAL.lagrange <- lm.LMtests(base.model.10_12.OB.DISTRICT.TOTAL,SDL.listw,test=c("LMerr","RLMerr","LMlag","RLMlag","SARMA"))
print(Data_12_14.OB.DISTRICT.TOTAL.lagrange)

Data_12_14.OB.DISTRICT.TOTAL.err <- errorsarlm(PCT_OBESE~
    FOOD.ENVO.FSV.INDEX+
    FOOD.ENVO.FST.INDEX+
    D.1+D.2+D.3+D.4+D.5+
      Adj_Dis+
      PER_FREE_L+PER_REDUCE,
    data=Data.USING,SDL.listw)
summary(Data_12_14.OB.DISTRICT.TOTAL.err)

Data.USING <- RemoveNAs.AddResid(Data.USING,Data_12_14.OB.DISTRICT.TOTAL.lag,"LOCATION_C",coln="Res.Lag.OB")
Draw.boxplot(Data.USING,"Res.Lag.OB","Residuals of Lag")
png(filename="//home//chengxi//Dropbox//Thesis//Thesis//Plots//10_12.DISTRICT_TOTAL_OB_Lag.png",
    width=600, height=390, units="px")

Draw.boxplot.3(df.best,df.without3,"Res.OLS.OB.LATEST","Comparsion of RSD")

boxplot(df.best$Res.OLS.OB.LATEST, df.without3$Res.OLS.OB.LATEST,
        horizontal=TRUE,
        names=c("With 3","Without 3"),
        col=c("lightcyan4","lightcyan1"),
        xlab="Residuals",
        main="Comparison of 3")

School.Districts.Poly<- School.Districts.Poly_12_14
School.Districts.Poly<-School.Districts.Poly[School.Districts.Poly@data$LOCATION_C %in% Data.USING$LOCATION_C, ]
colnames(School.Districts.Poly@data)<-gsub("\\.","\\_",colnames(School.Districts.Poly@data))

writeOGR( School.Districts.Poly,dsn="Shapefile", layer="OW_OB_2",driver="ESRI Shapefile" )

