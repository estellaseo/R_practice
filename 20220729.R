#[ profile 관리 ] 
#R 실행 시 자동으로 실행시킬 명령어를 저장할 수 있음
#ex. 라이브러리, 사용 빈도 높은 사용자 함수 등

file.edit('~/.Profile')




#[ 순위 ]
rank(x,                          #순위를 매길 대상: 벡터, (-x: 역순위)
     na.last = T,                #NA 배치 여부
     ties.method = c('average',  #순위 부여 방식(default: average)
                     'first',    #앞 순서 값 우선 순위
                     'last',     #뒷 순서 값 우선 순위
                     'random',   #랜덤
                     'max',      #최대값(공동 순위 중 뒷숫자)
                     'min'))     #최소값(공동 순위 중 앞숫자) - 가장 보편적

rank(c(1, 2, 4, 3, 3, 10))       #[1] 1.0 2.0 5.0 3.5 3.5 6.0 (3rd, 4th 동순위)




#[ 집합연산자 ]
library(dplyr)                   #데이터프레임 집합연산을 위한 라이브러리 로딩
t1 <- iris[1:10, ]
t2 <- iris[1:15, ]
v1 <- c(1, 2, 3, 4)
v2 <- c(1, 2, 3)

#1. 합집합: union (union_all for data.frame)
union(t1, t2)
union_all(t1, t2)

base::union(v1, v2)


#2. 교집합: intersect
intersect(t1, t2)

base::intersect(v1, v2)


#3. 차집합: setdiff
setdiff(t2, t1)

base::setdiff(v1, v2)


#4. 비교: setequal, identical
#두 데이터셋이 동일한지에 대한 여부 확인
setequal(t1, t1)                  #[1] TRUE
setequal(t1, t2)                  #[1] FALSE


v1 <- c(1, 2, 3, 4)
v3 <- c(1, 2, 3, 3, 4)

#벡터 비교
base::setequal(v1, v1)            #[1] TRUE
base::setequal(v1, v3)            #[1] TRUE: 원소 구성만 동일하면 TRUE

identical(v1, v3)                 #[1] FALSE: 완전 동일할 때 TRUE




#[ stack, unstack ]
#테이블(데이터프레임) 구조

#1. long data(tidy data)
#- 속성별로 컬럼 정의
#- DB에 저장되는 형태
#- 그룹 연산, 조인 용이
#- 관리 목적으로 구조 변경 자제
 

#2. wide data(cross table)
#- 나열형
#- 외부 기관 데이터 형식 
#- 그룹 연산, 조인 어려움 
#- 데이터 정렬 및 행별/열별 연산 용이
#- 시각화


#       <wide>
# 지점 2010 2011 2012
#  A    100  101  102
#  B
#  C

#       <long>
# 지점 연도 매출
#  A   2010  100
#  A   2011  101
#  A   2012  102
#  B   2010



#테이블(데이터프레임) 구조 변경
#wide > long: stack, reshape2::melt
library(reshape2)

#1) stack
#- 기본함수
#- 단점: 고정 열 컬럼 지정 불가
stack(x,                          #원본 데이터 
      select,                     #stack 컬럼 전달 및 제외
      drop=FALSE, 
      ...)

m1 <- read.csv('data/melt_ex.csv')
stack(m1)
stack(m1, select = -c(year, mon)) #데이터셋 자체에서 제외


#2) melt
melt(
  data,                           #원본 데이터
  id.vars,                        #고정 컬럼(stack 제외 컬럼)
  measure.vars,                   #stack 처리할 컬럼(id.vars 컬럼 제외)
  variable.name = "variable",     #stack 처리할 col name
  ...,
  na.rm = FALSE,                  #NA values 생략 여부
  value.name = "value",           #새로 생긴 value col의 col name
  factorsAsStrings = TRUE
)


#예시)
m1 <- read.csv('data/melt_ex.csv')
melt(m1, id.vars = c('year', 'mon'),
     variable.name = 'menu',
     value.name = 'qty')


#na.rm argument
m11 <- read.csv('data/melt_ex.csv')
m11[1, 3] <- NA
melt(m11, id.vars = c('year', 'mon'), na.rm = T)




#long > wide: unstack, reshape2::decast


#     <long>
# 지점 연도 매출
#  A   2010  100
#  A   2011  101
#  A   2012  102
#  B   2010  200
#  B   2012  300


#     <wide>
# 지점 2010 2011 2012
#  A    100  101  102
#  B
#  C



#1) unstack
#- 단점: 고정 행 컬럼 지정 불가
require(stats)
formula(PlantGrowth)
unstack(PlantGrowth)


#2) reshape2::dcast()
#notice: 다음 버전부터 data.table::dcast()

dcast(
  data,                            #데이터
  formula,                         #행방향 배치 컬럼명 ~ 열방향 배치 컬럼명
  fun.aggregate = NULL,            #요약함수
  ...,                             #요약함수의 추가 옵션
  margins = NULL,                  #총계 출력 여부
  subset = NULL,                   #dcast 결과 조건 전달
  fill = NULL,                     #NA 대치값
  drop = TRUE,                     #모든 값이 NA인 행 제거 여부
  value.var = guess_value(data)    #value 컬럼명
)


install.packages('googleVis')
library(googleVis)

#예시) cross table
#멀티 컬럼 표현 불가
Fruits
dcast(Fruits, Fruit ~ Year, value.var = 'Sales')
dcast(Fruits, Fruit ~ Year + Location, value.var = 'Sales')
#불가 예시(Available in Python)
dcast(Fruits, Fruit ~ Year + Location, value.var = c('Sales', 'Profit'))


#예제) dcast_ex1.csv 파일을 읽고 교차표 작성
df1 <- read.csv('data/dcast_ex1.csv')
dcast(df1, name ~ info, value.var = 'value')
dcast(df1, name ~ info)


#예제) margins
#지점별 메뉴별 수량 교차표
ex1 <- read.csv('data/dcast_ex3.csv', fileEncoding = 'cp949')
head(ex1)
dcast(ex1, 지점 ~ 이름, value.var = '수량')
#     지점 latte mocha         #각 value 자리에 여러 값이 오는 경우
# 1    A     2     2           #그룹 함수로 요약될 필요가 있음
# 2    B     2     2           #요약함수 생략 시 자동으로 length(count) 계산

#해결방법
dcast(ex1, 지점 ~ 이름, fun.aggregate = sum, value.var = '수량')

#TOTAL 표현
dcast(ex1, 지점 ~ 이름, 
      fun.aggregate = sum, 
      value.var = '수량', 
      margins = T)

dcast(ex1, 지점 ~ 이름, 
      fun.aggregate = mean, 
      value.var = '수량', 
      margins = T)                #fun.aggregate에 따른 연산 결과값  


#예제) fill argument 
ex3 <- read.csv('data/dcast_ex2.csv')
ex3 <- ex3[-6, ]
dcast(ex3, year ~ name, value.var = 'qty', 
      fill = 0)                   #NA 값 0으로 리턴


#예제) subset
dcast(ex2, 월 ~ 이름, value.var = '성취도', subset = .(월 < 3))





#[ 참고 ] 패키지 안에 있는 함수 목록 보기
ls()                              #현재 정의된 변수 목록
ls('package:plyr')                #패키지의 함수 목록
ls('package:base')                #기본 함수 목록

#패키지에 포함되어 있는 함수 찾기 - 이름 일부로 검색하기
f1 <- function(x) {
  vlist <- list('package:base')
  fname <- vlist[str_detect(vlist, x)]
  return(fname)
}



#[ 참고 ] package unload
library(plyr)
detach('package:plyr', unload = T)




