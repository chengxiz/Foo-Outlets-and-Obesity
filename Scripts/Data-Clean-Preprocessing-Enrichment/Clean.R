Data_10_12<- Obe_10_12
Data_10_12 <- Data_10_12[Data_10_12$LOCATION_C %in% School.Districts.Poly@data$LOCATION_C,]

Data_10_12.DISTRICT.TOTAL<-Data_10_12[Data_10_12$GRADE_LEVE=="DISTRICT TOTAL",]
Data_10_12.ELEMENTARY<-Data_10_12[Data_10_12$GRADE_LEVE=="ELEMENTARY",]
Data_10_12.MIDDLE.HIGH<-Data_10_12[Data_10_12$GRADE_LEVE=="MIDDLE/HIGH",]

School.Districts.Poly.Clean <- School.Districts.Poly[School.Districts.Poly@data$LOCATION_C %in% Data_10_12.DISTRICT.TOTAL$LOCATION_C,]
SDL.NB<-poly2nb(School.Districts.Poly.Clean,row.names=School.Districts.Poly.Clean@data$LOCATION_C)


