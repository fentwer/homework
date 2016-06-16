#setwd("D:/qiyi/R/417886179/guesture")
library("dplyr")
library("reshape2")
library("lattice")
library("ggplot2")
library("corrplot")
library("FactoMineR")
library("factoextra")
library("caret")
library("cluster")
#Q1.R#######################################################

load("evaluation.RData")

# transform to factors  
score$instr  <- factor(score$instr,levels=c(1,2,3),
                  labels=c("instr1","instr2","instr3")) 
score$attendance <- factor(score$attendance,levels=c(0,1,2,3,4),
                       labels=c("0att","1att","2att",
                                "3att","4att"))
score$class <- factor(score$class,levels=1:13,
                 labels=paste("class",1:13,sep=""))
score$nb.repeat  <- factor(score$nb.repeat,levels=c(1,2,3),
                       labels=c("rep1","rep2","rep3")) 


# bar chart of the categorical data 
instr.tab <- data.frame(xtabs( ~ instr+attendance , score ))
barchart(Freq~attendance|instr,instr.tab,origin=0,xlab="attendance")

in.cl.tab <- data.frame(xtabs( ~ instr+class+attendance+nb.repeat , score ))
barchart(class~Freq|instr+nb.repeat,in.cl.tab,
         groups = attendance, stack = TRUE,
         auto.key = list(title = "the level of attendance", columns = 5))

# collapse columns into rows
a= melt(score,var.ids=c(1:4), measure.vars=c(5:33))
attach(a)
#box-and-whisker plots
bwplot(variable~value|instr*attendance )

bwplot(variable~value|class*attendance)

# kernel density plots by factor level
densityplot(~value|variable)

densityplot(~value|instr*nb.repeat,groups = attendance,stack = TRUE,
            auto.key = list(title = "the level of attendance", columns = 5))


#Q-Q plot
qqmath(~value|variable,data=a,groups = attendance,key =
         simpleKey(levels(a$attendance), space = "right"))
detach()
# Correlation matrix

M = cor(score[,5:33])
corrplot(M, method = "circle")

# Draw the heatmap
col<- colorRampPalette(c("blue", "white", "red"))(20)
heatmap(x = M, col = col, symm = TRUE)
library("ComplexHeatmap")
densityHeatmap(scale(score))
# 3D scatter plot

cloud(difficulty~Q17*Q9|attendance,data=score)

res.Qpca <- PCA(scale(score[,6:33]),  graph = FALSE)
Q.ind <- get_pca_ind(res.Qpca)
data <- cbind(data.frame(Q.ind$coord[,1:2]),
              difficulty=scale(score$difficulty),
              attendance=score$attendance)
cloud(difficulty~Dim.1*Dim.2|attendance,data=data)

# scatterplot matrix 
splom(score[,c("difficulty","Q17","Q9","Q3","Q21","Q26")])

#+++++++++++++++++++++++++++++++++++++++++
# outlier detection based on cluster
# scale the data


#optimizate  number of cluster
score.scale <- scale(score[,5:33])
fviz_nbclust(score.scale , kmeans, method = "wss") +
  geom_vline(xintercept = 3, linetype = 2)



# PCA
res.pca <- PCA(score.scale,  graph = FALSE)
# Visualize eigenvalues/variances
fviz_eig(res.pca, addlabels=TRUE, hjust = -0.3)+
  theme_minimal()
ind <- get_pca_ind(res.pca)
dim(ind$coord)
# k-means cluster  
km.res <- kmeans(score.scale,3, nstart = 25)
fviz_cluster(km.res, score.scale,geom = "point")
# clusters centers
km.res$centers
# calculate distance
centers <- km.res$centers[km.res$cluster,]
distances <- sqrt(rowSums((score.scale-centers)^2))
outliers <- order(distances,decreasing=T)[1:10] 
print(outliers)
#plot cluster and outliers
pca.data <- data.frame(ind$coord[,1:2],cluster=factor(km.res$cluster))
qplot(x=Dim.1,y=Dim.2,data=pca.data,colour=cluster)+
  geom_point(data=as.data.frame(ind$coord[outliers,1:2]),
             size = 7,color="red",pch="+")

#++++++++++++++++++++++++++++++++++++++++++
# importance of the features
score$nb.repeat <- as.integer(score$nb.repeat)
fitControl <- trainControl(method = "cv",
                           number = 5,
                           repeats = 5,
                           verboseIter = TRUE)

fit.rf <- train(attendance~., data=score, 
                 method="rf", metric="Accuracy", 
                 trControl = fitControl
)

importance <- varImp(fit.rf, scale=T) 
# plot importance
plot(importance)

# importance of the features after PCA
Q.scale <- scale(score[,6:33])
# PCA
res.Qpca <- PCA(Q.scale,  graph = FALSE)
Q.ind <- get_pca_ind(res.Qpca)

