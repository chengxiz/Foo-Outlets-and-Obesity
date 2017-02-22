load("C:/Users/Chengxi/Dropbox/Thesis/Thesis/Huff/Huff.RData")
library(spdep)


# DiagnosticModel <- function (Model){
#   # diagnostic plots
#   layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page
#   plot(Model)
#   Data.USING<-RemoveNAs.AddResid(Data.USING,Model,"LOCATION_C")
#   Data.USING<-Clean.Sort(Data.USING,R.L[[2]],"LOCATION_C")$df.new
#   Poly<-Clean.Sort(Data.USING,R.L[[2]],"LOCATION_C")$poly.new
#   NB<-poly2nb(Poly,row.names=Poly@data$LOCATION_C)
#   print (NB)
#   listw<-nb2listw(NB,style="B",zero.policy=NULL)
#   print(lm.morantest(Model,listw))
#   listw <- as(listw, "symmetricMatrix")
#   #nb_B1 <- mat2listw(as(listw, "dgTMatrix"))
#   temp <- as.matrix(listw)
#   return(temp)
# }

# #Plots
# dev.off()
# layout(matrix(c(1,2),1,2))
# plot(Data.USING$SP.FSV.INDEX,Data.USING$PCT_OBESE,xlab="Food Service Index",ylab="Obesity Rate")
# plot(Data.USING$SP.FSV.INDEX,log(Data.USING$PCT_OBESE),xlab="Food Service Index",ylab="Log Obesity Rate")
# png(filename = paste("FSV_OB","png",sep="."), 640, 480)

# dev.off()
# layout(matrix(c(1,2),1,2))
# plot(Data.USING$SP.FST.INDEX,Data.USING$PCT_OBESE,xlab="Food Store Index",ylab="Obesity Rate")
# plot(Data.USING$SP.FST.INDEX,log(Data.USING$PCT_OBESE),xlab="Food Store Index",ylab="Log Obesity Rate")
# png(filename = paste("FST_OB","png",sep="."), 640, 480)
# # OLS models

# model1 <- lm(PCT_OBESE~
#                #PCT_OVER_1~
#                +SP.FSV.INDEX
#              +SP.FST.INDEX
#              #+D.1+D.2+D.3+D.4+D.5
#              #+PER_LUNCH
#              ,
#              data = Data.USING)
# nb_B1 <- DiagnosticModel(model1)
# png(filename = paste("model1","png",sep="."), 640, 480)

# dev.off()
# model2 <- lm(PCT_OBESE~
#                #PCT_OVER_1~
#                +SP.FSV.INDEX
#              +SP.FST.INDEX
#              #+D.1+D.2+D.3+D.4+D.5
#              +PER_LUNCH
#              ,
#              data = Data.USING)
# nb_B2 <- DiagnosticModel(model2)
# png(filename = paste("model2","png",sep="."), 640, 480)

# dev.off()
# model3 <- lm(PCT_OBESE~
#                #PCT_OVER_1~
#                +SP.FSV.INDEX
#              +SP.FST.INDEX
#              +D.1+D.2+D.3+D.4+D.5
#              +PER_LUNCH
#              ,
#              data = Data.USING)
# nb_B3 <- DiagnosticModel(model3)
# png(filename = paste("model3","png",sep="."), 640, 480)

# #WLS models
# # count of students
# dev.off()
# model4 <- lm(PCT_OBESE~
#                #PCT_OVER_1~
#                +SP.FSV.INDEX
#              +SP.FST.INDEX
#              #+D.1+D.2+D.3+D.4+D.5
#              #+PER_LUNCH
#              ,
#              weight=sqrt(Data.USING$COUNT.STUDENT),
#              data = Data.USING)
# nb_B4 <- DiagnosticModel(model4)
# png(filename = paste("model4","png",sep="."), 640, 480)

# dev.off()
# model5 <- lm(PCT_OBESE~
#                #PCT_OVER_1~
#                +SP.FSV.INDEX
#              +SP.FST.INDEX
#              #+D.1+D.2+D.3+D.4+D.5
#              +PER_LUNCH
#              ,
#              weight=sqrt(Data.USING$COUNT.STUDENT),
#              data = Data.USING)
# nb_B5 <- DiagnosticModel(model5)
# png(filename = paste("model5","png",sep="."), 640, 480)

# dev.off()
# model6 <- lm(PCT_OBESE~
#                #PCT_OVER_1~
#                +SP.FSV.INDEX
#              +SP.FST.INDEX
#              +D.1+D.2+D.3+D.4+D.5
#              +PER_LUNCH
#              ,
#              weight=sqrt(Data.USING$COUNT.STUDENT),
#              data = Data.USING)
# nb_B6 <- DiagnosticModel(model6)
# png(filename = paste("model6","png",sep="."), 640, 480)

# # count of students& area
# dev.off()
# model7 <- lm(PCT_OBESE~
#                #PCT_OVER_1~
#                +SP.FSV.INDEX
#              +SP.FST.INDEX
#              #+D.1+D.2+D.3+D.4+D.5
#              #+PER_LUNCH
#              ,
#              weight=sqrt(Data.USING$COUNT.STUDENT)*(1/(Data.USING$AREA.M2.)),
#              data = Data.USING)
# nb_B7 <- DiagnosticModel(model7)
# png(filename = paste("model7","png",sep="."), 640, 480)

