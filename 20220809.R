#[ Impurity : 불순도 ]

#1. 정의: Y가 factor(범주형)에서 트리기반 모델링 적용 시 특정 노드의
#         각 클래스별 혼합 정도( <-> 순수도)

#2. 종류
#1) 지니 지수 (Gini Index)
#   한 노드가 여러 클래스로 섞여 있는지 확인하는 지표. 클수록 불순도가 높음
#   Gini = 1 - ( p1^2 + p2^2 + ... )

#2) 엔트로피 지수 (Entropy Index)
#   열역학에서의 무질서 정도를 나타내는 척도 
#   E = - ( p1 * log2p1 + p2 * log2p2 + ... )

#3) 정보이득 = 정보소득 = IG(Information Gain)
#   상위 노드 불순도와 하위노드 불순도의 차이로 어떤 분류 기준이 더 많은
#   정보이익을 내는지 측정 척도로 사용, 클수록 분류 조건으로 적합함
#   IG = E(S) - ( p(t1) * E(t1) + p(t2) * E(t2) + ... )

#4) 카이제곱 통계량





#[ Random Forest ]
#여러 개의 의사결정 나무가 결합된 모형
#목적: 서로 다른 트리 구성 > 예측률 상승 > 예측 오차 감소
#다양한 트리 구성을 위해 샘플링 시 복원 추출 허용
#회귀분석에도 사용할 수 있음



#[ 매개 변수 ] hyperparameter
#1) 트리 수(ntree)
#   - default: 500
#   - 트리의 수가 클수록 예측 정확도 상승, 수행시간(모델링, 예측) 길어짐
#   - 어느 정도 이상 예측률 변화 없음(elbow point) > 최적의 트리 수

#2) 임의성정도(mtry)
#   - default: floor(sqrt(ncol(dataset)))
#   - mtry가 클수록 서로 비슷한 트리 구성 확률 높아짐 
#   - mtry가 작을수록 예측률 저하 or 복잡한 트리 구성 확률 높아짐




#[ RF 내부 알고리즘 ]
#1) Ensemble 앙상블 
#   - 여러 모델이 결합된 형태
#   - 모든 결론을 조합하여 최적의 결론 도출
#   - 다수결의 원칙(분류) 또는 평균(회귀)으로 최종 결론

#2) Bootstrap 부트스트랩
#   - train dataset에 대한 복원 추출 샘플링

#3) Bagging 배깅
#   - Bootstrap + Aggregate
#   - 복원 추출한 표본을 train 후 각 결과를 조합하여 최종 결론 도출


#4) Randomization 임의화 
#   - 임의노드최적화
#   - 각 트리 가지치기할 때마다 임의성 정도 부여
#   - 임의성 정도: 각 트리의 비상관성을 결정하는 요소 
#                  임의성 정도(mtry)가 클수록 서로 비슷한 트리 구성
#                  > 트리끼리 상관성이 강해짐




#예제) Random Forest with Iris
install.packages('randomForest')
library(randomForest)

#1) Sampling
set.seed(0) # 시드 고정
sample(1:100, 5)

rn <- sample(1:nrow(iris), size = nrow(iris) * 0.7)
iris_tran <- iris[rn, ]
iris_test <- iris[-rn, ]


#2) Modeling
m1 <- randomForest(Species ~. , data = iris_train)
m1

#  randomForest(formula = Species ~ ., data = iris_train) 
#                   Type of random forest: classification
#                   Number of trees: 500          
#                   No. of variables tried at each split: 2 
#                   가지치기 시 사용하는 설명변수의 수

#OOB estimate of  error rate: 5.71%    예측오차
#Confusion matrix:
#                       < 예측범주 >
#< 실제범주 >  setosa versicolor virginica class.error
#   setosa        34        0         0     0.00000000
# versicolor      0         32        2     0.05882353
# virginica       0         4         33    0.10810811


#3) Score
#test dataset
vresult <- predict(m1, newdata = iris_test, type = 'class')
sum(vresult == iris_test$Species) / nrow(iris_test) * 100      #100
#train dataset
vresult2 <- predict(m1, newdata = iris_train, type = 'class')
sum(vresult2 == iris_train$Species) / nrow(iris_train) * 100   #100


#4) Tuning
#ntree(default: 500) : 트리 수
vscore_tr <- c()
vscore_te <- c()
for (i in 1:100) {
  m2 <- randomForest(Species ~. , data = iris_train, ntree = i)
  
  vresult1 <- predict(m2, newdata = iris_train, type = 'class')
  vresult2 <- predict(m2, newdata = iris_test, type = 'class')
  
  vscore_tr <- c(vscore_tr, 
                 sum(vresult1 == iris_train$Species) / nrow(iris_train) * 100)
  vscore_te <- c(vscore_te, 
                 sum(vresult2 == iris_test$Species) / nrow(iris_test) * 100)
}

dev.new()
plot(1:100, vscore_tr, type = 'o', col = 'red', ylim = c(80, 100),
     xlab = 'ntree', ylab = 'score')
lines(1:100, vscore_te, type = 'o', col = 'blue')


#mtry : 가지치기마다 고려하는 설명변수 수



