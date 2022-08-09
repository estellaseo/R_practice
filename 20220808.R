#[ 데이터 분석 ]
#방대한 데이터로부터 의미 있는 정보를 추출
#데이터를 기반한 의사 결정 

#- Data Mining
#- Machine Learning (기계학습): 데이터로 반복학습 > 패턴 추출
#ex) 이탈 분석, 이탈 요인분석, 상품 추천
#- Deep Learning


#[ Machine Learning ]
#1. Supervised Learning (지도학습)
#: 예측값(target, Y, 목적변수)이 존재하는 형태의 분석 기법
#ex) 회귀분석(Y가 연속형), 분류분석(쿠폰 반응 여부, 상품 구매 여부), etc.

#2. Unsupervised Learning (비지도 학습)
#: 예측값이 존재하지 않는 형태의 분석 기법
#ex) 군집분석 Clustering, 연관분석(추천 알고리즘), etc.


#[ Classification: 분류 분석 ]
#Y (factor: 범주형)을 예측
#X -> Y 분류를 위한 패턴 정교화


#1. Decision Tree: 의사결정나무
#-  분석기법이 간단하고 해석이 용이함
#- 시각화 가능 
#- 비통계적 모델
#- 통계적 평가 장치가 없음
#- 별도의 튜닝 없이 좋은 예측률을 리턴해줌


#예제) iris data 붓꽃의 품종 분류 (DT)

#1. 데이터 시각화
dev.new()

plot(iris[, -5], col = iris$Species)    #산점도 
#=> Patal과 관련된 컬럼들이 분류에 더 큰 역향을 미칠 수 있음



#2. 샘플링 (Train data set, Test data set 구분)
rn <- sample(1:nrow(iris), size = nrow(iris) * 0.7)

iris_train <- iris[rn, ]
iris_test <- iris[-rn, ]  




#3. 모델링
install.packages('rpart')
library(rpart)

rpart(formnula = ,               #Y ~ X
      data = )                   #데이터 프레임


m2 <- rpart(Species ~ . , data = iris_train)
m2

#1) root 150 100 setosa (0.33333333 0.33333333 0.33333333)  
#         > input data   > setosa versicolor virginica 각 비율

#2) Petal.Length< 2.45 50   0 setosa (1.00000000 0.00000000 0.00000000) *
# 분류 기준 Length              > 첫번째 클래스

#3) Petal.Length>=2.45 100  50 versicolor (0.00000000 0.50000000 0.50000000) 
#                               > 두번째 클래스
#6) Petal.Width< 1.75 54   5 versicolor (0.00000000 0.90740741 0.09259259) *
# 분류 기준 Width
#7) Petal.Width>=1.75 46   1 virginica (0.00000000 0.02173913 0.97826087) *
#                               > 세번째 클래스




#4. 평가
vresult2 <- predict(m2, newdata = iris_test, type = 'class')
sum(vresult2 == iris_test$Species)/nrow(iris_test) * 100         #93.33




#5. 예측
#클래스별 예상 확률
predict(m1, newdata = test_data)

#예측값(예상 클래스) 
predict(m1, newdata = test_data, type = 'class')




#6. 모델 시각화
dev.new()
plot(m2)
text(m2, cex = 0.8)

#외부 패키지를 활용한 의사결정나무 시각화
install.packages('rpart.plot')
library(rpart.plot)

prp(m2, 
    type = 4,                 #출력 형태
    extra = 3)                #(2: 정분류개수, 3: 오분류개수)




#7. Hyperparameter Tuning: 매개변수 튜닝

#1) minsplit : 최소 가지치기 기준(default : 20)


#2) minbucket : 최소 가지치기 기준 = round(minsplit / 3), default : 7
#최소가지치기 기준값이 클수록 과대적합 문제가 발생할 가능성이 적음


#3) cp : 복잡도 제어
m1 <- rpart(Species ~. , data = iris_train, minbucket = 2)

library(rpart.plot)
prp(m1, type = 4, extra = 3)

