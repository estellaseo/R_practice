#[ unlist function ] 
#벡터로 형변환
l1 <- list(a1 = 1:3, a2 = c('a', 'b', 'c'))
emp <- read.csv('data/emp.csv')

v1 <- emp[ ,1, drop = F]       #data frame 형태
mean(v1)                       #연산 불가
mean(as.verctor(v1))
mean(unlist(v1))               #벡터로 변경 가능
unlist(l1)




#[ merge function]
#- default: inner join
#- outer join 가능
#- non-equi join 불가
#- 3개 이상의 대상 조인 불가
#- natural join 기본 

merge(x,                       #조인대상 1
      y,                       #조인대상 2
      by =                     #공통 컬럼명(default: natural join) 
      by.x = by,               #대상 1 조인 컬럼
      by.y = by,               #대상 2 조인 컬럼
      all = FALSE,             #Full outer join  
      all.x = all,             #Left outer join
      all.y = all,             #Right outer join
      sort = TRUE, 
      suffixes = c(".x",".y"), #동일 컬럼명 식별자
      ...)


#예시) emp, dept 조인하여 각 직원 이름, 부서명 출력
emp <- read.csv('data/emp.csv')
dept <- read.csv('data/dept.csv')

merge(emp, dept)            #col1: 조인 컬럼명
merge(emp, dept, by = 'DEPTNO')[, c('ENAME', 'DNAME')]




#[ Group 연산]
#- 그룹별 적용(분리 - 적용 - 결합)

#1. aggregate
aggregate(x,                #연산 대상(vector, data frame 가능)
          by,               #그룹핑 컬럼(리스트 전달)
          FUN,              #그룹함수
          ...)              #그룹함수의 추가 옵션


aggregate(x,                #formula(연산대상 ~ 그룹핑 대상)
          data,             #전체데이터(data frame)
          FUN,              #그룹함수
          ...)              #그룹함수의 추가 옵션


#Case 1) 하나의 연산대상, 하나의 그룹핑 컬럼
#- emp에서 부서별 평균 급여 출력

#1)
df1 <- aggregate(emp$SAL, list(emp$DEPTNO), mean)
colnames(df1) <- c('DEPTNO', 'MEAN_SAL')

#2)
aggregate(SAL ~ DEPTNO, emp, mean)



#Case 2) 여러 연산대상, 하나의 그룹핑 컬럼
#- student에서 학년별 평균 키, 평균 몸무게

#1)
aggregate(stud[, c('HEIGHT', 'WEIGHT')], list(stud$GRADE), mean)

#2)
aggregate(cbind(HEIGHT, WEIGHT) ~ GRADE, stud, mean)



#Case 3) 하나의 연산대상, 여러 그룹핑 컬럼
#- 학년별, 학과별(deptno1) 키 평균 

#1)
aggregate(stud$HEIGHT, list(stud$GRADE, stud$DEPTNO1), mean)

#2)
aggregate(HEIGHT ~ GRADE + DEPTNO1, stud, mean)



#[ 참고 ] NA 함수
na.action()
na.exclude()               #NA값 제거
na.fail()                  #NA값일 경우 중지
na.omit()                  #NA값 제거
na.pass()                  #NA값 스킵




#2. ddply**
install.packages('plyr')
library(plyr)
help(ddply)


ddply(             
  .data,                   #데이터(데이터프레임)
  .variables,              #그룹핑컬럼
  .fun = NULL,             #내부함수
  ...)                     #연산대상, 연산함수(max(SAL, na.rm = T))



#ddply 내부함수
# 1) summarise: 그룹핑 후 요약하여 하나의 값 출력(group by in SQL)
# 2) transform: 기존 데이터 형식에 연산 결과를 추가하여 리턴
# 3) mutate: 기존 데이터 형식 유지하여 연산 결과 리턴
# 4) subset


#예시) emp 부서별 최고 연봉 
#1) 요약 형태로 리턴
ddply(emp, .(DEPTNO), summarise, MAX_SAL = max(SAL))
#2) 전체 데이터 형태로 리턴
ddply(emp, .(DEPTNO), transform, MAX_SAL = max(SAL))
ddply(emp, .(DEPTNO), mutate, MAX_SAL = max(SAL)) 
#mutate: 연산 순차적 진행, 따라서 앞 연산 결과 재사용 가능

#예) 부서별 최대 연봉자 출력
ddply(emp, .(DEPTNO), subset, SAL == max(SAL))
#예) 부서별 평균 연봉보다 높은 연봉을 받는 사람 출력
ddply(emp, .(DEPTNO), subset, SAL > mean(SAL))



#여러 그룹핑 컬럼
#예시) 부서별, 직무별 평균 연봉 
ddply(emp, .(DEPTNO, JOB), subset, SAL = mean(SAL))

#여러 연산 대상, 여러 함수
ddply(emp, .(DEPTNO), summarise, MEAN_SAL = mean(SAL), 
                                 MAX_SAL = max(SAL),
                                 MEAN_COMM = mean(COMM, na.rm = T))
      
      