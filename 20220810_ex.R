#[ 연습 문제 ] Data Scaling
# Iris 분류 시 스케일링 전후 비교(KNN)

#data scaling
iris_scale <- scale(iris[, -5])
#train/test split
rn <- sample(1:nrow(iris_scale), size = nrow(iris_scale) * 0.7)
iris_scale_tr <- iris_scale[rn, ]
iris_scale_te <- iris_scale[-rn, ]
#modeling
m1 <- knn(train = iris_train[, -5],
          test = iris_test[, -5],
          cl = iris_train$Species,
          k = 3)

m2 <- knn(train = iris_scale_tr,
          test = iris_scale_te,
          cl = iris$Species[rn],
          k = 3)
#score
sum(m1 == iris_test$Species) / nrow(iris_test) * 100       #97.78
sum(m2 == iris$Species[-rn]) / nrow(iris_scale_te) * 100   #97.78



#[ 실습 문제 ]
#1. Iris 데이터의 분류 과제(KNN = scaling + 변수 선택 고려)

#Variable Importance
library(rpart)
iris_dt <- rpart(Species ~. , data = iris_train)
iris_dt$variable.importance


#modeling
library(class)

m1 <- knn(train = iris_train[, c(3, 4)],
          test = iris_test[, c(3, 4)],
          cl = iris_train$Species,
          k = 3)

m2 <- knn(train = iris_scale_tr[, c(3, 4)],
          test = iris_scale_te[, c(3, 4)],
          cl = iris$Species[rn],
          k = 3)
#score
sum(m1 == iris_test$Species) / nrow(iris_test) * 100       #97.78
sum(m2 == iris$Species[-rn]) / nrow(iris_scale_te) * 100   #97.78



#2. cancer 데이터의 분류 과제
cancer <- read.csv('data/cancer.csv')
head(cancer)

#불필요 변수 제거
cancer$id <- NULL

#[ factor형 변수 ]
#- 주로 문자 컬럼에 적용(숫자도 factor 선언 가능)
#- 정해진 범주를 갖는 변수의 형태 고정
#  (ex. 성별 > 남/여 이외의 다른 값 허용 X)
cancer$diagnosis <- factor(cancer$diagnosis)

#1) DT
#sampling
rn <- sample(1:nrow(cancer), size = nrow(cancer) * 0.7)
cancer_tr <- cancer[rn, ]
cancer_te <- cancer[-rn, ]
#modeling
library(rpart)
cancer_dt <- rpart(diagnosis ~. , data =  cancer_tr)
#score
vresult <- predict(cancer_dt, newdata = cancer_te, type = 'class')
sum(vresult == cancer_te$diagnosis) / nrow(cancer_te) * 100      #94.74
#tuning
vscore_tr <- c(); vscore_te <-  c()
for (i in 2:10) {
  cancer_dt <- rpart(diagnosis ~. , data = cancer_tr, minbucket = i)
  vresult1 <- predict(cancer_dt, newdata = cancer_tr, type = 'class')
  vresult2 <- predict(cancer_dt, newdata = cancer_te, type = 'class')
  vscore_tr <- c(vscore_tr, 
                 sum(vresult1 == cancer_tr$diagnosis) / nrow(cancer_tr) * 100)
  vscore_te <- c(vscore_te, 
                 sum(vresult2 == cancer_te$diagnosis) / nrow(cancer_te) * 100)
}
vscore_tr
vscore_te

dev.new()
plot(2:10, vscore_tr, type = 'o', col = 'red', ylim = c(85, 100),
     xlab = 'minbucket', ylab = 'score')
lines(2:10, vscore_te, type = 'o', col = 'blue')
#final model
#score:  TR: 98.24121, TE: 96.49123
cancer_dt <- rpart(diagnosis ~. , data =  cancer_tr, minbucket = 2)

#변수중요도
cancer_dt$variable.importance



#2) RF(ntree, mtry 튜닝)

#sampling
cancer_tr <- cancer[rn, ]
cancer_te <- cancer[-rn, ]
#modeling
cancer_rf <- randomForest(diagnosis ~. , data = cancer_tr)
#tuning
#ntree
rfscore_tr <- c(); rfscore_te <-  c()
for (i in 1:500) {
  cancer_rf <- randomForest(diagnosis ~. , data = cancer_tr, ntree = i)
  vresult3 <- predict(cancer_dt, newdata = cancer_tr, type = 'class')
  vresult4 <- predict(cancer_dt, newdata = cancer_te, type = 'class')
  rfscore_tr <- c(rfscore_tr, 
                 sum(vresult3 == cancer_tr$diagnosis) / nrow(cancer_tr) * 100)
  rfscore_te <- c(rfscore_te, 
                 sum(vresult4 == cancer_te$diagnosis) / nrow(cancer_te) * 100)
}
dev.new()
plot(1:500, rfscore_tr, type = 'o', col = 'red', ylim = c(85, 100),
     xlab = 'ntree', ylab = 'score')
