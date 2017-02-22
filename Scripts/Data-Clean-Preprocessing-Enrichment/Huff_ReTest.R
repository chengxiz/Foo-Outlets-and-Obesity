load("C:/Users/Chengxi/Dropbox/Thesis/Thesis/Huff/Final4Models.RData")
library(dplyr)
library(rgdal)
School.Districts.Poly@data<-left_join(School.Districts.Poly@data,Data.Spautoco,by="LOCATION_C")
colnames(School.Districts.Poly@data)<-gsub("\\.","\\",colnames(School.Districts.Poly@data))
School.Districts.Poly@data$STARSPFSVINDEX <- as.numeric(School.Districts.Poly@data$STARSPFSVINDEX)
School.Districts.Poly@data$STARSPFSTINDEX <- as.numeric(School.Districts.Poly@data$STARSPFSVINDEX)
School.Districts.Poly@data$STARFSVINDEX10 <- as.numeric(School.Districts.Poly@data$STARFSVINDEX10)
School.Districts.Poly@data$STARFSTINDEX10 <- as.numeric(School.Districts.Poly@data$STARFSTINDEX10)
School.Districts.Poly@data$STARFSVINDEX30 <- as.numeric(School.Districts.Poly@data$STARFSVINDEX30)
School.Districts.Poly@data$STARFSTINDEX30 <- as.numeric(School.Districts.Poly@data$STARFSTINDEX30)
School.Districts.Poly@data$Area <- NULL

Full <- lm(PCT_OBESE~
                 #PCT_OVER_1~
                 +SP.FSV.INDEX
               +SP.FST.INDEX
               +D.1+D.2+D.3+D.4+D.5
               +PER_LUNCH
               ,
               data = Data.Spautoco)

Model1 <- lm(PCT_OBESE~
               #PCT_OVER_1~
               +STAR.FSV.INDEX10
             +STAR.FST.INDEX10
             +D.1+D.2+D.3+D.4+D.5
             +PER_LUNCH
             ,               
             data = Data.Spautoco)

Model2 <- lm(PCT_OBESE~
               #PCT_OVER_1~
               +STAR.SP.FSV.INDEX
             +STAR.SP.FST.INDEX
             +D.1+D.2+D.3+D.4+D.5
             +PER_LUNCH
             ,               
             data = Data.Spautoco)

Model3 <- lm(PCT_OBESE~
               #PCT_OVER_1~
               +STAR.FSV.INDEX30
             +STAR.FST.INDEX30
             +D.1+D.2+D.3+D.4+D.5
             +PER_LUNCH
             ,               
             data = Data.Spautoco)
Res<-data.frame(LOCATION_C=Data.Spautoco$LOCATION_C,FullRes=Full$residuals,M1Res=Model1$residuals,M2Res=Model2$residuals,M3Res=Model3$residuals)
School.Districts.Poly@data<-left_join(School.Districts.Poly@data,Res,by="LOCATION_C")
writeOGR(School.Districts.Poly,dsn="Shp/Final4.shp", layer="Final4",driver="ESRI Shapefile" )

######
#Full
#Get the predict 
p.Full<-predict.lm(Full,type="response")
#Get the value of all independent variables
m.Full <- model.matrix(~ SP.FSV.INDEX
                  +                   +SP.FST.INDEX
                  +                   +D.1+D.2+D.3+D.4+D.5
                  +                   +PER_LUNCH, Data.Spautoco)[,]
#Get the coefficients
coef.Full <- coef(Full)
#Calculate the predict
RSS.Full <- sum((Data.Spautoco$PCT_OBESE - p.Full)^2)

m.SP.FSV.INDEX <- m.Full[,-2]
coef.SP.FSV.INDEX <- coef.Full[-2]
p.SP.FSV.INDEX <- coef.SP.FSV.INDEX %*% t(m.SP.FSV.INDEX)
RSS.SP.FSV.INDEX <- sum((Data.Spautoco$PCT_OBESE - p.SP.FSV.INDEX)^2)
PRE.SP.FSV.INDEX <- (RSS.SP.FSV.INDEX - RSS.Full)/RSS.SP.FSV.INDEX

m.SP.FST.INDEX <- m.Full[,-3]
coef.SP.FST.INDEX <- coef.Full[-3]
p.SP.FST.INDEX <- coef.SP.FST.INDEX %*% t(m.SP.FST.INDEX)
RSS.SP.FST.INDEX <- sum((Data.Spautoco$PCT_OBESE - p.SP.FST.INDEX)^2)
PRE.SP.FST.INDEX <- (RSS.SP.FST.INDEX - RSS.Full)/RSS.SP.FST.INDEX