# dev.off()
# model8 <- lm(PCT_OBESE~
#                #PCT_OVER_1~
#                +SP.FSV.INDEX
#              +SP.FST.INDEX
#              #+D.1+D.2+D.3+D.4+D.5
#              +PER_LUNCH
#              ,
#              weight=sqrt(Data.USING$COUNT.STUDENT)*(1/(Data.USING$AREA.M2.)),
#              data = Data.USING)
# nb_B8 <- DiagnosticModel(model8)
# png(filename = paste("model8","png",sep="."), 640, 480)

# dev.off()
# model9 <- lm(PCT_OBESE~
#                #PCT_OVER_1~
#                +SP.FSV.INDEX
#              +SP.FST.INDEX
#              +D.1+D.2+D.3+D.4+D.5
#              +PER_LUNCH
#              ,
#              weight=sqrt(Data.USING$COUNT.STUDENT)*(1/(Data.USING$AREA.M2.)),
#              data = Data.USING)
# nb_B9 <- DiagnosticModel(model9)
# png(filename = paste("model9","png",sep="."), 640, 480)

# dev.off()

# listw<-nb2listw(SDL.NB,style="B",zero.policy=NULL)
# listw <- as(listw, "symmetricMatrix")
# listw <- as.matrix(listw)

# Data.Spautoco$W.SP.FSV.INDEX <- listw %*% Data.Spautoco$SP.FSV.INDEX
# Data.Spautoco$W.SP.FST.INDEX <- listw %*% Data.Spautoco$SP.FST.INDEX

# model10 <- lm(PCT_OBESE~
#                #PCT_OVER_1~
#                 SP.FSV.INDEX
#                +W.SP.FSV.INDEX
#               +SP.FST.INDEX
#               +W.SP.FST.INDEX
#              #+D.1+D.2+D.3+D.4+D.5
#              #+PER_LUNCH
#              ,
#              weight=sqrt(Data.Spautoco$COUNT.STUDENT)*(1/(Data.Spautoco$AREA.M2.)),
#              data = Data.Spautoco)
# listw<-nb2listw(SDL.NB, style="B",zero.policy=NULL)
# print(lm.morantest(model13,listw))

# png(filename = paste("model10","png",sep="."), 640, 480)



# coords <- coordinates(Poly)
# IDs <- row.names(as(Poly, "data.frame"))
# dev.off()
# knn2_nb <- knn2nb(knearneigh(coords, k = 2), row.names = IDs)
# listw<-nb2listw(knn2_nb,style="B",zero.policy=NULL)
# listw <- as(listw, "CsparseMatrix")
# listw <- as.matrix(listw)

# Data.Spautoco$W.SP.FSV.INDEX.knn2 <- listw %*% Data.Spautoco$SP.FSV.INDEX
# Data.Spautoco$W.SP.FST.INDEX.knn2 <- listw %*% Data.Spautoco$SP.FST.INDEX

# model11 <- lm(PCT_OBESE~
#                 #PCT_OVER_1~
#                 SP.FSV.INDEX
#               +W.SP.FSV.INDEX.knn2
#               +SP.FST.INDEX
#               +W.SP.FST.INDEX.knn2
#               #+D.1+D.2+D.3+D.4+D.5
#               #+PER_LUNCH
#               ,
#               weight=sqrt(Data.Spautoco$COUNT.STUDENT)*(1/(Data.Spautoco$AREA.M2.)),
#               data = Data.Spautoco)
# listw<-nb2listw(knn2_nb, style="B",zero.policy=NULL)
# print(lm.morantest(model11,listw))

# dev.off()
# knn4_nb <- knn2nb(knearneigh(coords, k = 4), row.names = IDs)
# listw<-nb2listw(knn4_nb,style="B",zero.policy=NULL)
# listw <- as(listw, "CsparseMatrix")
# listw <- as.matrix(listw)

# Data.Spautoco$W.SP.FSV.INDEX.knn4 <- listw %*% Data.Spautoco$SP.FSV.INDEX
# Data.Spautoco$W.SP.FST.INDEX.knn4 <- listw %*% Data.Spautoco$SP.FST.INDEX

# model12 <- lm(PCT_OBESE~
#                 #PCT_OVER_1~
#                 SP.FSV.INDEX
#               +W.SP.FSV.INDEX.knn4
#               +SP.FST.INDEX
#               +W.SP.FST.INDEX.knn4
#               #+D.1+D.2+D.3+D.4+D.5
#               #+PER_LUNCH
#               ,
#               weight=sqrt(Data.Spautoco$COUNT.STUDENT)*(1/(Data.Spautoco$AREA.M2.)),
#               data = Data.Spautoco)
# listw<-nb2listw(knn4_nb, style="B",zero.policy=NULL)
# print(lm.morantest(model12,listw))

# dev.off()

# listw<-nb2listw(SDL.NB,style="B",zero.policy=NULL)
# listw <- as(listw, "symmetricMatrix")
# listw <- as.matrix(listw)

# Data.Spautoco$W.SP.FSV.INDEX <- listw %*% Data.Spautoco$SP.FSV.INDEX
# Data.Spautoco$W.SP.FST.INDEX <- listw %*% Data.Spautoco$SP.FST.INDEX

