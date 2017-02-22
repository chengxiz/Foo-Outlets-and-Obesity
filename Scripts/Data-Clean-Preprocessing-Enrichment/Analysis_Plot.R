load("~/Dropbox/Thesis/Thesis/Huff/Data_Got_100.RData")
library(ggplot2)
library(grid)
library(gridExtra)
library(Rmisc)
lambda<-c(seq(0.02,0.08,0.02),seq(0.1,3,0.1),seq(3.2,5,0.2))


PlotStat.with.Beta<- function(List){
  a.r.sq.list<-c()    
  moran.list<-c()
  median.list<-c()
  mean.list<-c()
  for(i in 1:length(List)){
    a.r.sq.list<-c(a.r.sq.list,List[[i]]$adj.r.squared)
    moran.list<-c(moran.list, List[[i]]$spautocor$p.value[[1]])
    median.list<-c(median.list,median(List[[i]]$diagonal[!is.na(List[[i]]$diagonal)]))
    mean.list<-c(mean.list,mean(List[[i]]$diagonal[!is.na(List[[i]]$diagonal)]))
  }
  plot(lambda,a.r.sq.list,main=deparse(substitute(List)),xlab="lambda")
  plot(lambda,moran.list,main=deparse(substitute(List)),xlab="lambda")
  plot(lambda,median.list,main=deparse(substitute(List)),xlab="lambda")
  plot(lambda,mean.list,main=deparse(substitute(List)),xlab="lambda")
  return(data.frame(lambda=lambda,Adj.R.Squared=a.r.sq.list,Global.Moran_s.I=moran.list,Median=median.list,Mean=mean.list))
}
PlotIV.with.Beta<- function(List){
  n <- nrow(List[[1]]$coefficients)
  m <- matrix(0, ncol = 4*(n-1)+1, nrow = length(lambda))
  df<-data.frame(m)
  #Initialize vectors
  for (i in 2:n){
    name=rownames(List[[1]]$coefficients)[i]
    assign(paste(name,"p.value",sep="."),c())     
    assign(paste(name,"est",sep="."),c())     
    assign(paste(name,"upr",sep="."),c())     
    assign(paste(name,"lwr",sep="."),c()) 
  }
  for(j in 1:length(List)){
    # for every independent variable
    for (i in 2:n){
      name=rownames(List[[1]]$coefficients)[i]
      IV.p.value<-c()
      IV.est<-c()
      IV.upr<-c()
      IV.lwr<-c()
      IV.p.value<-c(IV.p.value,List[[j]]$coefficients[i,4])
      IV.est<-c(IV.est,List[[j]]$coefficients[i,1])
      IV.upr<-c(IV.upr,List[[j]]$coefficients[i,1]+2*List[[j]]$coefficients[i,2])
      IV.lwr<-c(IV.lwr,List[[j]]$coefficients[i,1]-2*List[[j]]$coefficients[i,2])
      assign(paste(name,"p.value",sep="."),c(get(paste(name,"p.value",sep=".")),IV.p.value))
      assign(paste(name,"est",sep="."),c(get(paste(name,"est",sep=".")),IV.est))
      assign(paste(name,"upr",sep="."),c(get(paste(name,"upr",sep=".")),IV.upr))
      assign(paste(name,"lwr",sep="."),c(get(paste(name,"lwr",sep=".")),IV.lwr))
    }
  }
  colnamelist<-c()
  for (i in 2:n){
    name=rownames(List[[1]]$coefficients)[i]
    colnamelist<-c(colnamelist,
                   paste(name,"p.value",sep="."),
                   paste(name,"est",sep="."),
                   paste(name,"upr",sep="."),
                   paste(name,"lwr",sep=".")
    )
  }
  colnamelist<-c(colnamelist,"lambda")
  colnames(df) <- colnamelist
  for (i in 2:n){
    name=rownames(List[[1]]$coefficients)[i]
    df[[paste(name,"p.value",sep=".")]] <- get(paste(name,"p.value",sep="."))
    df[[paste(name,"est",sep=".")]] <- get(paste(name,"est",sep="."))
    df[[paste(name,"upr",sep=".")]] <- get(paste(name,"upr",sep="."))
    df[[paste(name,"lwr",sep=".")]] <- get(paste(name,"lwr",sep="."))   
  }   
  df[["lambda"]] <- lambda
  return(df)
}


