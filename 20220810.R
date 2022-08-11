#[ 거리 기반 모델 ]
#분류모델(KNN), 군집분석(k-means)
#거리를 계산해서 각 데이터포인트들끼리의 유사성 측정
#이상치와 결측치에 매우 민감
#거리 비교를 위한 변수 스케일링(표준화) 작업 필요

#           수학점수       영어점수
#학생1        90 3rd          90 2nd
#학생2        95 1st         100 1st
#학생3        94 2nd          60 3rd
#수학점수 학생2와 학생1의 거리가 더 가까워보이지만 분산, 평균을 확인해보면
#영어점수 학생2와 학생1 거리가 가깝다



#[ KNN ]
#거리 기반 모델
#지도학습의 분류분석 수행
#K개의 가장 가까운 이웃의 결과를 종합하여 최종 결론 도출 
#게으른 학습(데이터가 학습될수록 패턴이 정교해지는 방식 X)
#사전 변수 선택이 중요함
#(변수 중요도가 낮은 변수에 의해 거리 측정 miss 가능성 있음)


#예제) KNN with Iris
#1) Sampling
iris_train
iris_test


#2) Modeling
install.packages('class')
library(class)

knn(train = ,             #train X data
    test = ,              #test X data
    cl = ,                #train Y data
    k = ,                 #이웃 수
    prob = F)             #확률 출력 여부


#예측결과
m1 <- knn(train = iris_train[, -5],
          test = iris_test[, -5],
          cl = iris_train$Species,
          k = 3,
          prob = T)

m2 <- knn(train = iris_train[, -5],
          test = iris_train[, -5],
          cl = iris_train$Species,
          k = 3,
          prob = T)


#3) Score
sum(m2 == iris_train$Species) / nrow(iris_train) * 100  #train dataset: 94.29
sum(m1 == iris_test$Species) / nrow(iris_test) * 100    #test dataset: 97.78


#4) Tuning
#   - k의 변화에 따른 예측률 변화
vresult1 <- c()
vresult2 <- c()
for (i in 1: 10) {
  m3 <- knn(train = iris_train[, -5], test = iris_test[, -5],
            cl = iris_train$Species, k = i)
  m4 <- knn(train = iris_train[, -5], test = iris_train[, -5],
            cl = iris_train$Species, k = i)
  vresult1 <- c(vresult1, 
                sum(m3 == iris_test$Species) / nrow(iris_test) * 100)
  vresult2 <- c(vresult2, 
                sum(m4 == iris_train$Species) / nrow(iris_train) * 100)
}

dev.new()
plot(1:10, vresult1, type = 'o', ylim = c(80, 100), col = 'red')
lines(1:10, vresult2, type = 'o', col = 'blue')




#[ Data Scaling 변수 스케일링 ] 
#변수마다 서로 다른 크기, 범위를 가지고 있을 경우 거리 측정이 정확하지 않음
# > 동일 선생에서 비교하기 위한 목적으로 스케일 조절
#거리기반 모델(knn, k-means), PCA, NN

#1) Standard scale(표준화)
#   - 모든 값을 평균이 0, 표준편차를 1로 변경 방식
#   - (x - mean(x)) / sd(x)

#2) minmax scale
#   - 모든 값을 0 ~ 1 사이에 두는 방식
#   - (x - min(x)) / (max(x) - min(x))

#3) robust scale
#   - 사분위수를 사용한 스케일 조정
#   - (x - q2) / (q3 - p1)




#예제) Data Scaling with Iris
#1) Standard scale
(iris$Sepal.Length - mean(iris$Sepal.Length)) / sd(iris$Sepal.Length)

f_standard <- function(x) {
  (x - mean(x)) /sd(x)
}

iris_scale <- apply(iris[, -5], 2, f_standard)

#함수
scale(iris[, -5])


#2) minmax scale
f_minmax <- function(x) {
  (x - min(x)) / (max(x) - min(x))
}
apply(iris[, -5], 2, f_minmax)

#함수
library(caret)
m1 <- preProcess(iris[, -5], method = 'range')
predict(m1, iris[, -5])


#3) robust scale
library(DescTools)
RobScale(iris[, -5])




#[ 스케일링 수행 시 주의 ]
#case 1) data scaling > split train/test: 그대로 진행

#case 2) split train/test > data scaling 
#반드시 같은 기준으로 scaling 진행
#> train에 대한 기준을 동일하게 test에도 적용