m1$cptable
#CP nsplit  rel error    xerror       xstd
#1 0.51515152      0 1.00000000 1.0909091 0.07207500
#2 0.40909091      1 0.48484848 0.5909091 0.07501804
#3 0.03030303      2 0.07575758 0.1515152 0.04557464
#4 0.01000000      3 0.04545455 0.1363636 0.04346286

#- CP: 복잡성 파라미터
#- nsplit: 가지의 분리된 수, 이 값보다 1 큰 수의 리프 노드(depth) 생성
#- rel error: 훈련 표본으로 만드는 주어진 나무에 대한 오류율
#- xerror: 교차검증오류
#- xstd: 표준화된 교차검증오류


#4) maxdepth : 최대 허용 길이



#[ 과대적합, 과소적합 ]
#1) 과대적합(overfitting): 일반적으로 train dataset 평가 점수가 test dataset
#                          보다 높으나 차이가 심할 경우 오히려 train dataset
#                          패턴 정교화 > 새로운 데이터에 대한 예측률이 떨어짐

#2) 과소적합(underfitting) : 일반적으로 train dataset 평가 점수가 test dataset
#                            평가점수보다 높으나 그 차이가 매우 작거나 오히려
#                            train data set 평가 점수가 낮아지는 현상

#확인 방법: train data set & test data set 점수 확인
#분석 목적: 예측률을 높이면서 과대, 과소 적합 발생 X



#예제) minbucket 튜닝
m1 <-rpart(Species ~. , data = iris)
m3 <- rpart(Species ~. , data = iris, minbucket = 3)
prp(m3, type = 4, extra =3)

vresult <- predict(m3, newdata = iris, type = 'class')
sum(vresult == iris$Species) / nrow(iris) * 100


#minbucket: 2 ~ 10 값을 변화시키면서 예측률(accuracy) 확인
#비교 대상인 매개변수를 제외하고 모두 통계 변수로 고정되어야 함(샘플링 등)
library(rpart)

vscore_tr <- c()
vscore_te <- c()
for (i in 2:10) {
  m1 <- rpart(Species ~. , data = iris_train, minbucket = i)
  vresult1 <- predict(m1, newdata = iris_train, type = 'class')
  vresult2 <- predict(m1, newdata = iris_test, type = 'class')
  vscore_tr <- c(vscore_tr, 
                 sum(vresult1 == iris_train$Species) / nrow(iris_train) * 100)
  vscore_te <- c(vscore_te, 
                 sum(vresult2 == iris_test$Species) / nrow(iris_test) * 100)
}
vscore_tr
vscore_te

dev.new()
plot(2:10, vscore_tr, type = 'o', col = 'red', ylim = c(85, 100),
     xlab = 'minbucket', ylab = 'score')
lines(2:10, vscore_te, type = 'o', col = 'blue')



#과대적합(overfitting) 문제 확인 필요!

#[ Variable importance: 변수 중요도 ]
#트리기반 모델에서 트리의 가지치기 진행 시 설명 변수의 변수 
#중요도(불순도 기반 측정)를 파악하여 가장 분리 규칙이 강한 변수와 구간을 설정
#변수 중요도는 변수 선택에 있어서 사용자가 변수를 잘 알지 못하는 경우 참고 
#데이터로 활용하기도 함

#변수 중요도 확인
m1$variable.importance
# Petal.Width Petal.Length Sepal.Length  Sepal.Width 
#  60.72222     59.14750     38.39963     27.47748 

#각 매개변수 값 확인
m1$control



#[ 파라미터 / 하이퍼 파라미터 ]
#1) 파라미터: 사용자가 설정하는 값이 아닌 모델 내부에서 결정되는 값
#ex) 회귀분석 회귀계수, 신경망 모델 가중치, etc.

#2) 하이퍼 파라미터: 사용자가 직접 설정하는 값
#ex) 신경망 모델 레이어 수, 노드 수, 의사결정나무의 maxdepth, minbucket, etc.