# model13 <- lm(PCT_OBESE~
#                #PCT_OVER_1~
#                 SP.FSV.INDEX
#                +W.SP.FSV.INDEX
#               +SP.FST.INDEX
#               +W.SP.FST.INDEX
#              #+D.1+D.2+D.3+D.4+D.5
#              +PER_LUNCH
#              ,
#              weight=sqrt(Data.Spautoco$COUNT.STUDENT)*(1/(Data.Spautoco$AREA.M2.)),
#              data = Data.Spautoco)
# listw<-nb2listw(SDL.NB, style="B",zero.policy=NULL)
# print(lm.morantest(model13,listw))
# png(filename = paste("model10","png",sep="."), 640, 480)

# coords <- coordinates(Poly)

# dev.off()
# knn2_nb <- knn2nb(knearneigh(coords, k = 2), row.names = IDs)
# listw<-nb2listw(knn2_nb,style="B",zero.policy=NULL)
# listw <- as(listw, "CsparseMatrix")
# listw <- as.matrix(listw)

# Data.Spautoco$W.SP.FSV.INDEX.knn2 <- listw %*% Data.Spautoco$SP.FSV.INDEX
# Data.Spautoco$W.SP.FST.INDEX.knn2 <- listw %*% Data.Spautoco$SP.FST.INDEX

# model14 <- lm(PCT_OBESE~
#                 #PCT_OVER_1~
#                 SP.FSV.INDEX
#               +W.SP.FSV.INDEX.knn2
#               +SP.FST.INDEX
#               +W.SP.FST.INDEX.knn2
#               #+D.1+D.2+D.3+D.4+D.5
#               +PER_LUNCH
#               ,
#               weight=sqrt(Data.Spautoco$COUNT.STUDENT)*(1/(Data.Spautoco$AREA.M2.)),
#               data = Data.Spautoco)
# listw<-nb2listw(knn2_nb, style="B",zero.policy=NULL)
# print(lm.morantest(model14,listw))

# dev.off()
# knn4_nb <- knn2nb(knearneigh(coords, k = 4), row.names = IDs)
# listw<-nb2listw(knn4_nb,style="B",zero.policy=NULL)
# listw <- as(listw, "CsparseMatrix")
# listw <- as.matrix(listw)

# Data.Spautoco$W.SP.FSV.INDEX.knn4 <- listw %*% Data.Spautoco$SP.FSV.INDEX
# Data.Spautoco$W.SP.FST.INDEX.knn4 <- listw %*% Data.Spautoco$SP.FST.INDEX

# model15 <- lm(PCT_OBESE~
#                 #PCT_OVER_1~
#                 SP.FSV.INDEX
#               +W.SP.FSV.INDEX.knn4
#               +SP.FST.INDEX
#               +W.SP.FST.INDEX.knn4
#               #+D.1+D.2+D.3+D.4+D.5
#               +PER_LUNCH
#               ,
#               weight=sqrt(Data.Spautoco$COUNT.STUDENT)*(1/(Data.Spautoco$AREA.M2.)),
#               data = Data.Spautoco)
# listw<-nb2listw(knn4_nb, style="B",zero.policy=NULL)
# print(lm.morantest(model15,listw))

# dev.off()

# listw<-nb2listw(SDL.NB,style="B",zero.policy=NULL)
# listw <- as(listw, "symmetricMatrix")
# listw <- as.matrix(listw)

# Data.Spautoco$W.SP.FSV.INDEX <- listw %*% Data.Spautoco$SP.FSV.INDEX
# Data.Spautoco$W.SP.FST.INDEX <- listw %*% Data.Spautoco$SP.FST.INDEX

# model16 <- lm(PCT_OBESE~
#                #PCT_OVER_1~
#                 SP.FSV.INDEX
#                +W.SP.FSV.INDEX
#               +SP.FST.INDEX
#               +W.SP.FST.INDEX
#              +D.1+D.2+D.3+D.4+D.5
#              +PER_LUNCH
#              ,
#              weight=sqrt(Data.Spautoco$COUNT.STUDENT)*(1/(Data.Spautoco$AREA.M2.)),
#              data = Data.Spautoco)
# listw<-nb2listw(SDL.NB, style="B",zero.policy=NULL)
# print(lm.morantest(model16,listw))
# png(filename = paste("model16","png",sep="."), 640, 480)

# coords <- coordinates(Poly)

# dev.off()
# knn2_nb <- knn2nb(knearneigh(coords, k = 2), row.names = IDs)
# listw<-nb2listw(knn2_nb,style="B",zero.policy=NULL)
# listw <- as(listw, "CsparseMatrix")
# listw <- as.matrix(listw)

# Data.Spautoco$W.SP.FSV.INDEX.knn2 <- listw %*% Data.Spautoco$SP.FSV.INDEX
# Data.Spautoco$W.SP.FST.INDEX.knn2 <- listw %*% Data.Spautoco$SP.FST.INDEX

