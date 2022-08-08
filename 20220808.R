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
#- 통계적 평가 장치가 없음()


#예제) iris data 붓꽃의 품종 분류 (DT)

#1. 시각화
dev.new()

plot(iris[, -5], col = iris$Species)    #산점도 
#=> Patal과 관련된 컬럼들이 분류에 더 큰 역향을 미칠 수 있음




#2. 모델링
install.packages('rpart')
library(rpart)

rpart(formnula = ,               #Y ~ X
      data = )                   #데이터 프레임

m1 <- rpart(Species ~ . , data = iris)
m1


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



test_data <- data.frame(Sepal.Length = 5, 
                        Sepal.Width = 2.8,
                        Petal.Length = 5.3,
                        Petal.Width = 2.2)



#3. 평가
vresult <- predict(m1, newdata = iris, type = 'class')
sum(vresult == iris$Species) / nrow(iris) * 100




#4. 예측
#클래스별 예상 확률
predict(m1, newdata = test_data)

#예측값(예상 클래스) 
predict(m1, newdata = test_data, type = 'class')