Plot.IV <- function(Summary,est,lwr,upr,xlabn,ylabn,ylim.min,ylim.max,plot.title){
  base_size=12
  # create plot object with loess regression lines
  g.upr.lwr <- ggplot(data=Summary, aes(x=lambda))+ 
    stat_smooth(aes_string(y = est), method = "loess", se = FALSE, colour = NA) +
    stat_smooth(aes_string(y = lwr), method = "loess", se = FALSE, colour = NA) +
    stat_smooth(aes_string(y = upr), method = "loess", se = FALSE, colour = NA)
  # geom_smooth(method="loess",aes_string(y = est)) +
  # geom_ribbon(aes_string(ymin = lwr),aes_string(ymax = upr),fill = "grey", alpha = 0.4)
  
  # build plot object for rendering 
  g.u.l <- ggplot_build(g.upr.lwr)
  
  # extract data for the loess lines from the 'data' slot
  df.u.l<- data.frame(x = g.u.l $data[[1]]$x,
                      yest = g.u.l $data[[1]]$y,
                      ymin = g.u.l $data[[2]]$y,
                      ymax = g.u.l $data[[3]]$y) 
  
  
  # use the loess data to add the 'ribbon' to plot 
  g.upr.lwr <-
  	g.upr.lwr +
    ylim(ylim.min,ylim.max) + 
    geom_hline(data = df.u.l,aes(x = x, y =0),colour = "red", linetype = "longdash") +
    geom_vline(xintercept = 3.8,colour = "red", linetype = "longdash") +
    geom_vline(xintercept = 4.2,colour = "red", linetype = "longdash") +
    geom_line(data = df.u.l,aes(x = x, y =yest)) +
    geom_ribbon(data = df.u.l, aes(x = x, ymin = ymin, ymax = ymax),
                fill = "grey", alpha = 0.4) +
    #coord_fixed(ratio = 5) +
    #labs(x=xlabn, y=ylabn) +
    labs(x=xlabn, y=ylabn, title=plot.title) +
    theme(
      axis.line =         element_line(colour = "gray70", size = 0.5),
      axis.text.x =       element_text(size = base_size * 1.2 , lineheight = 0.9, colour = "black", vjust = 1),
      axis.text.y =       element_text(size = base_size * 1.2 , lineheight = 0.9, colour = "black", hjust = 1),
      axis.ticks =        element_line(colour = "black"),
      axis.title.x =      element_text(size = base_size *1.2 , vjust = 0.5, hjust= 0.5),
      axis.title.y =      element_text(size = base_size *1.2 , angle = 90, vjust = 0.5),
      axis.ticks.length = unit(0.15, "cm"),
      axis.ticks.margin = unit(0.1, "cm"),

      plot.title = element_text(hjust = -0.15,vjust = 1, face = "bold"),
      
      panel.background = element_rect(fill = "white", colour = NA), 
      panel.border =     element_rect(fill = NA, colour = "grey50"), 
      panel.grid= element_line(colour = "grey98", size = 0.5), 
      panel.margin =  unit(0.25, "lines")
    )
    return(g.upr.lwr)
}
Plot.P.VALUE <- function(Summary, FSV, FST, G.Morans.I, ylim.min,ylim.max){
  base_size=12
  g.p.value <- ggplot(data=Summary, aes(x=lambda))+
    #geom_line(aes(y = 0.05),colour = "red", linetype = "longdash") +
    geom_line(aes_string(y = FSV)) +
    geom_line(aes(colour = "FSV", size=1)) +
    geom_line(aes_string(y = FST)) +  
    geom_line(aes(colour = "FST", size=1)) +
    # geom_line(data = df.p.v,aes(x = x, y =y3)) +
    # geom_line(data = df.p.v,aes(x = x, y =y4)) +
    # geom_line(data = df.p.v,aes(x = x, y =y5)) +
    # geom_line(data = df.p.v,aes(x = x, y =y6)) +
    # geom_line(data = df.p.v,aes(x = x, y =y7)) +
    geom_line(aes_string(y = G.Morans.I)) +
    geom_line(aes(colour = "FST", size=1)) +
    scale_colour_manual("", 
                        breaks = c("FSV", "FST", "G.Morans.I"),
                        values = c("red", "green", "blue"))+
    #ylim(ylim.min,ylim.max) + 
    xlab(" ") +
    #scale_y_continuous("p-value", breaks=c(0,0.05,0.2,0.4,0.6)) + 
    labs(title="p-value changes with distance decay parameter")+
    #labs(x=xlabn, y=ylabn) +
    theme(
      axis.line =         element_line(colour = "gray70", size = 0.5),
      axis.text.x =       element_text(size = base_size * 0.8 , lineheight = 0.9, colour = "black", vjust = 1),
      axis.text.y =       element_text(size = base_size * 0.8, lineheight = 0.9, colour = "black", hjust = 1),
      axis.ticks =        element_line(colour = "black"),
      axis.title.x =      element_text(size = base_size, vjust = 0.5),
      axis.title.y =      element_text(size = base_size, angle = 90, vjust = 0.5),
      axis.ticks.length = unit(0.15, "cm"),
      axis.ticks.margin = unit(0.1, "cm"),
      
      panel.background = element_rect(fill = "white", colour = NA), 
      panel.border =     element_rect(fill = NA, colour = "grey50"), 
      panel.grid= element_line(colour = "grey98", size = 0.5), 
      panel.margin =  unit(0.25, "lines")
    )
  g.p.value
}
OB.IV.Summary<-PlotIV.with.Beta(OB.List)
OWOB.IV.Summary<-PlotIV.with.Beta(OWOB.List)
OB.Stat.Summary<-PlotStat.with.Beta(OB.List)
OWOB.Stat.Summary<-PlotStat.with.Beta(OWOB.List)