# model17 <- lm(PCT_OBESE~
#                 #PCT_OVER_1~
#                 SP.FSV.INDEX
#               +W.SP.FSV.INDEX.knn2
#               +SP.FST.INDEX
#               +W.SP.FST.INDEX.knn2
#               +D.1+D.2+D.3+D.4+D.5
#               +PER_LUNCH
#               ,
#               weight=sqrt(Data.Spautoco$COUNT.STUDENT)*(1/(Data.Spautoco$AREA.M2.)),
#               data = Data.Spautoco)
# listw<-nb2listw(knn2_nb, style="B",zero.policy=NULL)
# print(lm.morantest(model17,listw))

# dev.off()
# knn4_nb <- knn2nb(knearneigh(coords, k = 4), row.names = IDs)
# listw<-nb2listw(knn4_nb,style="B",zero.policy=NULL)
# listw <- as(listw, "CsparseMatrix")
# listw <- as.matrix(listw)

# Data.Spautoco$W.SP.FSV.INDEX.knn4 <- listw %*% Data.Spautoco$SP.FSV.INDEX
# Data.Spautoco$W.SP.FST.INDEX.knn4 <- listw %*% Data.Spautoco$SP.FST.INDEX

# model18 <- lm(PCT_OBESE~
#                 #PCT_OVER_1~
#                 SP.FSV.INDEX
#               +W.SP.FSV.INDEX.knn4
#               +SP.FST.INDEX
#               +W.SP.FST.INDEX.knn4
#               +D.1+D.2+D.3+D.4+D.5
#               +PER_LUNCH
#               ,
#               weight=sqrt(Data.Spautoco$COUNT.STUDENT)*(1/(Data.Spautoco$AREA.M2.)),
#               data = Data.Spautoco)
# listw<-nb2listw(knn4_nb, style="B",zero.policy=NULL)
# print(lm.morantest(model18,listw))


# p<- Huff.model.var(R.L[[1]],R.L[[2]] ,R.L[[3]],2)
# w.all<-as.matrix(p)
# Data.USING<-R.L[[4]]

# w.and.Data<- Matrix.Clean(p,Data.USING)
# w.all<-w.and.Data[[1]]
# Data.USING<-w.and.Data[[2]]
# Data.USING$STAR.SP.FSV.INDEX<- w.all %*% Data.USING$SP.FSV.INDEX
# Data.USING$STAR.SP.FST.INDEX<- w.all %*% Data.USING$SP.FST.INDEX

# # which(is.na(Data.USING$STAR.SP.FST.INDEX))
# Data.USING <- Data.USING[!is.na(Data.USING$STAR.SP.FSV.INDEX)&!is.na(Data.USING$STAR.SP.FST.INDEX),]
# model21<-lm(
#   PCT_OBESE~
#     STAR.SP.FSV.INDEX+
#     STAR.SP.FST.INDEX
#     # SP.FSV.INDEX+
#     # SP.FST.INDEX+
#     +D.1+D.2+D.3+D.4+D.5
#     +PER_LUNCH
#   ,
#   data = Data.USING
#   ,
#   weights =
#     sqrt(Data.USING$COUNT.STUDENT)
#   *
#   1/(Data.USING$AREA.M2.)
# )
# Data.Spautoco <- RemoveNAs.AddResid(Data.USING,model21,coln=Name)
# # Remove corresponding polygons
# Result <- Clean.Sort(Data.Spautoco,R.L[[2]],"LOCATION_C")
# Data.Spautoco <- Result$df.new
# Poly<-Result$poly.new
# SDL.NB<-poly2nb(Poly
#                 ,row.names=Poly@data$LOCATION_C)
# #print(SDL.NB)
# # Delete the one without neighbourhood
# Data.Spautoco<-Data.Spautoco[!(Data.Spautoco$LOCATION_C==580306|Poly@data$LOCATION_C==490804),]
# Poly<-Poly[!(Poly@data$LOCATION_C==580306|Poly@data$LOCATION_C==490804),]
# SDL.NB<-poly2nb(Poly
#                 ,row.names=Poly@data$LOCATION_C)
# #print(SDL.NB)
# SDL.listw<-nb2listw(SDL.NB,style="W",zero.policy=NULL)
# model19<-lm(
#   PCT_OBESE~
#     STAR.SP.FSV.INDEX+
#     STAR.SP.FST.INDEX
#   # SP.FSV.INDEX+
#   # SP.FST.INDEX+
#   #+D.1+D.2+D.3+D.4+D.5
#   #+PER_LUNCH
#   ,
#   data = Data.Spautoco
#   ,
#   weights =
#     sqrt(Data.Spautoco$COUNT.STUDENT)
#   *
#     1/(Data.Spautoco$AREA.M2.)
# )

# model20<-lm(
#   PCT_OBESE~
#     STAR.SP.FSV.INDEX+
#     STAR.SP.FST.INDEX
#   # SP.FSV.INDEX+
#   # SP.FST.INDEX+
#   #+D.1+D.2+D.3+D.4+D.5
#   +PER_LUNCH
#   ,
#   data = Data.Spautoco
#   ,
#   weights =
#     sqrt(Data.Spautoco$COUNT.STUDENT)
#   *
#     1/(Data.Spautoco$AREA.M2.)
# )