m.D.1 <- m.Full[,-4]
coef.D.1 <- coef.Full[-4]
p.D.1 <- coef.D.1 %*% t(m.D.1)
RSS.D.1 <- sum((Data.Spautoco$PCT_OBESE - p.D.1)^2)
PRE.D.1 <- (RSS.D.1 - RSS.Full)/RSS.D.1

m.D.2 <- m.Full[,-5]
coef.D.2 <- coef.Full[-5]
p.D.2 <- coef.D.2 %*% t(m.D.2)
RSS.D.2 <- sum((Data.Spautoco$PCT_OBESE - p.D.2)^2)
PRE.D.2 <- (RSS.D.2 - RSS.Full)/RSS.D.2

m.D.3 <- m.Full[,-6]
coef.D.3 <- coef.Full[-6]
p.D.3 <- coef.D.3 %*% t(m.D.3)
RSS.D.3 <- sum((Data.Spautoco$PCT_OBESE - p.D.3)^2)
PRE.D.3 <- (RSS.D.3 - RSS.Full)/RSS.D.3

m.D.4 <- m.Full[,-7]
coef.D.4 <- coef.Full[-7]
p.D.4 <- coef.D.4 %*% t(m.D.4)
RSS.D.4<- sum((Data.Spautoco$PCT_OBESE - p.D.4)^2)
PRE.D.4<- (RSS.D.4- RSS.Full)/RSS.D.4

m.D.5 <- m.Full[,-8]
coef.D.5 <- coef.Full[-8]
p.D.5 <- coef.D.5 %*% t(m.D.5)
RSS.D.5<- sum((Data.Spautoco$PCT_OBESE - p.D.5)^2)
PRE.D.5<- (RSS.D.5- RSS.Full)/RSS.D.5

m.PER_LUNCH <- m.Full[,-9]
coef.PER_LUNCH <- coef.Full[-9]
p.PER_LUNCH <- coef.PER_LUNCH %*% t(m.PER_LUNCH)
RSS.PER_LUNCH<- sum((Data.Spautoco$PCT_OBESE - p.PER_LUNCH)^2)
PRE.PER_LUNCH<- (RSS.PER_LUNCH- RSS.Full)/RSS.PER_LUNCH

######
#Model1
#Get the predict 
p.Model1<-predict.lm(Model1,type="response")
#Get the value of all independent variables
m.Model1 <- model.matrix(~ STAR.FSV.INDEX10
                  +                   +STAR.FST.INDEX10
                  +                   +D.1+D.2+D.3+D.4+D.5
                  +                   +PER_LUNCH, Data.Spautoco)[,]
#Get the coefficients
coef.Model1 <- coef(Model1)
#Calculate the predict
RSS.Model1 <- sum((Data.Spautoco$PCT_OBESE - p.Model1)^2)

m.STAR.FSV.INDEX10 <- m.Model1[,-2]
coef.STAR.FSV.INDEX10 <- coef.Model1[-2]
p.STAR.FSV.INDEX10 <- coef.STAR.FSV.INDEX10 %*% t(m.STAR.FSV.INDEX10)
RSS.STAR.FSV.INDEX10 <- sum((Data.Spautoco$PCT_OBESE - p.STAR.FSV.INDEX10)^2)
PRE.STAR.FSV.INDEX10 <- (RSS.STAR.FSV.INDEX10 - RSS.Model1)/RSS.STAR.FSV.INDEX10

m.STAR.FST.INDEX10 <- m.Model1[,-3]
coef.STAR.FST.INDEX10 <- coef.Model1[-3]
p.STAR.FST.INDEX10 <- coef.STAR.FST.INDEX10 %*% t(m.STAR.FST.INDEX10)
RSS.STAR.FST.INDEX10 <- sum((Data.Spautoco$PCT_OBESE - p.STAR.FST.INDEX10)^2)
PRE.STAR.FST.INDEX10 <- (RSS.STAR.FST.INDEX10 - RSS.Model1)/RSS.STAR.FST.INDEX10

m.D.1 <- m.Model1[,-4]
coef.D.1 <- coef.Model1[-4]
p.D.1 <- coef.D.1 %*% t(m.D.1)
RSS.D.1 <- sum((Data.Spautoco$PCT_OBESE - p.D.1)^2)
PRE.D.1 <- (RSS.D.1 - RSS.Model1)/RSS.D.1

m.D.2 <- m.Model1[,-5]
coef.D.2 <- coef.Model1[-5]
p.D.2 <- coef.D.2 %*% t(m.D.2)
RSS.D.2 <- sum((Data.Spautoco$PCT_OBESE - p.D.2)^2)
PRE.D.2 <- (RSS.D.2 - RSS.Model1)/RSS.D.2