OB.IV.Summary$Moran.I <- OB.Stat.Summary$Global.Moran_s.I
OWOB.IV.Summary$Moran.I <- OWOB.Stat.Summary$Global.Moran_s.I

n = length(OB.IV.Summary$lambda)
OB.SA <- data.frame(
  IV.name = factor(c(rep("FSVEI",n),rep("FSTEI",n),rep("Global Moran's I",n))),
  p.value = c( OB.IV.Summary$STAR.SP.FSV.INDEX.p.value, OB.IV.Summary$STAR.SP.FST.INDEX.p.value, OB.IV.Summary$Moran.I),
  lambda = rep(OB.IV.Summary$lambda, 3)
)

#Plot.P.VALUE <- function(Summary, IV.1, IV.2, IV.3, IV.4, IV.5, IV.6, IV.7, G.Morans.I
png(filename = "FSV.png", width = 600, height = 225, units = "px")
OB.FSV <- Plot.IV(OB.IV.Summary,
        "STAR.SP.FSV.INDEX.est",
        "STAR.SP.FSV.INDEX.lwr",
        "STAR.SP.FSV.INDEX.upr",
        "Distance Deacy Parameter",
        "Estimate of FSVEI",
        -0.1,
        0.5,
        "a"
)
OWOB.FSV <- Plot.IV(OWOB.IV.Summary,
        "STAR.SP.FSV.INDEX.est",
        "STAR.SP.FSV.INDEX.lwr",
        "STAR.SP.FSV.INDEX.upr",
        "Distance Deacy Parameter",
        "Estimate of FSVEI",
        -0.1,
        0.5,
        "b"
)
multiplot(OB.FSV, OWOB.FSV, cols=2)
dev.off()
#Plot.P.VALUE(OB.IV.Summary,
 #            "STAR.SP.FSV.INDEX.p.value",
 #           "STAR.SP.FST.INDEX.p.value",
 #            "Moran.I",
 #             0,
 #            0.6
