setwd("D:/qiyi/R/兼职/YOUJIAN")
library('tm')
library(dplyr)
corpus1  = Corpus(DirSource("./Phishing")); ##建立语库
corpus2  = Corpus(DirSource("./Non-phishing")); ##建立语库
summary(corpus1)
inspect(corpus1[16])
viewDocs <- function(d, n) {d %>% extract2(n) %>% as.character() %>% writeLines()}
viewDocs(corpus1, 16)
#筛选语库
corpus=corpus1
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, content_transformer(tolower))
corpus = tm_map(corpus,removeWords,stopwords("english"));
corpus <- tm_map(corpus, removePunctuation);
corpus = tm_map(corpus,stripWhitespace);
summary(corpus)
inspect(corpus)

#建立文本项矩阵，并降维
dim  = DocumentTermMatrix(corpus);
dim = removeSparseTerms(dim,0.95)
dim = as.matrix(dim);
freq <- colSums(as.matrix(dim))
order(freq)
ind_name = names(freq[freq>3]);
dim =  dim[,ind_name];