# model21<-lm(
#   PCT_OBESE~
#     STAR.SP.FSV.INDEX+
#     STAR.SP.FST.INDEX
#   # SP.FSV.INDEX+
#   # SP.FST.INDEX+
#   +D.1+D.2+D.3+D.4+D.5
#   +PER_LUNCH
#   ,
#   data = Data.Spautoco
#   ,
#   weights =
#     sqrt(Data.Spautoco$COUNT.STUDENT)
#   *
#     1/(Data.Spautoco$AREA.M2.)
# )

# print(lm.morantest(model19,SDL.listw))
# print(lm.morantest(model20,SDL.listw))
# print(lm.morantest(model21,SDL.listw))

# model22 <- lm(PCT_OBESE~
#                 #PCT_OVER_1~
#                 SP.FSV.INDEX

# #              +SP.FST.INDEX

#               #+D.1+D.2+D.3+D.4+D.5
#               #+PER_LUNCH
#               ,
#               data = Data.Spautoco)
# listw<-nb2listw(SDL.NB, style="B",zero.policy=NULL)
# print(lm.morantest(model22,listw))
# png(filename = paste("model22","png",sep="."), 640, 480)

# model23 <- lm(PCT_OBESE~
#                 #PCT_OVER_1~
#                 SP.FSV.INDEX

# #              +SP.FST.INDEX

#               #+D.1+D.2+D.3+D.4+D.5
#               +PER_LUNCH
#               ,
#               data = Data.Spautoco)
# listw<-nb2listw(SDL.NB, style="B",zero.policy=NULL)
# print(lm.morantest(model23,listw))
# png(filename = paste("model23","png",sep="."), 640, 480)

# model24 <- lm(PCT_OBESE~
#                 #PCT_OVER_1~
#                 SP.FSV.INDEX

# #              +SP.FST.INDEX

#               +D.1+D.2+D.3+D.4+D.5
#               +PER_LUNCH
#               ,
#               data = Data.Spautoco)
# listw<-nb2listw(SDL.NB, style="B",zero.policy=NULL)
# print(lm.morantest(model24,listw))
# png(filename = paste("model24","png",sep="."), 640, 480)

# model25 <- lm(PCT_OBESE~
#                 #PCT_OVER_1~
#                 #SP.FSV.INDEX

#                 SP.FST.INDEX

#               #+D.1+D.2+D.3+D.4+D.5
#               #+PER_LUNCH
#               ,
#               data = Data.Spautoco)
# listw<-nb2listw(SDL.NB, style="B",zero.policy=NULL)
# print(lm.morantest(model25,listw))
# png(filename = paste("model25","png",sep="."), 640, 480)

# model26 <- lm(PCT_OBESE~
#                 #PCT_OVER_1~
#                 #SP.FSV.INDEX

#                SP.FST.INDEX

#               #+D.1+D.2+D.3+D.4+D.5
#               +PER_LUNCH
#               ,
#               data = Data.Spautoco)
# listw<-nb2listw(SDL.NB, style="B",zero.policy=NULL)
# print(lm.morantest(model26,listw))
# png(filename = paste("model26","png",sep="."), 640, 480)

# model27 <- lm(PCT_OBESE~
#                 #PCT_OVER_1~
#                 SP.FSV.INDEX

# #              +SP.FST.INDEX

#               +D.1+D.2+D.3+D.4+D.5
#               +PER_LUNCH
#               ,
#               data = Data.Spautoco)
# listw<-nb2listw(SDL.NB, style="B",zero.policy=NULL)
# print(lm.morantest(model27,listw))
# png(filename = paste("model24","png",sep="."), 640, 480)


#Round1
library(car)
model1_1 <- lm(PCT_OBESE~
               #PCT_OVER_1~
               +SP.FSV.INDEX
             +SP.FST.INDEX
             +D.1+D.2+D.3+D.4+D.5
             +PER_LUNCH
             ,
             data = Data.Spautoco)
#nb_B1 <- DiagnosticModel(model1_1)
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page
plot(model1_1)
print(vif(model1_1))
summary(model1_1)
#Round2

plot(Data.Spautoco$AREA.M2.,sqrt(abs(model1_1$residuals)),xlab="Area of school district",ylab="Square root of absolute residuals")
plot(Data.Spautoco$COUNT.STUDENT,sqrt(abs(model1_1$residuals)),xlab="Number of students",ylab="Square root of absolute residuals")
library(spdep)
nb1<-poly2nb(Poly)
#M <- matrix(0,nrow=nrow(Data.Spautoco), ncol=nrow(Data.Spautoco))
#for (i in 1:nrow(Data.Spautoco)){
 # M[i,nb1[[i]]] <- (1/length(nb1[[i]]))
#  print(M[i,nb1[[i]]])
#}
listw1 <- nb2listw(nb1, style="W",zero.policy=NULL)
print(lm.morantest(model1_1,listw1))
print(lm.LMtests(model1_1, listw1, test=c("LMerr","RLMerr","LMlag","RLMlag","SARMA")))
moran.plot(model1_1$residuals, listw1)

library(ggplot2)
library(maptools)
library(rgeos)
library(dplyr)
PolyPlot <- fortify(Poly, region="LOCATION_C")
residuals <- data.frame(residual=model1_1$residuals,id=as.character(Data.Spautoco$LOCATION_C))
PlotData <- left_join(PolyPlot, residuals)
p <- ggplot() +
  geom_polygon(data = PlotData, aes(x = long, y = lat, group = group,
                                    fill = residual), color = "green", size = 0.25)
