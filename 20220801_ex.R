#[ 연습 문제 ] dcast
#상반기사원별월별실적현황_new.csv 파일을 읽고
ex2 <- read.csv('data/상반기사원별월별실적현황_new.csv', fileEncoding = 'cp949')
head(ex2)

#성취도에 대한 사원별 월별 교차표 출력 
dcast(ex2, 이름 ~ 월, value.var = '성취도', 
      fun.aggregate = mean, 
      margins = T)



#[ 연습 문제 ] dcast
#subway2.csv 파일을 읽고
sub1 <- read.csv('data/subway2.csv', fileEncoding = 'cp949', skip = 1)
head(sub1)

#컬럼 정리
sub1$전체[seq(2, nrow(sub1), 2)] <- sub1$전체[seq(1, nrow(sub1), 2)] 
sub1$총합 <- rowSums(sub1[, -c(1,2)])

#컬럼 정리 case 2
sub1$전체[sub1$전체 == ''] <- NA

library(zoo)
sub1$전체 <- na.locf(sub1$전체)


#역별 승차, 하차 총합 교차표 작성
dcast(sub1, 전체 ~ 구분, value.var = '총합')




#[ 연습 문제 ] dplyr
#student.csv 파일을 읽고
stud <- read.csv('data/student.csv', fileEncoding = 'cp949')
head(stud)

#각 1, 2학년 학생의 이름, 학년, 성별, 키 출력
#단, 성별 키 순서대로 정렬(키는 높은 순)
stud %>%
  filter(GRADE %in% c(1, 2)) %>%
  mutate(GENDER = ifelse(str_sub(JUMIN, 7, 7) == 1, 'M', 'F')) %>%
  select(NAME, GRADE, GENDER, HEIGHT) %>%
  arrange(desc(GENDER), desc(HEIGHT))




#[ 연습 문제 ]
#multi_index_ex2.csv 파일을 읽고
test1<- read.csv('data/multi_index_ex2.csv', fileEncoding = 'cp949')
head(test1)

#컬럼정리
colnames(test1)[str_detect(colnames(test1), 'X.')] <- NA
library(zoo)
colnames(test1) <- na.locf(colnames(test1))
colnames(test1) <- str_c(colnames(test1), test1[1, ], sep = '_')
test1 <- test1[-1, ]

#stack
library(reshape2)
test1_s <- melt(test1, id.vars = 'X_', variable.name = '지역_요일')

#컬럼 분리
test1_s$월 <- as.numeric(str_sub(test1_s$X_, 1, 1))
test1_s$지점 <- str_sub(test1_s$X_, 3)
test1_s$지역 <- str_sub(test1_s$지역_요일, 1, 2)
test1_s$요일 <- str_sub(test1_s$지역_요일, 4)
test1_s$X_ <- NULL
head(test1_s)

#숫자형 변환 
test1_s$value[str_detect(test1_s$value, '\\D')] <- NA
test1_s$value <- as.numeric(test1_s$value)
head(test1_s)

#1) 월별 지역별 매출 총합 출력
library(plyr)
ddply(test1_s, .(월, 지역), summarise, 총합 = sum(value, na.rm = T))

#2) 지점별 매출이 가장 많은 지역
test1_t <- ddply(test1_s, .(지점, 지역), summarise, 
                 총합 = sum(value, na.rm = T))
ddply(test1_t, .(지점), subset, 총합 == max(총합))




#[ 실전 문제 ]
CUST <- read.csv('data/고객.csv', fileEncoding = 'cp949')
nrow(CUST)     # 10000
head(CUST)

PUSH <- read.csv('data/전일문자발송.csv', fileEncoding = 'cp949')
nrow(PUSH)     # 535282
head(PUSH)

ORD <- read.csv('data/주문정보.csv', fileEncoding = 'cp949')
nrow(ORD)      # 169348
head(ORD)



#[ 참고 ] 복사한 데이터 불러오기
c1 <- read.csv('clipboard', header = F)



# 1. 오늘은 2019년 6월 19일입니다. 
# 아래 조건에 맞는 회원번호를 추출하는 R코드를 작성하세요.			

# (1) [고객정보]의 고객 중 최근 구매가 10~20일 없었던 고객을 고른 후, 
to_day <- as.Date('2019-06-19')
CUST$GAP <- as.numeric(to_day - as.Date(CUST$최종구매일))

library(dplyr)
CUST_f <- CUST[between(CUST$GAP, 10, 20), ]