#)
png(filename = "FST.png", width = 600, height = 225, units = "px")
OB.FST <- Plot.IV(OB.IV.Summary,
        "STAR.SP.FST.INDEX.est",
        "STAR.SP.FST.INDEX.lwr",
        "STAR.SP.FST.INDEX.upr",
        "Distance Deacy Parameter",
        "Estimate of FSTEI",
        -0.1,
        0.5,
        "a"
)
OWOB.FST <- Plot.IV(OWOB.IV.Summary,
        "STAR.SP.FST.INDEX.est",
        "STAR.SP.FST.INDEX.lwr",
        "STAR.SP.FST.INDEX.upr",
        "Distance Deacy Parameter",
        "Estimate of FSTEI",
        -0.1,
        0.5,
        "b"
)
multiplot(OB.FST, OWOB.FST, cols=2)
dev.off()

png(filename = "D1.png", width = 600, height = 225, units = "px")
OB.D1 <- Plot.IV(OB.IV.Summary,
        "D.1.est",
        "D.1.lwr",
        "D.1.upr",
        "Distance Deacy Parameter",
        "Estimate of D1",
        -20,
        5,
        "a"
)
OWOB.D1 <- Plot.IV(OWOB.IV.Summary,
        "D.1.est",
        "D.1.lwr",
        "D.1.upr",
        "Distance Deacy Parameter",
        "Estimate of D1",
        -20,
        5,
        "b"
)
multiplot(OB.D1, OWOB.D1, cols=2)
dev.off()

png(filename = "D2.png", width = 600, height = 225, units = "px")
OB.D2 <- Plot.IV(OB.IV.Summary,
        "D.2.est",
        "D.2.lwr",
        "D.2.upr",
        "Distance Deacy Parameter",
        "Estimate of D2",
        -20,
        5,
        "a"
)
OWOB.D2 <- Plot.IV(OWOB.IV.Summary,
        "D.2.est",
        "D.2.lwr",
        "D.2.upr",
        "Distance Deacy Parameter",
        "Estimate of D2",
        -20,
        5,
        "b"
)
multiplot(OB.D2, OWOB.D2, cols=2)
dev.off()

png(filename = "D3.png", width = 600, height = 225, units = "px")
OB.D3 <- Plot.IV(OB.IV.Summary,
        "D.3.est",
        "D.3.lwr",
        "D.3.upr",
        "Distance Deacy Parameter",
        "Estimate of D3",
        -20,
        5,
        "a"
)
OWOB.D3 <- Plot.IV(OWOB.IV.Summary,
        "D.3.est",
        "D.3.lwr",
        "D.3.upr",
        "Distance Deacy Parameter",
        "Estimate of D3",
        -20,
        5,
        "b"
)
multiplot(OB.D3, OWOB.D3, cols=2)
dev.off()

png(filename = "D4.png", width = 600, height = 225, units = "px")
OB.D4 <- Plot.IV(OB.IV.Summary,
        "D.4.est",
        "D.4.lwr",
        "D.4.upr",
        "Distance Deacy Parameter",
        "Estimate of D4",
        -20,
        5,
        "a"
)
OWOB.D4 <- Plot.IV(OWOB.IV.Summary,
        "D.4.est",
        "D.4.lwr",
        "D.4.upr",
        "Distance Deacy Parameter",
        "Estimate of D4",
        -20,
        5,
        "b"
)
multiplot(OB.D4, OWOB.D4, cols=2)
dev.off()

png(filename = "D5.png", width = 600, height = 225, units = "px")
OB.D5 <- Plot.IV(OB.IV.Summary,
        "D.5.est",
        "D.5.lwr",
        "D.5.upr",
        "Distance Deacy Parameter",
        "Estimate of D5",
        -20,
        5,
        "a"
)
OWOB.D5 <- Plot.IV(OWOB.IV.Summary,
        "D.5.est",
        "D.5.lwr",
        "D.5.upr",
        "Distance Deacy Parameter",
        "Estimate of D5",
        -20,
        5,
        "b"
)
multiplot(OB.D5, OWOB.D5, cols=2)
dev.off()