#+  coord_map()
setwd("C:/Users/Chengxi/Dropbox/Thesis/Thesis/Huff")
#ggsave(p, file = "map2.png", width = 5, height = 4.5, type = "cairo-png")


model1_2 <- lm(PCT_OBESE~
               #PCT_OVER_1~
               +STAR.SP.FSV.INDEX
             +STAR.SP.FST.INDEX
             +D.1+D.2+D.3+D.4+D.5
             +PER_LUNCH
             ,
             data = Data.Spautoco)
#nb_B1 <- DiagnosticModel(model1_1)
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page
plot(model1_2)
print(vif(model1_2))
summary(model1_2)
plot(Data.Spautoco$AREA.M2.,sqrt(abs(model1_2$residuals)),xlab="Area of school district",ylab="Square root of absolute residuals")
plot(Data.Spautoco$COUNT.STUDENT,sqrt(abs(model1_2$residuals)),xlab="Number of students",ylab="Square root of absolute residuals")
#Round2
print(lm.morantest(model1_2,listw1))
print(lm.LMtests(model1_2, listw1, test=c("LMerr","RLMerr","LMlag","RLMlag","SARMA")))
moran.plot(model1_2$residuals, listw1)

#PolyPlot <- fortify(Poly, region="LOCATION_C")
residuals.W <- data.frame(residual=model1_2$residuals,id=as.character(Data.Spautoco$LOCATION_C))
PlotData.W <- left_join(PolyPlot, residuals.W)
p <- ggplot() +
  geom_polygon(data = PlotData.W, aes(x = long, y = lat, group = group,
                                    fill = residual), color = "green", size = 0.25)
+labs(list(title = "Title", x = "X", y = "Y"))

model1_3 <- lm(PCT_OBESE~
                 #PCT_OVER_1~
                 +SP.FSV.INDEX
               +SP.FST.INDEX
               +D.1+D.2+D.3+D.4+D.5
               +PER_LUNCH
               ,
               weight=COUNT.STUDENT,
               data = Data.Spautoco)
#nb_B1 <- DiagnosticModel(model1_1)
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page
plot(model1_3)
summary(model1_3)
plot(Data.Spautoco$AREA.M2.,sqrt(abs(model1_3$residuals)),xlab="Area of school district",ylab="Square root of absolute residuals")
print(lm.morantest(model1_3,listw1))
print(lm.LMtests(model1_3, listw1, test=c("LMerr","RLMerr","LMlag","RLMlag","SARMA")))
moran.plot(model1_3$residuals, listw1)
residuals.W2 <- data.frame(residual=model1_3$residuals,id=as.character(Data.Spautoco$LOCATION_C))
PlotData.W2 <- left_join(PolyPlot, residuals.W2)
p <- ggplot() +
  geom_polygon(data = PlotData.W2, aes(x = long, y = lat, group = group,
                                      fill = residual), color = "green", size = 0.25)

model1_4 <- lm(PCT_OBESE~
                 #PCT_OVER_1~
                 +STAR.SP.FSV.INDEX
               +STAR.SP.FST.INDEX
               +D.1+D.2+D.3+D.4+D.5
               +PER_LUNCH
               ,
               weight=COUNT.STUDENT,
               data = Data.Spautoco)
#nb_B1 <- DiagnosticModel(model1_1)
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page
plot(model1_4)
dev.off()
summary(model1_4)
plot(Data.Spautoco$AREA.M2.,sqrt(abs(model1_4$residuals)),xlab="Area of school district",ylab="Square root of absolute residuals")
print(lm.morantest(model1_4,listw1))
print(lm.LMtests(model1_4, listw1, test=c("LMerr","RLMerr","LMlag","RLMlag","SARMA")))
moran.plot(model1_4$residuals, listw1)
residuals.W3 <- data.frame(residual=model1_4$residuals,id=as.character(Data.Spautoco$LOCATION_C))
PlotData.W3 <- left_join(PolyPlot, residuals.W3)
p <- ggplot() +
  geom_polygon(data = PlotData.W3, aes(x = long, y = lat, group = group,
                                      fill = residual), color = "green", size = 0.25)

model2_1 <- lm(PCT_OBESE~
                 #PCT_OVER_1~
                 +SP.FSV.INDEX
               +SP.FST.INDEX
               +D.1+D.2+D.3+D.4+D.5
               +PER_LUNCH
               ,
               weight=sqrt(COUNT.STUDENT),
               data = Data.Spautoco)
#nb_B1 <- DiagnosticModel(model1_1)
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page
plot(model2_1)
summary(model2_1)
plot(Data.Spautoco$AREA.M2.,sqrt(abs(model2_1$residuals)),xlab="Area of school district",ylab="Square root of absolute residuals")
print(lm.morantest(model2_1,listw1))
print(lm.LMtests(model2_1, listw1, test=c("LMerr","RLMerr","LMlag","RLMlag","SARMA")))
moran.plot(model2_1$residuals, listw1)
residuals.W4 <- data.frame(residual=model2_1$residuals,id=as.character(Data.Spautoco$LOCATION_C))
PlotData.W4 <- left_join(PolyPlot, residuals.W4)
p <- ggplot() +
  geom_polygon(data = PlotData.W4, aes(x = long, y = lat, group = group,
                                      fill = residual), color = "green", size = 0.25)