m.D.3 <- m.Model1[,-6]
coef.D.3 <- coef.Model1[-6]
p.D.3 <- coef.D.3 %*% t(m.D.3)
RSS.D.3 <- sum((Data.Spautoco$PCT_OBESE - p.D.3)^2)
PRE.D.3 <- (RSS.D.3 - RSS.Model1)/RSS.D.3

m.D.4 <- m.Model1[,-7]
coef.D.4 <- coef.Model1[-7]
p.D.4 <- coef.D.4 %*% t(m.D.4)
RSS.D.4<- sum((Data.Spautoco$PCT_OBESE - p.D.4)^2)
PRE.D.4<- (RSS.D.4- RSS.Model1)/RSS.D.4

m.D.5 <- m.Model1[,-8]
coef.D.5 <- coef.Model1[-8]
p.D.5 <- coef.D.5 %*% t(m.D.5)
RSS.D.5<- sum((Data.Spautoco$PCT_OBESE - p.D.5)^2)
PRE.D.5<- (RSS.D.5- RSS.Model1)/RSS.D.5

m.PER_LUNCH <- m.Model1[,-9]
coef.PER_LUNCH <- coef.Model1[-9]
p.PER_LUNCH <- coef.PER_LUNCH %*% t(m.PER_LUNCH)
RSS.PER_LUNCH<- sum((Data.Spautoco$PCT_OBESE - p.PER_LUNCH)^2)
PRE.PER_LUNCH<- (RSS.PER_LUNCH- RSS.Model1)/RSS.PER_LUNCH

######
#Model2
#Get the predict 
p.Model2<-predict.lm(Model2,type="response")
#Get the value of all independent variables
m.Model2 <- model.matrix(~ STAR.SP.FSV.INDEX
                  +                   +STAR.SP.FST.INDEX
                  +                   +D.1+D.2+D.3+D.4+D.5
                  +                   +PER_LUNCH, Data.Spautoco)[,]
#Get the coefficients
coef.Model2 <- coef(Model2)
#Calculate the predict
RSS.Model2 <- sum((Data.Spautoco$PCT_OBESE - p.Model2)^2)

m.STAR.SP.FSV.INDEX <- m.Model2[,-2]
coef.STAR.SP.FSV.INDEX <- coef.Model2[-2]
p.STAR.SP.FSV.INDEX <- coef.STAR.SP.FSV.INDEX %*% t(m.STAR.SP.FSV.INDEX)
RSS.STAR.SP.FSV.INDEX <- sum((Data.Spautoco$PCT_OBESE - p.STAR.SP.FSV.INDEX)^2)
PRE.STAR.SP.FSV.INDEX <- (RSS.STAR.SP.FSV.INDEX - RSS.Model2)/RSS.STAR.SP.FSV.INDEX

m.STAR.SP.FST.INDEX <- m.Model2[,-3]
coef.STAR.SP.FST.INDEX <- coef.Model2[-3]
p.STAR.SP.FST.INDEX <- coef.STAR.SP.FST.INDEX %*% t(m.STAR.SP.FST.INDEX)
RSS.STAR.SP.FST.INDEX <- sum((Data.Spautoco$PCT_OBESE - p.STAR.SP.FST.INDEX)^2)
PRE.STAR.SP.FST.INDEX <- (RSS.STAR.SP.FST.INDEX - RSS.Model2)/RSS.STAR.SP.FST.INDEX

m.D.1 <- m.Model2[,-4]
coef.D.1 <- coef.Model2[-4]
p.D.1 <- coef.D.1 %*% t(m.D.1)
RSS.D.1 <- sum((Data.Spautoco$PCT_OBESE - p.D.1)^2)
PRE.D.1 <- (RSS.D.1 - RSS.Model2)/RSS.D.1

m.D.2 <- m.Model2[,-5]
coef.D.2 <- coef.Model2[-5]
p.D.2 <- coef.D.2 %*% t(m.D.2)
RSS.D.2 <- sum((Data.Spautoco$PCT_OBESE - p.D.2)^2)
PRE.D.2 <- (RSS.D.2 - RSS.Model2)/RSS.D.2

m.D.3 <- m.Model2[,-6]
coef.D.3 <- coef.Model2[-6]
p.D.3 <- coef.D.3 %*% t(m.D.3)
RSS.D.3 <- sum((Data.Spautoco$PCT_OBESE - p.D.3)^2)
PRE.D.3 <- (RSS.D.3 - RSS.Model2)/RSS.D.3

m.D.4 <- m.Model2[,-7]
coef.D.4 <- coef.Model2[-7]
p.D.4 <- coef.D.4 %*% t(m.D.4)
RSS.D.4<- sum((Data.Spautoco$PCT_OBESE - p.D.4)^2)
PRE.D.4<- (RSS.D.4- RSS.Model2)/RSS.D.4