png(filename = "Lunch.png", width = 600, height = 225, units = "px")
OB.Lunch <- Plot.IV(OB.IV.Summary,
        "PER_LUNCH.est",
        "PER_LUNCH.lwr",
        "PER_LUNCH.upr",
        "Distance Deacy Parameter",
        "Estimate of Lunch Index",
        0,
        0.6,
        "a"
)
OWOB.Lunch <- Plot.IV(OB.IV.Summary,
        "PER_LUNCH.est",
        "PER_LUNCH.lwr",
        "PER_LUNCH.upr",
        "Distance Deacy Parameter",
        "Estimate of Lunch Index",
        0,
        0.6,
        "b"
)
multiplot(OB.Lunch, OWOB.Lunch, cols=2)
dev.off()


# Residuals.Matrix<-function(List){
#   R.M<-c()
#   for (i in 1:length(List)){
#     R.M<-rbind(R.M,List[[i]]$residuals)
#   }
#   return(R.M)
# }
# OB.RM <- Residuals.Matrix(OB.List)
# OWOB.RM <- Residuals.Matrix(OWOB.List)
# R.summary <- function(Matrix){
#   R.MEAN.List<-c()
#   R.MEDIAN.List<-c()
#   R.MAX.List<-c()
#   R.MIN.List<-c()
#   R.VAR.List<-c()
#   for (i in 1: ncol(Matrix)){
#     R.MEAN.List<-c(R.MEAN.List,mean(Matrix[,i]))
#     R.MEDIAN.List<-c(R.MEAN.List,median(Matrix[,i]))
#     R.MAX.List<-c(R.MEAN.List,max(Matrix[,i]))
#     R.MIN.List<-c(R.MEAN.List,min(Matrix[,i]))
#     R.VAR.List<-c(R.MEAN.List,var(Matrix[,i]))
#   }
#   return(list(R.MEAN.List,R.MEDIAN.List,R.MAX.List,R.MIN.List,R.VAR.List))
# }
# OB.R<-R.summary(OB.RM)
png(filename = "p_value.png", width = 600, height = 600, units = "px")
base_size=12
OB.p.value <- ggplot(data = OB.IV.Summary, aes(x = lambda)) +
  geom_line(aes(y = 0.05),colour = "red", linetype = "longdash") +
  geom_vline(xintercept = 3.8,colour = "red", linetype = "longdash") +
  geom_vline(xintercept = 4.2,colour = "red", linetype = "longdash") +
  geom_line(aes(y = STAR.SP.FSV.INDEX.p.value, colour = "FSVEI")) +
  geom_line(aes(y = STAR.SP.FST.INDEX.p.value, colour = "FSTEI")) +
  geom_line(aes(y = Moran.I, colour = "Moran's I")) +
  coord_cartesian(ylim = c(0,1)) +
  scale_colour_manual("", 
                      breaks = c("FSVEI", "FSTEI", "Moran's I"),
                      values = c("tomato", "green", "blue")) +

  xlab(" ") +
  scale_y_continuous("p-value", breaks=c(0,0.05,0.2,0.4,0.6,0.8,1)) + 
  labs(x="Distance decay parameter" , title="a")+
  theme(
    axis.line =         element_line(colour = "gray70", size = 0.5),
    axis.text.x =       element_text(size = base_size *1.2 , lineheight = 0.9, colour = "black", vjust = 1),
    axis.text.y =       element_text(size = base_size *1.2, lineheight = 0.9, colour = "black", hjust = 1),
    axis.ticks =        element_line(colour = "black"),
    title =		element_text(size = base_size *1.2),    
    axis.title.x =      element_text(size = base_size *1.2, vjust = 0.5),
    axis.title.y =      element_text(size = base_size *1.2, angle = 90, vjust = 0.5),
    axis.ticks.length = unit(0.15, "cm"),
    axis.ticks.margin = unit(0.1, "cm"),
	legend.text = 		element_text(size = base_size * 1.5 ),

    plot.title = element_text(hjust = -0.05,vjust = 1, face = "bold"),
    
    panel.background = element_rect(fill = "white", colour = NA), 
    panel.border =     element_rect(fill = NA, colour = "grey50"), 
    panel.grid= element_line(colour = "grey98", size = 0.5), 
    panel.margin =  unit(0.25, "lines")
  )