score.new <- cbind(score[,1:5],Q.ind$coord)
fit.rf.new <- train(attendance~., data=score.new, 
                method="rf", metric="Accuracy", 
                trControl = fitControl
)

importance.new <- varImp(fit.rf.new, scale=T) 
# plot importance
plot(importance.new)


# discrete variable
score.temp <- score[,5:33]
for (ft in names(score.temp)){
  score.temp[,ft] <-as.integer(cut(score.temp[,ft], 5)) 
}

score.new2 <- cbind(score[,1:4],score.temp)
fit.rf.new2 <- train(attendance~., data=score.new2, 
                    method="rf", metric="Accuracy", 
                    trControl = fitControl
)

importance.new2 <- varImp(fit.rf.new2, scale=T) 
# plot importance
plot(importance.new2)



#Q2.R###########################################################

load("Gesture.RData")
# gather the data
gesture_raw <- rbind(a1_raw,a2_raw)%>%
           rbind(.,a3_raw)%>%
           rbind(.,b1_raw)%>%
           rbind(.,b3_raw)%>%
           rbind(.,c1_raw)%>%
           rbind(.,c3_raw)
gesture_va3 <- rbind(a1_va3,a2_va3)%>%
              rbind(.,a3_va3)%>%
              rbind(.,b1_va3)%>%
              rbind(.,b3_va3)%>%
              rbind(.,c1_va3)%>%
              rbind(.,c3_va3)
gesture <- cbind(gesture_va3,gesture_raw)%>%
           arrange(timestamp)


###Exploring data
b1= melt(gesture[,1:32])
b2= melt(gesture[,33:50])
#box-and-whisker plots
bwplot(variable~value,data=b1 )
bwplot(variable~value,data=b2 )
# kernel density plots
densityplot(~value|variable,data=b1)
densityplot(~value|variable,data=b2)
# Q-Q PLOT
qqmath(~value|variable,data=b1)
qqmath(~value|variable,data=b2)




#  Correlation matrix
M = cor(gesture)
corrplot(M, method = "circle")


# heatmap

col<- colorRampPalette(c("blue", "white", "red"))(20)
heatmap(x = M, col = col, symm = TRUE)

#PCA
res.pca <- PCA(gesture[,-ncol(gesture)],  graph = FALSE)

# Visualize eigenvalues/variances
fviz_eig(res.pca, addlabels=TRUE, hjust = -0.3)+
  theme_minimal()

#+++++++++++++++++++++++++++++++++++++++++



# clustering

gesture.scaled <- scale(gesture)  #scale the data

# optimizate  number of cluster
k.max <- 15
data <- gesture.scaled
sil <- rep(0, k.max)

# Compute the average silhouette width for 
# k = 2 to k = 15
for(i in 2:k.max){
  km.res <- kmeans(data, centers = i, nstart = 25)
  ss <- silhouette(km.res$cluster, dist(data))
  sil[i] <- mean(ss[, 3])
}

# Plot the  average silhouette width
plot(1:k.max, sil, type = "b", pch = 19, 
     frame = FALSE, xlab = "Number of clusters k")
abline(v = which.max(sil), lty = 2)

# K-means clustering
# +++++++++++++++++++++
km.res <- kmeans(gesture.scaled, 5, nstart = 25)

# Visualize kmeans clustering
# Show points only
fviz_cluster(km.res, gesture.scaled, geom = "point")



# PAM clustering
# ++++++++++++++++++++
pam.res <- pam(gesture.scaled, 5)
# Visualize pam clustering
fviz_cluster(pam.res, geom = "point")

# Hierarchical clustering
# ++++++++++++++++++++++++
# Compute pairewise distance matrices
dist.res <- dist(gesture, method = "euclidean")
# Hierarchical clustering results
hc <- hclust(dist.res, method = "complete")
# Visualization of hclust
fviz_dend(hc,k=5,show_labels=FALSE,
          k_colors = c("#00AFBB","#2E9FDF", "#E7B800", "#FC4E07","#56B4E9"),
          color_labels_by_k = TRUE)
rect.hclust(hc, k =5, border = 2:4)

# Cut into 5 groups
hc.cut <- cutree(hc, k = 5)

# Use hcut() which compute hclust and cut the tree
hcut(gesture, k = 5, hc_method = "complete")

# Silhouette plots
# ++++++++++++++++++++++++++++++

# Silhouhette for kmeans
sil <- silhouette(km.res$cluster, dist(gesture.scaled))
fviz_silhouette(sil)
# Silhouette for PAM
fviz_silhouette(silhouette(pam.res))
# Silhouette for hierarchical clustering
fviz_silhouette(silhouette(hc.cut, dist.res))



