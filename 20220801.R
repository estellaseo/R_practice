#[ 참고 ]
#함수 내부에 패키지 안의 다른 함수를 호출할 경우 패키지 로딩 필수 

#예시)
#summarise, subset 함수 사용 불가
plyr::ddply(emp, .(DEPTNO), summarise, v1 = mean(SAL))



#[ Package dplyr ]
#구조화된 문법 제공(SQL과 유사함)
#다양한 함수 포함

#in SQL
# select
#   from 
#  where
#  group by 
# having 
#  order by


#1) select: 컬럼 선택
#2) filter: 조건 색인(행 선택)
#3) mutate: 연산 
#4) group_by: 그룹 분리
#5) arrange: 정렬 
#6) summarise: 그룹 연산 



library(dplyr)
#1. 데이터 선택하기 (컬럼)
emp <- read.csv('data/emp.csv')

emp %>%
  select(EMPNO, ENAME)

emp %>%
  select(-JOB)                     #언급 컬럼 제외(컬럼명에 '-' 사용 가능)

emp %>%
  select(HIREDATE, everything())   #언급 컬럼 제일 앞에 배치

emp %>%
  select(JOB:SAL)                  #연속 컬럼 컬럼명으로 선택



#2. 연산하기
emp %>%
  select(EMPNO, SAL * 1.1)         #select에서 연산 불가

emp %>%
  mutate(NEW_SAL = SAL * 1.1) %>%  #select에서 new col 선택의 경우 순서 중요
  select(EMPNO, SAL, NEW_SAL)      #mutate -> select



#3. 필터링(데이터의 행선택 -> 조건 선택)
emp %>%
  filter(DEPTNO == 10)

emp %>%
  select(EMPNO, ENAME, SAL) %>%
  mutate(NEW_SAL = SAL * 1.1) %>%
  filter(NEW_SAL >= 3000)



#4. 정렬
emp%>%
  arrange(DEPTNO, desc(SAL))



#5. 그룹핑
emp%>%  
  group_by(DEPTNO) %>%
  dplyr::summarise(SAL_MEAN = mean(SAL), SAL_MAX = max(SAL))

emp %>%
  group_by(DEPTNO) %>%
  dplyr::summarise(SAL_MEAN = mean(SAL), COMM_MEAN = mean(COMM, na.rm = T))



#주의: dplyr, plyr 동시 로딩 시 그룹연산이 전체 그룹핑이 리턴될 수 있음
emp %>%
  group_by(DEPTNO) %>%
  plyr::summarise(SAL_MEAN = mean(SAL), SAL_MAX = max(SAL))





#[ 참고 ] sql 연산자
#1. in
#기본 표현식
v1 <- c('a', 'b', 'c', 'd')
v1[v1 %in% c('a')]

#2. DescTools::like
library(DescTools)
v1 <- c('aa', 'ab', 'c', 'd')
v1[v1 %like% 'a%']

#3. dplyr::between(x, left, right)
library(dplyr)
v2 <- 1:10
v2[between(v2, 2, 5)]




