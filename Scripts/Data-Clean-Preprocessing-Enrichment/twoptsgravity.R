library(ggplot2)
library(grid)
d=seq(0,20,0.2)
gravity <- function(lambda,d){
  p<- (1/d^lambda)/(1/d^lambda+1/(20-d)^lambda)
  p[1]<-1
  return(p)
}
p1 <- gravity(1,d)
p0.5 <- gravity(0.5,d)
p2 <- gravity(2,d)


twoptsgravity = data.frame(p0.5, p1, p2, d)
png(filename = "2ptsgravity.png", width = 450, height = 450, units = "px")
base_size=12
ggplot() +
  geom_line(data = twoptsgravity, aes(x = d, y = p0.5), linetype = "longdash") +
  annotate("text", x = twoptsgravity$d[5], y = (twoptsgravity$p0.5[5]-0.1), label = paste("lambda == ","0.5"),parse = TRUE) +
  geom_line(data = twoptsgravity, aes(x = d, y = p1), linetype = "solid") +
  annotate("text", x = twoptsgravity$d[15], y = twoptsgravity$p1[15]-0.07, label = paste("lambda == ","1"),parse = TRUE) +
  geom_line(data = twoptsgravity, aes(x = d, y = p2), linetype = "dashed") +
  annotate("text", x = twoptsgravity$d[26], y = t(twoptsgravity$p2[25]-0.07), label = paste("lambda == ","2"),parse = TRUE) +
  geom_line(data = twoptsgravity, aes(x = d, y = 0.5), linetype = "twodash") +
  annotate("text", x = 1, y = 0.475, label = paste("lambda == ","0"),parse = TRUE) +
  geom_line(aes(x = c(seq(0,10,0.2),rep(10,99),seq(10,20,0.2)), y = c(rep(1,51),seq(0.99,0.01,-0.01),rep(0,51))), linetype = "dotted") +
  annotate("text", x = 11, y = 0.9, label = paste("lambda == ","infinity"),parse = TRUE) +
  geom_line(aes(x = c(seq(0,twoptsgravity$d[32],0.2),rep(twoptsgravity$d[32],60)), y = c(rep(twoptsgravity$p0.5[32],32),seq(twoptsgravity$p0.5[32],0,-0.01))), linetype = "dotdash") +

  scale_x_continuous("Distance", breaks=c(0,twoptsgravity$d[32],5,10,15,20), labels = c("0","g","5","10","15","20")) +   
  scale_y_continuous("Probability", breaks=c(0,twoptsgravity$p0.5[32],0.5,1.0), labels = c("0",expression(p["gk"]),"0.5","1")) + 
#  labs(x="Distance") +
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
