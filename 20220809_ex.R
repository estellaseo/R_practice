#[ 연습 문제 ] 매개변수 튜닝
#maxdepth: 2 ~ 15 변화에 따른 train, test score 확인
vscore_tr = c(); vscore_te = c()
for (i in 2:15) {
  m1 = rpart(Species ~. , data = iris_train, maxdepth = i)
  vresult1 <- predict(m1, newdata = iris_train, type = 'class')
  vresult2 <- predict(m1, newdata = iris_test, type = 'class')
  
  vscore_tr <- c(vscore_tr, 
                 sum(vresult1 == iris_train$Species) / nrow(iris_train) * 100)
  vscore_te <- c(vscore_te, 
                 sum(vresult2 == iris_test$Species) / nrow(iris_test) * 100)
}

dev.new()
plot(2:15, vscore_tr, type = 'o', col = 'red', ylim = c(85, 100),
     xlab = 'maxdepth', ylab = 'score')
lines(2:15, vscore_te, type = 'o', col = 'blue')



#[ 연습 문제 ]
cancer <- read.csv('data/cancer.csv')
head(cancer)
ncol(cancer)

#샘플링
rn <- sample(1:nrow(cancer), size = nrow(cancer) * 0.7)
cancer_train <- cancer[rn, -1]
cancer_test <- cancer[-rn, -1]

#모델링
m4 <- rpart(diagnosis ~. , data = cancer_train)

#평가
cancer_result1 <- predict(m4, newdata = cancer_train, type = 'class')
cancer_result2 <- predict(m4, newdata = cancer_test, type = 'class')

#예측점수
sum(cancer_result1 == cancer_train$diagnosis) / nrow(cancer_train) * 100 #91.81
sum(cancer_result2 == cancer_test$diagnosis) / nrow(cancer_test) * 100   #96.98

#튜닝
m5 <- rpart(diagnosis ~. , data = cancer_train, minbucket = 2)

dev.new()
library(rpart.plot)
prp(m5, type = 4, extra = 3)

cancer_result3 <- predict(m5, newdata = cancer_train, type = 'class')
cancer_result4 <- predict(m5, newdata = cancer_test, type = 'class')

sum(cancer_result3 == cancer_train$diagnosis) / nrow(cancer_train) * 100 #98.49
sum(cancer_result4 == cancer_test$diagnosis) / nrow(cancer_test) * 100   #93.57



#[ 실습 문제 ]
# 1. ex_test1.csv 파일을 읽고
ex1 <- read.csv('data/ex_test1.csv', fileEncoding = 'cp949')
head(ex1)

# 1) 각 구매마다의 포인트를 확인하고 point 컬럼 생성
#    point는 주문금액 50000 미만 1%, 5만 이상 10만 미만 2%, 10만 이상 3%

point <- c()
for (i in ex1$주문금액){
  if (i < 50000) {
    point <- c(point, i * 0.01)
  } else if (i < 100000) {
    point <- c(point, i * 0.02)
  } else {
    point <- c(point, i * 0.03)
  }
}

ex1$point  <- point

# 2) 회원번호별 총 주문금액과 총 포인트 금액 확인
library(plyr)
ex1_d <- ddply(ex1, .(회원번호), summarise, 
               총주문금액 = sum(주문금액), 총포인트 = sum(point))

# 3) 회원별 주문금액을 확인하고 총 주문금액 기준 상위 30%의 회원 확인
ex1_d[rank(ex1_d$총주문금액, ties.method = 'min'), ][1:abs(nrow(ex1_d)*0.3), ]



# 2. center_grade.csv 파일에는 특정 센터의 연도별 월별 평가 등급이 저장되어 있다.
# 각 평가 등급별로 점수가 다음과 같이 부여된다고 했을 때
# (a등급 : 100, b등급: 110, .... 알파벳 순으로 10점씩 높은 점수가 부여)
ex2 <- read.csv('data/center_grade.csv', fileEncoding = 'cp949')
head(ex2)

getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}
getmode(c(1,1,1,1,2,3))    # 최빈값 확인


# 1) 중복 제거한 값이 몇 개인지 확인(unique value)
library(reshape2)
ex2_m <- melt(ex2, id.vars = '월', variable.name = '년도', value.name = '등급')
ex2_m$년도 <- as.numeric(str_sub(ex2_m$년도, 2, 5))
head(ex2_m)

length(unique(ex2_m$등급))

# 2) 결측치는 전체 데이터의 최빈값으로 대치
library(stringr)

ex2_m$등급[str_detect(ex2_m$등급, '\\.')] <- getmode(ex2_m$등급)
ex2[sapply(ex2, str_detect, '\\.')] <- getmode(ex2_m$등급)


# 3) 점수가 가장 낮은 연도와 점수가 가장 높은 연도의 두 점수의 차이를 출력
#    (연도별 총합 기준)
colnames(ex2)[-1] <- str_sub(colnames(ex2)[-1], 2, 5)
ex2

bogi <- unique(ex2_m$등급)[order(unique(ex2_m$등급))]

f_score <- function(x) {
  vscore <- c()
  for (i in x) {
    vscore <- c(vscore, 100 + (which(bogi == i) - 1) * 10)
  }
  return(sum(vscore))
}
f_score(ex2$`2000`)


# 4) 센터의 최종 점수를 출력(전체 총합 )