model2_2 <- lm(PCT_OBESE~
                 #PCT_OVER_1~
                 +STAR.SP.FSV.INDEX
               +STAR.SP.FST.INDEX
               +D.1+D.2+D.3+D.4+D.5
               +PER_LUNCH
               ,
               weight=sqrt(COUNT.STUDENT),
               data = Data.Spautoco)
#nb_B1 <- DiagnosticModel(model1_1)
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page
plot(model2_2)
dev.off()
summary(model2_2)
plot(Data.Spautoco$AREA.M2.,sqrt(abs(model2_2$residuals)),xlab="Area of school district",ylab="Square root of absolute residuals")
print(lm.morantest(model2_2,listw1))
print(lm.LMtests(model2_2, listw1, test=c("LMerr","RLMerr","LMlag","RLMlag","SARMA")))
moran.plot(model2_2$residuals, listw1)
residuals.W5 <- data.frame(residual=model2_2$residuals,id=as.character(Data.Spautoco$LOCATION_C))
PlotData.W5 <- left_join(PolyPlot, residuals.W5)
p <- ggplot() +
  geom_polygon(data = PlotData.W5, aes(x = long, y = lat, group = group,
                                      fill = residual), color = "green", size = 0.25)


rm(Huff.model.cal)
rm(Huff.model.var)

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
    print(i)
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
Matrix.Clean<- function(Weight.Matrix,Data){
  # Set Wieight Matrix
  wm<-as.matrix(Weight.Matrix)
  tmp1<-is.na(Data$SP.FST.INDEX)
  Data<-Data[!tmp1,]
  tmp1<-which(tmp1, arr.ind = FALSE, useNames = TRUE)
  tmp2<-is.na(Data$SP.FSV.INDEX)
  Data<-Data[!tmp2,]
  tmp2<-which(tmp2, arr.ind = FALSE, useNames = TRUE)
  n=nrow(Data)
  tmp3<-c(1:n) %in% c(tmp1,tmp2)
  tmp3<-c(1:n)[!tmp3]
  wm<-wm[tmp3,tmp3]
  return(list(wm,Data))
}
library(spdep)
Data <- Data.Spautoco
NB <- poly2nb(Poly)
W.1.0<-Huff.model.var(1,Data.Spautoco,NB,1)
w.and.Data<- Matrix.Clean(as.matrix(W.1.0),Data.Spautoco)
W.1.0<-w.and.Data[[1]]
Data.Spautoco$STAR.FSV.INDEX10 <- W.1.0 %*% Data.Spautoco$SP.FSV.INDEX
Data.Spautoco$STAR.FST.INDEX10 <- W.1.0 %*% Data.Spautoco$SP.FST.INDEX

W.3.0<-Huff.model.var(1,Data.Spautoco,NB,3)
w.and.Data<- Matrix.Clean(as.matrix(W.3.0),Data.Spautoco)
W.3.0<-w.and.Data[[1]]
Data.Spautoco$STAR.FSV.INDEX30 <- W.3.0 %*% Data.Spautoco$SP.FSV.INDEX
Data.Spautoco$STAR.FST.INDEX30 <- W.3.0 %*% Data.Spautoco$SP.FST.INDEX

Data.Spautoco$STAR.FSV.INDEX10[is.na(Data.Spautoco$STAR.FSV.INDEX10)]<-Data.Spautoco$SP.FSV.INDEX[is.na(Data.Spautoco$STAR.FSV.INDEX10)]
Data.Spautoco$STAR.FST.INDEX10[is.na(Data.Spautoco$STAR.FST.INDEX10)]<-Data.Spautoco$SP.FST.INDEX[is.na(Data.Spautoco$STAR.FST.INDEX10)]
Data.Spautoco$STAR.FSV.INDEX30[is.na(Data.Spautoco$STAR.FSV.INDEX30)]<-Data.Spautoco$SP.FSV.INDEX[is.na(Data.Spautoco$STAR.FSV.INDEX30)]
Data.Spautoco$STAR.FST.INDEX30[is.na(Data.Spautoco$STAR.FST.INDEX30)]<-Data.Spautoco$SP.FST.INDEX[is.na(Data.Spautoco$STAR.FST.INDEX30)]

model2_3 <- lm(PCT_OBESE~
                 #PCT_OVER_1~
                 +STAR.FSV.INDEX10
               +STAR.FST.INDEX10
               +D.1+D.2+D.3+D.4+D.5
               +PER_LUNCH
               ,
               weight=COUNT.STUDENT,
               data = Data.Spautoco)
#nb_B1 <- DiagnosticModel(model1_1)
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page
plot(model2_3)
dev.off()
summary(model2_3)
plot(Data.Spautoco$AREA.M2.,sqrt(abs(model2_3$residuals)),xlab="Area of school district",ylab="Square root of absolute residuals")
print(lm.morantest(model2_3,listw1))
print(lm.LMtests(model2_3, listw1, test=c("LMerr","RLMerr","LMlag","RLMlag","SARMA")))
moran.plot(model2_3$residuals, listw1)
residuals.W6 <- data.frame(residual=model2_3$residuals,id=as.character(Data.Spautoco$LOCATION_C))
PlotData.W6 <- left_join(PolyPlot, residuals.W6)
p <- ggplot() +
  geom_polygon(data = PlotData.W6, aes(x = long, y = lat, group = group,
                                       fill = residual), color = "green", size = 0.25)



