#Data_10_12.DISTRICT.TOTAL$Res.Raw.OB<-NULL
library(dplyr)
Data.Avail <- Data.Spautoco[,c("COUNT.FF",
                            "COUNT.NOT.FF",
                            "COUNT.SUP",
                            "COUNT.GROCERY",
                            "PER_LUNCH",
                            "COUNT.STUDENT",
                            "SP.FSV.INDEX",
                            "SP.FST.INDEX",
                            "AREA.KM2",
                            "COM.TYPE.CODE")
                            ]
write.csv(sapply(Data.Avail,mean, na.rm=TRUE),row.names=colnames(Data.Avail),file="mean.csv")
write.csv(sapply(Data.Avail,sd, na.rm=TRUE),row.names=colnames(Data.Avail),file="sd.csv")
for (i in 72:77){
  write.csv(sapply(filter(Data.Avail,COM.TYPE.CODE==toString(i)),mean, na.rm=TRUE),row.names=colnames(Data.Avail),file=paste(toString(i),"mean.csv"))
  write.csv(sapply(filter(Data.Avail,COM.TYPE.CODE==toString(i)),sd, na.rm=TRUE),row.names=colnames(Data.Avail),file=paste(toString(i),"sd.csv"))
}
