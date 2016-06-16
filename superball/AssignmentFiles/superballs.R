setwd("D:/qiyi/R/superball/AssignmentFiles")

library("dplyr")
library("reshape2")
library("ggplot2")
library("caret") 
library("EBImage")
training <- read.csv("training.csv")
test <- read.csv("test.csv")

#Question 1##################


a <- training[,-1]%>%
     melt(var.ids=32, measure.vars=c(1:31))


p <- ggplot(a, aes(x=variable, y=value, fill=Class)) + 
     geom_boxplot()
p
  
#Question 2##################
training$X <- NULL
test$X <- NULL

set.seed(7)
inTrainingSet <- createDataPartition(training$Class,
                                    p = 0.60, list = FALSE)
CreditTrain <- training[inTrainingSet,]
Crediteval <- training[-inTrainingSet,]
set.seed(7)

fit.lda <- train(Class~., data=CreditTrain, 
                 method="lda", metric="Accuracy" 
                )
print(fit.lda)
pred.Crediteval <- predict(fit.lda,Crediteval[,-33])
confusionMatrix(pred.Crediteval,Crediteval$Class)

  
#Question 3##################
set.seed(7)

fit.lda <- train(Class~., data=training, 
                 method="lda", metric="Accuracy" 
                 )
pred.test <- predict(fit.lda,test[,-33])
confusionMatrix(pred.test,test$Class)



#Question 4.1##################
correlation <- cor(training[,-32]) 
library(corrplot)
corrplot(correlation)


#Question 4.2######
Image <- readImage("superballs_RGB.png")
display(Image)
Imagedata <- imageData(Image)
files1 <- paste0("superballs_ms_0",1:9)
files2 <- paste0("superballs_ms_",10:31)
files <- c(files1,files2)
train.temp <-data.frame(matrix(0,512*512,31))
for(i in 1:31) {

    ms <- readImage(paste(files[i],"png",sep='.'))%>%
          melt()%>%
          .[3]

    train.temp[,i] <- ms


}
colnames(train.temp) <- paste("V",1:31,sep ="" )
Red_Mask <- readImage("Red_Mask.png")
colorMode(Red_Mask) <- Grayscale        
Red_Mask <- Red_Mask[,,1]/4 + Red_Mask[,,2]/4 + Red_Mask[,,3]/4 +Red_Mask[,,4]/4 
display(Red_Mask)
Red_Mask <- melt(Red_Mask)%>%
            .[,3]
Red_Mask <- ifelse(Red_Mask>0.5,"Red","Background")

train.temp <- cbind(train.temp,Class=Red_Mask)

b <- melt(train.temp,var.ids=32, measure.vars=c(1:31))
p1 <- ggplot(b, aes(x=variable, y=value, fill=Class)) + 
     geom_boxplot()
p1
#Question 5##################
  
pred.temp <- predict(fit.lda,train.temp[,-32])

imag <- ifelse(pred.temp=="Red",1,0) %>%
         matrix(512,512)
display(imag) 
#Question 6##################
confusionMatrix(pred.temp,factor(train.temp$Class)) 
#Question 7################## 
importance <- varImp(fit.lda, scale=FALSE)  
print(importance)
# plot importance
plot(importance)
  
#Question 8##################  
metric <- "Accuracy"
##### MODEL1
set.seed(7)
fitControl <- trainControl(method = "cv",
                           number = 5,
                           returnResamp = "final",
                           classProbs = TRUE
                           #summaryFunction = twoClassSummary
)

model_lda <- train(Class~.,data=training,
                  method = "lda", 
                  trControl = fitControl,
                  metric = metric 
                  
                  )



##### MODEL2
set.seed(7)
fitControl <- trainControl(method = "cv",
                           number = 5,
                           returnResamp = "final",
                           classProbs = TRUE
                           #summaryFunction = twoClassSummary
                           
  )
  

  
  
model_DT <- train(Class~.,data=training,
                   method = "rpart", 
                   trControl = fitControl,
                   metric = metric
                   )



##### MODEL3 
set.seed(7)
fitControl <- trainControl(method="cv", 
                           number=5,
                           returnResamp = "final",
                           classProbs = TRUE
                           #summaryFunction = twoClassSummary
  )
  
  
model_knn <- train(Class~.,data=training,
                   method = "knn", 
                   trControl = fitControl,
                   metric = metric 
                   
                   )
  
boosting_results <- resamples(list(lda=model_lda, DT=model_DT,knn=model_knn))
summary(boosting_results)
dotplot(boosting_results)
#Question 9################## 
set.seed(7)
fitControl <- trainControl(method="cv", 
                           number=5,
                           returnResamp = "final",
                           classProbs = TRUE
                           #summaryFunction = twoClassSummary
)


model_knn_2 <- train(Class~.,data=training,
                   method = "knn", 
                   trControl = fitControl,
                   metric = metric,
                   preProc = c("center", "scale")
                   )
boosting_results <- resamples(list(knn=model_knn, pre.knn=model_knn_2)) 
summary(boosting_results)
dotplot(boosting_results)
#Question 10################## 

Image <- readImage("superballs_RGB.png")
imgDm <- dim(Image)
imgRGB <- data.frame(x=rep(1:imgDm[2],imgDm[1]),
                     y=rep(imgDm[1]:1,each=imgDm[2]),
                     R=as.vector(Image[,,1]),
                     G=as.vector(Image[,,2]),
                     B=as.vector(Image[,,3]))
# ggplot theme to be used
plotTheme <- function() {
  theme(
    panel.background = element_rect(
      size = 3,
      colour = "black",
      fill = "white"),
    axis.ticks = element_line(
      size = 2),
    panel.grid.major = element_line(
      colour = "gray80",
      linetype = "dotted"),
    panel.grid.minor = element_line(
      colour = "gray90",
      linetype = "dashed"),
    axis.title.x = element_text(
      size = rel(1.2),
      face = "bold"),
    axis.title.y = element_text(
      size = rel(1.2),
      face = "bold"),
    plot.title = element_text(
      size = 20,
      face = "bold",
      vjust = 1.5)
  )
}


set.seed(7)
KMeans <- kmeans(imgRGB[,c("R","G","B")],centers = 9)
kcolors <- rgb(KMeans$centers[KMeans$cluster,])


ggplot(data=imgRGB,aes(x=x,y=y))+
   geom_point(colour=kcolors)+
   labs(title=paste("k-Means Clustering of",9,"Colours"))+
   xlab("x")+
   ylab("y")+
   plotTheme()

cluster = ifelse(KMeans$cluster==2,"Red","Background")
confusionMatrix(cluster,train.temp$Class)
cluster2 = ifelse(KMeans$cluster==2,1,0)
cluster2 = matrix(cluster2,512,512)
display(cluster2)