base_size=12
OWOB.p.value <- ggplot(data = OWOB.IV.Summary, aes(x = lambda)) +
  geom_line(aes(y = 0.05),colour = "red", linetype = "longdash") +
  geom_vline(xintercept = 3.8,colour = "red", linetype = "longdash") +
  geom_vline(xintercept = 4.2,colour = "red", linetype = "longdash") +
  geom_line(aes(y = STAR.SP.FSV.INDEX.p.value, colour = "FSVEI")) +
  geom_line(aes(y = STAR.SP.FST.INDEX.p.value, colour = "FSTEI")) +
  geom_line(aes(y = Moran.I, colour = "Moran's I")) +
  scale_colour_manual("", 
                      breaks = c("FSVEI", "FSTEI", "Moran's I"),
                      values = c("tomato", "green", "blue")) +
  coord_cartesian(ylim = c(0,1)) +
  xlab(" ") +
  scale_y_continuous("p-value", breaks=c(0,0.05,0.2,0.4,0.6,0.8,1)) +

  labs(x="Distance decay parameter" , title="b")+
  theme(
    axis.line =         element_line(colour = "gray70", size = 0.5),
    axis.text.x =       element_text(size = base_size *1.2 , lineheight = 0.9, colour = "black", vjust = 1),
    axis.text.y =       element_text(size = base_size *1.2, lineheight = 0.9, colour = "black", hjust = 1),
    axis.ticks =        element_line(colour = "black"),
    title =		element_text(size = base_size *1.2),    
    axis.title.x =      element_text(size = base_size *1.2, vjust = 0.5),
    axis.title.y =      element_text(size = base_size *1.2, angle = 90, vjust = 0.5),
    axis.ticks.length = unit(0.15, "cm"),
    axis.ticks.margin = unit(0.1, "cm"),
	legend.text = 		element_text(size = base_size * 1.5 ),
    plot.title = element_text(hjust = -0.05,vjust = 2.5, face = "bold"),
    
    panel.background = element_rect(fill = "white", colour = NA), 
    panel.border =     element_rect(fill = NA, colour = "grey50"), 
    panel.grid= element_line(colour = "grey98", size = 0.5), 
    panel.margin =  unit(0.25, "lines")
  )
multiplot(OB.p.value, OWOB.p.value, cols=1)
dev.off()

png(filename = "adj_r.png", width = 600, height = 225, units = "px")
base_size=12
OB.adj.r <- ggplot(data = OB.Stat.Summary, aes(x = lambda)) + 
  geom_vline(xintercept = 3.8,colour = "red", linetype = "longdash") +
  geom_vline(xintercept = 4.2,colour = "red", linetype = "longdash") +
  geom_line(aes(y = Adj.R.Squared)) +  
  ylim(0.6,0.65) +
  xlab(" ") +
  ylab("Adjusted R-Squared") + 
  labs(x="Distance decay parameter" , title="a")+
  theme(
    axis.line =         element_line(colour = "gray70", size = 0.5),
    axis.text.x =       element_text(size = base_size *1.2 , lineheight = 0.9, colour = "black", vjust = 1),
    axis.text.y =       element_text(size = base_size *1.2, lineheight = 0.9, colour = "black", hjust = 1),
    axis.ticks =        element_line(colour = "black"),
    axis.title.x =      element_text(size = base_size *1.2, vjust = 0.5),
    axis.title.y =      element_text(size = base_size *1.2, angle = 90, vjust = 0.5),
    axis.ticks.length = unit(0.15, "cm"),
    axis.ticks.margin = unit(0.1, "cm"),
    
    plot.title = element_text(hjust = -0.15,vjust = 1, face = "bold"),

    panel.background = element_rect(fill = "white", colour = NA), 
    panel.border =     element_rect(fill = NA, colour = "grey50"), 
    panel.grid= element_line(colour = "grey98", size = 0.5), 
    panel.margin =  unit(0.25, "lines")
  )

