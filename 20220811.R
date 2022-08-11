#[ Clustering 군집 분석 ]
#Unsupervised Learning
#데이터를 여러 그룹으로 나누는 목적(각 그룹별 성향 파악)
#거리기반 모델(거리가 가까운 데이터포인트끼리 하나의 그룹 형성)
#이상치/결측치 민감, 스케일링 필요, 중요 변수 선택 중요



#[ 군집분석 종류 ]
#1. 계층적 군집분석
#- 가장 거리가 가까운 데이터포인트끼리
#- 이미 한 군집에 속한 데이터는 다른 군집으로 이동 불가

#2.비계층적 군집분석 (k-means)
#- 거리가 가장 가까운 데이터포인트끼리 하나의 클러스트 형성하되,
#  계속 클러스터의 중심으로부터의 거리를 측정하여 클러스터의 소속 변경
#- 이미 한 군집에 속한 데이터는 다른 군집에 이동될 수 있음



#[ 군집과의 거리 ]
#1) 최단연결법(단일연결법) Single linkage
#   군집내 모든 관측치와의 거리를 계산한 후 그 중 최소

#2) 최장연결법(완전연결법) Complete Linkage
#   군집내 모든 관측치와의 거리를 계산한 후 그 중 최대

#3) 중앙연결법 Centroid Linkage
#   군집내 중심으로부터의 단 하나의 거리

#4) 평균연결법 Average Linkage
#   군집내 모든 관측치와의 거리를 계산한 후 모든 거리의 평균

#5) 와드연결법 Ward Linkage
#   군집 형성 전후의 오차제곱합(편차제곱합)의 증가/감소량으로 측정
#   편차: 평균(중심)과의 거리
#   편차제곱합: 중심으로부터 각 데이터포인트가 흩어진 정도를 측정하는 척도



#[ 계층적 군집분석 ]
v1 <- c(1, 3, 6, 10, 18)
names(v1) <- str_c('p', 1:5)

#step 1) p1, p2가 하나의 클러스터 생성(c1)
#step 2) c1과 나머지 데이터 거리 계산(최단연결법)
#step 3) 위에서 계산한 거리(군집과의 거리)와 
#        나머지 데이터포인트들끼리의 거리 중 가장 작은 거리 확인
#        > c1에 p3이 소속됨
#step 4) 변경된 군집(c1)과 나머지 데이터 거리 계산(최단연결법)
d(c1, p4) = min(d(p1, p4), d(p2, p4), d(p3, p4)) = min(9, 7, 4) = 4
d(c1, p5) = min(d(p1, p5), d(p2, p5), d(p3, p5)) = min(17, 15, 12) = 12


#시각화
#1. 거리행렬 구하기
d1 <- dist(v1)

#2. 군집 분석 수행
m_clust1 <- hclust(d1,                  #거리 행렬
                   method = 'single')   #군집거리 설정 방식
#method
#1) single
#2) complete(default)
#3) centroid
#4) average
#5) ward.D or ward.D2

#3. 시각화
dev.new()
plot(m_clust1,                          #모델명
     hang = -1,                         #데이터포인트 x축 고정
     cex = 0.8)                         #글자 크기

rect.hclust(m_clust1, k = 2)            #군집 구분선
cutree(m_clust1, k = 2)                 #군집에 따른 번호 부여




#[ 적절한 군집의 수 찾기 ]
#분석 전 군집의 수가 정해져있을 수 있음
#덴드로그램 확인(주관적)
#평가 지표로 군집의 수를 정하는 방식(k-mean, 외부 패키지 활용)

install.packages('NbClust')
library(NbClust)

dev.new()
nbc1 <- NbClust(data = iris[, -5],          #군집분석을 수행할 dataset
                min.nc = 2,                 #최소 군집수
                max.nc = 5,                 #최대 군집수 
                method = 'ward.D')          #군집거리




#[ 군집분석에서의 분산 ]
#1. 총분산(total_ss)
#   - 데이터 자체가 갖는 분산
#   - 클러스터링 결과에 영향을 받지 않음(고정)
#   - total_ss = within_ss + between_ss

#2. 그룹 내 분산(within_ss)
#   - 군집 내에서 군집의 중심으로부터 흩어진 정도
#   - 클러스터링 결과가 효율적일수록 작아짐
#   - 군집의 수가 커질수록 within_ss 작아짐
#   - within_ss 감소폭으로 군집의 수 결정

#3. 그룹 간 분산(between_ss)
#   - 각 군집이 전체 중심으로부터 흩어진 정도
#   - 군집분석의 결과가 효율적일수록 between_ss 작아짐




#[ 비계층적 군집분석 ] k-means
kmeans(x,                                   #raw data
       centers = ,                          #군집의 수
       iter.max = 10,                       #중심을 얻기 위한 반복 수
       nstart = 1)                          #초기 중심을 얻기 위한 샘플링 값



#예제) iris datset의 비계층적 군집 분석

m1 <- kmeans(iris[, -5], centers = 3)
m1


m1$cluster
m1$centers
m1$totss                 #681.3706
m1$withinss              #39.82097  15.15100  23.87947
m1$tot.withinss          #78.85144
m1$betweenss             #602.5192




#예제) 군집분석을 이용한 파생변수
#새로운 카테고리 변수를 생성, 기존 데이터에 변수 추가 모델링 비교

#새로운 변수 생성
iris_test <- iris_scale[, 3:4]
d1 <- dist(iris_test)
m_clust2 <- hclust(d1, method = 'ward.D')
x5 <- cutree(m_clust2, k = 3)

#새로운 변수 컬럼 추가
iris2 <- iris
iris2$x5 <- x5

#샘플링
rn <- sample(1:150, size = 150 * 0.7)
iris_train <- iris[rn, ]
iris_test <- iris[-rn, ]

iris2_train <- iris2[rn, ]
iris2_test <- iris2[-rn, ]

#모델 결과 비교
library(rpart)
#1) 기존 결과
m1 <- rpart(Species ~ ., data = iris_train)
vresult <- predict(m1, newdata = iris_test, type = 'class')

sum(vresult == iris_test$Species) / nrow(iris_test) * 100       #91.11111


#2) 변수 추가 결과
m1 <- rpart(Species ~ ., data = iris2_train)
vresult <- predict(m1, newdata = iris2_test, type = 'class')

sum(vresult == iris2_test$Species) / nrow(iris2_test) * 100     #97.77778