lines(1:500, rfscore_te, type = 'o', col = 'blue')

#mtry
rfscore_tr <- c(); rfscore_te <-  c()
for (i in 1:30) {
  cancer_rf <- randomForest(diagnosis ~. , 
                            data = cancer_tr, ntree = 2, mtry = i)
  vresult3 <- predict(cancer_dt, newdata = cancer_tr, type = 'class')
  vresult4 <- predict(cancer_dt, newdata = cancer_te, type = 'class')
  rfscore_tr <- c(rfscore_tr, 
                  sum(vresult3 == cancer_tr$diagnosis) / nrow(cancer_tr) 
                  * 100)
  rfscore_te <- c(rfscore_te, 
                  sum(vresult4 == cancer_te$diagnosis) / nrow(cancer_te) 
                  * 100)
}
dev.new()
plot(1:30, rfscore_tr, type = 'o', col = 'red', ylim = c(85, 100),
     xlab = 'mtry', ylab = 'score')
lines(1:30, rfscore_te, type = 'o', col = 'blue')

#final model
#score: TR: 95.47739, TE: 95.32164
cancer_rf <- randomForest(diagnosis ~. , 
                          data = cancer_tr, ntree = 2, mtry = 2)


#3) KNN(k tuning, scaling + 변수 선택 고려)
#scaling
head(cancer)
cancer_sc <- scale(cancer[, -1])
#sampling
variable_ls <- names(cancer_dt$variable.importance)

cancer_sc_tr <- cancer_sc[rn, variable_ls]
cancer_sc_te <- cancer_sc[-rn, variable_ls]
#modeling
cancer_knn2 <- knn(train = cancer_sc_tr,
                  test = cancer_sc_te,
                  cl = cancer_tr$diagnosis,
                  k = 3)

cancer_knn1 <- knn(train = cancer_sc_tr,
                  test = cancer_sc_tr,
                  cl = cancer_tr$diagnosis,
                  k = 3)
#score
sum(cancer_knn1 == cancer_tr$diagnosis) / nrow(cancer_tr) * 100   #96.23116
sum(cancer_knn2 == cancer_te$diagnosis) / nrow(cancer_te) * 100   #92.39766
#변수 선택
head(cancer_sc_tr)

vscore1 <- c(); vscore2 <- c()
for (i in seq(length(variable_ls), 2, -1)) {
  cancer_knn1 <- knn(train = cancer_sc_tr[, 1:i],
                     test = cancer_sc_tr[, 1:i],
                     cl = cancer_tr$diagnosis,
                     k = 3)
  cancer_knn2 <- knn(train = cancer_sc_tr[, 1:i],
                     test = cancer_sc_te[, 1:i],
                     cl = cancer_tr$diagnosis,
                     k = 3)
  
  score1 <- sum(cancer_knn1 == cancer_tr$diagnosis) / nrow(cancer_tr) * 100
  score2 <- sum(cancer_knn2 == cancer_te$diagnosis) / nrow(cancer_te) * 100
  
  vscore1 <- c(vscore1, score1)
  vscore2 <- c(vscore2, score2)
}
vscore1
vscore2

dev.new()
plot(seq(length(variable_ls), 2, -1), vscore1, type = 'o', col = 'red', ylim = c(85, 100),
     xlab = 'mtry', ylab = 'score')
lines(seq(length(variable_ls), 2, -1), vscore2, type = 'o', col = 'blue')
#final model
#score: TR: 97.23618, TE: 94.15205
cancer_knn_fina2 <- knn(train = cancer_sc_tr[, 1:7],
                   test = cancer_sc_tr[, 1:7],
                   cl = cancer_tr$diagnosis,
                   k = 3)

cancer_knn_final <- knn(train = cancer_sc_tr[, 1:7],
                   test = cancer_sc_te[, 1:7],
                   cl = cancer_tr$diagnosis,
                   k = 3)

sum(cancer_knn_fina2 == cancer_tr$diagnosis) / nrow(cancer_tr) * 100
sum(cancer_knn_final == cancer_te$diagnosis) / nrow(cancer_te) * 100


#최종 제출
total <- preidct(cancer_knn_final, newdata = cancer_test)[, 1, drop = F]
write.csv(total, 'predict.csv', row.names = T)