m.D.5 <- m.Model2[,-8]
coef.D.5 <- coef.Model2[-8]
p.D.5 <- coef.D.5 %*% t(m.D.5)
RSS.D.5<- sum((Data.Spautoco$PCT_OBESE - p.D.5)^2)
PRE.D.5<- (RSS.D.5- RSS.Model2)/RSS.D.5

m.PER_LUNCH <- m.Model2[,-9]
coef.PER_LUNCH <- coef.Model2[-9]
p.PER_LUNCH <- coef.PER_LUNCH %*% t(m.PER_LUNCH)
RSS.PER_LUNCH<- sum((Data.Spautoco$PCT_OBESE - p.PER_LUNCH)^2)
PRE.PER_LUNCH<- (RSS.PER_LUNCH- RSS.Model2)/RSS.PER_LUNCH

######
#Model3
#Get the predict 
p.Model3<-predict.lm(Model3,type="response")
#Get the value of all independent variables
m.Model3 <- model.matrix(~ STAR.FSV.INDEX30
                  +                   +STAR.FST.INDEX30
                  +                   +D.1+D.2+D.3+D.4+D.5
                  +                   +PER_LUNCH, Data.Spautoco)[,]
#Get the coefficients
coef.Model3 <- coef(Model3)
#Calculate the predict
RSS.Model3 <- sum((Data.Spautoco$PCT_OBESE - p.Model3)^2)

m.STAR.FSV.INDEX30 <- m.Model3[,-2]
coef.STAR.FSV.INDEX30 <- coef.Model3[-2]
p.STAR.FSV.INDEX30 <- coef.STAR.FSV.INDEX30 %*% t(m.STAR.FSV.INDEX30)
RSS.STAR.FSV.INDEX30 <- sum((Data.Spautoco$PCT_OBESE - p.STAR.FSV.INDEX30)^2)
PRE.STAR.FSV.INDEX30 <- (RSS.STAR.FSV.INDEX30 - RSS.Model3)/RSS.STAR.FSV.INDEX30

m.STAR.FST.INDEX30 <- m.Model3[,-3]
coef.STAR.FST.INDEX30 <- coef.Model3[-3]
p.STAR.FST.INDEX30 <- coef.STAR.FST.INDEX30 %*% t(m.STAR.FST.INDEX30)
RSS.STAR.FST.INDEX30 <- sum((Data.Spautoco$PCT_OBESE - p.STAR.FST.INDEX30)^2)
PRE.STAR.FST.INDEX30 <- (RSS.STAR.FST.INDEX30 - RSS.Model3)/RSS.STAR.FST.INDEX30

m.D.1 <- m.Model3[,-4]
coef.D.1 <- coef.Model3[-4]
p.D.1 <- coef.D.1 %*% t(m.D.1)
RSS.D.1 <- sum((Data.Spautoco$PCT_OBESE - p.D.1)^2)
PRE.D.1 <- (RSS.D.1 - RSS.Model3)/RSS.D.1

m.D.2 <- m.Model3[,-5]
coef.D.2 <- coef.Model3[-5]
p.D.2 <- coef.D.2 %*% t(m.D.2)
RSS.D.2 <- sum((Data.Spautoco$PCT_OBESE - p.D.2)^2)
PRE.D.2 <- (RSS.D.2 - RSS.Model3)/RSS.D.2

m.D.3 <- m.Model3[,-6]
coef.D.3 <- coef.Model3[-6]
p.D.3 <- coef.D.3 %*% t(m.D.3)
RSS.D.3 <- sum((Data.Spautoco$PCT_OBESE - p.D.3)^2)
PRE.D.3 <- (RSS.D.3 - RSS.Model3)/RSS.D.3

m.D.4 <- m.Model3[,-7]
coef.D.4 <- coef.Model3[-7]
p.D.4 <- coef.D.4 %*% t(m.D.4)
RSS.D.4<- sum((Data.Spautoco$PCT_OBESE - p.D.4)^2)
PRE.D.4<- (RSS.D.4- RSS.Model3)/RSS.D.4

m.D.5 <- m.Model3[,-8]
coef.D.5 <- coef.Model3[-8]
p.D.5 <- coef.D.5 %*% t(m.D.5)
RSS.D.5<- sum((Data.Spautoco$PCT_OBESE - p.D.5)^2)
PRE.D.5<- (RSS.D.5- RSS.Model3)/RSS.D.5

m.PER_LUNCH <- m.Model3[,-9]
coef.PER_LUNCH <- coef.Model3[-9]
p.PER_LUNCH <- coef.PER_LUNCH %*% t(m.PER_LUNCH)
RSS.PER_LUNCH<- sum((Data.Spautoco$PCT_OBESE - p.PER_LUNCH)^2)
PRE.PER_LUNCH<- (RSS.PER_LUNCH- RSS.Model3)/RSS.PER_LUNCH