base_size=12
OWOB.adj.r <- ggplot(data = OWOB.Stat.Summary, aes(x = lambda)) +
  geom_vline(xintercept = 3.8,colour = "red", linetype = "longdash") +
  geom_vline(xintercept = 4.2,colour = "red", linetype = "longdash") +
  geom_line(aes(y = Adj.R.Squared)) +  
  ylim(0.6,0.65) +
  xlab(" ") +
  ylab("Adjusted R-Squared") + 
  labs(x="Distance decay parameter" , title="b")+
  theme(
    axis.line =         element_line(colour = "gray70", size = 0.5),
    axis.text.x =       element_text(size = base_size *1.2 , lineheight = 0.9, colour = "black", vjust = 1),
    axis.text.y =       element_text(size = base_size *1.2, lineheight = 0.9, colour = "black", hjust = 1),
    axis.ticks =        element_line(colour = "black"),
    axis.title.x =      element_text(size = base_size *1.2, vjust = 0.5),
    axis.title.y =      element_text(size = base_size *1.2, angle = 90, vjust = 0.5),
    axis.ticks.length = unit(0.15, "cm"),
    axis.ticks.margin = unit(0.1, "cm"),
    legend.text = 		element_text(size = base_size * 1.5 ),

    plot.title = element_text(hjust = -0.15,vjust = 1, face = "bold"),    
    
    panel.background = element_rect(fill = "white", colour = NA), 
    panel.border =     element_rect(fill = NA, colour = "grey50"), 
    panel.grid= element_line(colour = "grey98", size = 0.5), 
    panel.margin =  unit(0.25, "lines")
  )
multiplot(OB.adj.r, OWOB.adj.r, cols=2)
dev.off()

png(filename = "Spatial_Dependence.png", width = 600, height = 225, units = "px")
base_size=12
ggplot(data = OB.Stat.Summary, aes(x = lambda)) +
  geom_line(aes(y = 0.05),colour = "red", linetype = "longdash") +
  geom_vline(xintercept = 3.8,colour = "red", linetype = "longdash") +
  geom_vline(xintercept = 4.2,colour = "red", linetype = "longdash") + 
  geom_line(aes(y = Median, colour = "Median")) +
  geom_line(aes(y = Mean, colour = "Mean")) +
  scale_colour_manual("", 
                      breaks = c( "Median","Mean"),
                      values = c( "blue","cyan")) +
  xlab(" ") +
  scale_y_continuous("Diagonal elements", breaks=c(0,0.05,0.2,0.4,0.6,0.8,1.0,1.2)) + 
  labs(x="Distance decay parameter")+
  theme(
    axis.line =         element_line(colour = "gray70", size = 0.5),
    axis.text.x =       element_text(size = base_size *1.2 , lineheight = 0.9, colour = "black", vjust = 1),
    axis.text.y =       element_text(size = base_size *1.2 , lineheight = 0.9, colour = "black", hjust = 1),
    axis.ticks =        element_line(colour = "black"),
    axis.title.x =      element_text(size = base_size *1.2 , vjust = 0.5),
    axis.title.y =      element_text(size = base_size *1.2 , angle = 90, vjust = 0.5),
    axis.ticks.length = unit(0.15, "cm"),
    axis.ticks.margin = unit(0.1, "cm"),
    legend.text = 		element_text(size = base_size * 1.5 ),

    panel.background = element_rect(fill = "white", colour = NA), 
    panel.border =     element_rect(fill = NA, colour = "grey50"), 
    panel.grid= element_line(colour = "grey98", size = 0.5), 
    panel.margin =  unit(0.25, "lines")
  )
dev.off()