model2_4 <- lm(PCT_OBESE~
                 #PCT_OVER_1~
                 +STAR.FSV.INDEX30
               +STAR.FST.INDEX30
               +D.1+D.2+D.3+D.4+D.5
               +PER_LUNCH
               ,
               weight=sqrt(COUNT.STUDENT),
               data = Data.Spautoco)
#nb_B1 <- DiagnosticModel(model1_1)
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page
plot(model2_4)
dev.off()
summary(model2_4)
plot(Data.Spautoco$AREA.M2.,sqrt(abs(model2_4$residuals)),xlab="Area of school district",ylab="Square root of absolute residuals")
print(lm.morantest(model2_4,listw1))
print(lm.LMtests(model2_4, listw1, test=c("LMerr","RLMerr","LMlag","RLMlag","SARMA")))
moran.plot(model2_4$residuals, listw1)
residuals.W7 <- data.frame(residual=model2_3$residuals,id=as.character(Data.Spautoco$LOCATION_C))
PlotData.W7 <- left_join(PolyPlot, residuals.W7)
p <- ggplot() +
  geom_polygon(data = PlotData.W7, aes(x = long, y = lat, group = group,
                                       fill = residual), color = "green", size = 0.25)

model3_1 <- lm(PCT_OBESE~
                 #PCT_OVER_1~
                 +STAR.SP.FSV.INDEX
               +STAR.SP.FST.INDEX
               +D.1+D.2+D.3+D.4+D.5
               +PER_LUNCH
               ,               
               data = Data.Spautoco)
#nb_B1 <- DiagnosticModel(model1_1)
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page
plot(model3_1)
dev.off()
print(vif(model3_1))
summary(model3_1)
plot(Data.Spautoco$AREA.M2.,sqrt(abs(model3_1$residuals)),xlab="Area of school district",ylab="Square root of absolute residuals")
print(lm.morantest(model3_1,listw1))
print(lm.LMtests(model3_1, listw1, test=c("LMerr","RLMerr","LMlag","RLMlag","SARMA")))
moran.plot(model3_1$residuals, listw1)
residuals.W8 <- data.frame(residual=model3_1$residuals,id=as.character(Data.Spautoco$LOCATION_C))
PlotData.W8 <- left_join(PolyPlot, residuals.W8)
p <- ggplot() +
  geom_polygon(data = PlotData.W8, aes(x = long, y = lat, group = group,
                                      fill = residual), color = "green", size = 0.25)

model3_2 <- lm(PCT_OBESE~
                 #PCT_OVER_1~
                 +STAR.FSV.INDEX30
               +STAR.FST.INDEX30
               +D.1+D.2+D.3+D.4+D.5
               +PER_LUNCH
               ,               
               data = Data.Spautoco)
#nb_B1 <- DiagnosticModel(model1_1)
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page
plot(model3_2)
dev.off()
print(vif(model3_2))
summary(model3_2)
plot(Data.Spautoco$AREA.M2.,sqrt(abs(model3_2$residuals)),xlab="Area of school district",ylab="Square root of absolute residuals")
print(lm.morantest(model3_2,listw1))
print(lm.LMtests(model3_2, listw1, test=c("LMerr","RLMerr","LMlag","RLMlag","SARMA")))
moran.plot(model3_2$residuals, listw1)
residuals.W9 <- data.frame(residual=model3_2$residuals,id=as.character(Data.Spautoco$LOCATION_C))
PlotData.W9 <- left_join(PolyPlot, residuals.W9)
p <- ggplot() +
  geom_polygon(data = PlotData.W9, aes(x = long, y = lat, group = group,
                                      fill = residual), color = "green", size = 0.25)

model3_3 <- lm(PCT_OBESE~
                 #PCT_OVER_1~
                 +STAR.FSV.INDEX10
               +STAR.FST.INDEX10
               +D.1+D.2+D.3+D.4+D.5
               +PER_LUNCH
               ,               
               data = Data.Spautoco)
#nb_B1 <- DiagnosticModel(model1_1)
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page
plot(model3_3)
dev.off()
summary(model3_3)
print(vif(model3_2))
plot(Data.Spautoco$AREA.M2.,sqrt(abs(model3_3$residuals)),xlab="Area of school district",ylab="Square root of absolute residuals")
print(lm.morantest(model3_3,listw1))
print(lm.LMtests(model3_3, listw1, test=c("LMerr","RLMerr","LMlag","RLMlag","SARMA")))
moran.plot(model3_3$residuals, listw1)
residuals.W10 <- data.frame(residual=model3_3$residuals,id=as.character(Data.Spautoco$LOCATION_C))
PlotData.W10 <- left_join(PolyPlot, residuals.W10)
p <- ggplot() +
  geom_polygon(data = PlotData.W10, aes(x = long, y = lat, group = group,
                                      fill = residual), color = "green", size = 0.25)