# 2018년 7월 1일 이전 첫구매 고객은 [5%]할인쿠폰, 
# 그 이후 첫구매 고객은 [7%]할인쿠폰을 지급하려고 합니다. 																							
# 각각을 추출하는 코드를 쓰시오																						

# [5%]할인쿠폰대상자
CUST_f[as.Date(CUST_f$첫구매일) < as.Date('2018/07/01'), '회원번호']

#Using dplyr package
CUST %>%
  mutate(GAP2 = as.numeric(to_day - as.Date(최종구매일))) %>%
  filter(between(GAP2, 10, 20)) %>%
  filter(as.Date(첫구매일) < as.Date('2018/07/01')) %>%
  select(회원번호)


# [7%]할인쿠폰대상자			
CUST_f[as.Date(CUST_f$첫구매일) >= as.Date('2018/07/01'), '회원번호']

#Using dplyr package
CUST %>%
  mutate(GAP2 = as.numeric(to_day - as.Date(최종구매일))) %>%
  filter(between(GAP2, 10, 20)) %>%
  filter(as.Date(첫구매일) >= as.Date('2018/07/01')) %>%
  select(회원번호)




# (2) [고객정보]의 고객 중 평균주문금액이 40000원 미만인 고객 중 
# 멤버쉽가입과 신규멤버쉽가입이 모두 N인 고객을 고른 후, 
# 전일문자발송자는 제외하려고 합니다. 해당 회원번호를 추출하는 코드를 쓰시오
con2 <- as.numeric(CUST$평균주문금액) < 40000
con3 <- (CUST$멤버쉽가입 == 'N') & (CUST$신규멤버쉽가입 == 'N')
CUST_m <- CUST[con2 & con3, ]

CUST_m2 <- CUST_m[!(CUST_m$회원번호 %in% PUSH$회원번호), '회원번호']
length(CUST_m2)


#Using dplyr package
CUST %>%
  filter(as.numeric(평균주문금액) < 40000) %>%
  filter(멤버쉽가입 == 'N') %>%
  filter(신규멤버쉽가입 == 'N') %>%
  filter(!(CUST_m$회원번호 %in% PUSH$회원번호)) %>%
  select(회원번호)
 



# 2. [주문정보]의 데이터로 분석해볼 때, 
# 개인의 5월 주문금액이 4월 주문금액 대비 50% 미만으로 감소한 고객의 
# 회원번호를 추출하는 코드를 쓰시오				
library(stringr)
ORD$주문월 <- as.numeric(str_sub(ORD$주문일, 6, 7))
ORD_m <- ddply(ORD, .(회원번호, 주문월), summarise, 주문총액 = sum(주문금액))
ORD_m45 <- ORD_m[ORD_m$주문월 %in% c('04', '05'), ]
head(ORD_m)
head(ORD_m45)
nrow(ORD_m45)


culist <- c()
for (i in 1:(nrow(ORD_m45)-1)) {
  if (ORD_m45$회원번호[i] == ORD_m45$회원번호[i+1] &
      ORD_m45$주문총액[i+1] / ORD_m45$주문총액[i] < 0.5) {
    culist <- c(culist, ORD_m45$회원번호[i])
  } else {
    next
  }
}
length(culist)

library(data.table)
library(plyr)
ddply(ORD_m, .(회원번호), transform, 이전월 = shift(주문총액))
ORD_m5 <- ORD_m[ORD_m$주문월 == '05', ]
ORD_m5[ORD_m5$주문총액 < ORD_m5$이전월 * 0.5, '회원번호']




#Using dplyr package 
ORD %>%
  mutate(주문월 = str_sub(ORD$주문일, 6, 7)) %>%
  group_by(회원번호, 주문월) %>%
  dplyr::summarise(TOTAL = sum(주문금액, na.rm = T)) %>%
  filter(주문월 %in% c('04', '05')) %>%
  mutate(다음달 = data.table::shift(TOTAL, type = 'lead')) %>%
  filter(다음달/TOTAL < 0.5)


ORD %>%
  mutate(주문월 = str_sub(ORD$주문일, 6, 7)) %>%
  group_by(회원번호, 주문월) %>%
  dplyr::summarise(TOTAL = sum(주문금액, na.rm = T)) %>%
  mutate(이전월 = lag(TOTAL)) %>%
  filter(주문월 == '05') %>%
  filter(TOTAL < 이전월 * 0.5) %>%
  select(회원번호)


