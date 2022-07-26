#[ Matrix: 행렬 ] 
#- 2차원구조
#- 동일한 데이터 타입만 허용(대부분 숫자)

#1. 생성
matrix(data = ,          #데이터
       nrow = ,          #행의 수
       ncol = ,          #열의 수
       byrow = F,        #행 우선순위(진행방향) 여부
       dimnames = )      #행과 열의 이름(리스트로 전달)


m1 <- matrix(1:16, nrow = 4)
m2 <- matrix(seq(1, 160, 10), nrow = 4)
m3 <- matrix(1:16, nrow = 4, byrow = T)
m4 <- matrix(1:9, nrow = 3, byrow = T)



#2. 연산
m1 + m2                  #크기가 같은 행렬끼리 연산 가능
m1 * m2                  #같은 위치에 있는 원소끼리의 곱셈
m1 %*% m2                #행렬곱
m1 + m4                  #크기가 다른 행렬끼리 연산 불가



#3. 색인
m1[, 1]
m1[1, ]                  #차원 축소(1차원 벡터 타입 리턴)
m1[, 1, drop = F]        #차원 유지



#4. 구조변경
rownames(m1) <- c('a', 'b', 'c', 'd')
colnames(m1) <- c('A', 'B', 'C', 'D')
m1['a', 'A']             #이름 설정 후 이름으로 색인 가능

dimnames(m1)             #행과 열의 이름을 리스트로 함께 출력
dimnames(m2) <- list(c('a', 'b', 'c', 'd'), c('A', 'B', 'C', 'D'))



#5. 행과 열의 추가
cbind(m1, E = 17:20)     #열 추가(column bind)
rbind(m1, e = 100:103)   #행 추가(row bind)




#[ Array: 배열 ] 
#- 다차원
#- 동일한 데이터 타입만 허용

#1. 생성
array(data = ,           #데이터
      dim = ,            #차원 크기
      dimnames = )       #차원 이름(행, 열, 층)

a1 <- array(1:60, dim = c(3, 4, 5))



#2. 색인
a1[, , 1]                #1층 선택 <- 차원 축소 발생
a1[, , 1, drop = F]      #1층 선택 <- 차원 유지)




#[ 사용자 정의 함수 ]
#사용자가 직접 정의하는 함수
#출력값은 하나의 객체, 여러개일 경우 이를 return에서 하나로 묶어서 출력

함수명 <- function(인수) {
  함수본문
  return(리턴객체)
}

f1 <- function(x) {
  as.numeric(str_remove(x, ','))
}
f1('25,000')


f2 <- function(x, sep = ',') {
  as.numeric(str_remove(x, sep))
}
f2('25,000')


#1) 단일 인수에 대한 함수 정의
f1 <- function(x) {
  x + 3
}

f1(100)                        #return 생략 가능

f1 <- function(x) {
  return(x + 3)
}


#if문을 포함하는 사용자 정의 함수
f2 <- function(x) {
  if (x > 10) {
    return('A')
  } else {
    return('B')
  }
}


#2) 다중 인수에 대한 함수 정의
f3 <- function(x, y, z) {
  x + y + z
}

f3(1, 10, 100)                #순서대로 전달


#각 인수의 기본값 설정 
f3 <- function(x, y, z = 0) {
  x + y + z
}

f3(1, 100)


#함수 안에 for문을 갖는 경우
f4 <- function(x) {
  if (x > 10) {
    'A'
  } else {
    'B'
  }
}                           #f4는 벡터 연산 불가


#해결방법 1) scalar input + sapply function
sapply(c(10, 1), f4)


# 2) vertor input
f4 <- function(x) {
  v1 <- c()
  for (i in x) {
    if (i > 10) {
      v1 <- c(v1, 'A')
    } else {
      v1 <- c(v1, 'B')
    }
  }
  return(v1)
}

f4(c(10, 1))



#[ apply 계열 함수 ]
#- 반복을 도와주는 함수
#- 원소별 반복, 행별 반복, 컬럼별 반복, 그룹별 반복
#- 함수 일괄 적용을 위한 문법(for문 대체)
#- apply, sapply, lapply, tapply, mapply :총 다섯가지


#1. apply
#- 행별, 컬럼별 반복
#- 원소별 반복

apply(X,                 #데이터(2차원)
      MARGIN = ,         #반복방향(1: 행별, 2: 컬럼별, c(1, 2): 원소별)
      FUN,               #적용 함수(단 하나의 객체로 정의된 함수 전달)
      ...)               #함수의 추가 인수 나열(ex. na.rm = T)

rowSums(m1)
rowMeans((m1))
colSums(m1)
colMeans(m1)

apply(m1, 1, sum)        #행별 합(rowSums와 동일)
apply(m1, 2, sum)        #컬럼별 합(colSums와 동일)

m1[1, 1] <- NA
apply(m1, 1, sum, na.rm = T)



#2. sapply
#- 벡터의 원소별 반복
#- 주로 벡터 리턴

sapply(X,                 #데이터(1차원)
       FUN,               #적용함수
       ...)               #적용함수의 추가 인수



#예시) 아래 벡터에서 ','로 분리된 두 번째 문자열 추출
v1 <- c('a,b,c', 'AA,BB,CC')

# for문
v2 <- c()
for (i in v1) {
  v2<- c(v2, str_split(i, ',')[[1]][2])
}

#sapply
f_split <- function(x) {
  str_split(x, ',')[[1]][2]
}
sapply(v1, f_split)

apply(v1, c(1, 2), f_split)  #벡터(1차원)은 apply 함수 전달 불가



m1 <- matrix(c('a,b,c', 'AA,BB,CC', 'de,fg,hi', 'er,erm,er'), nrow = 2)

sapply(m1, f_split)
apply(m1, c(1, 2), f_split)



#3. lapply
#- 1차원의 원소별 fetch
#- 주로 리스트 리턴
lapply(exam$STUDNO, f_hakjum)        #결과 리스트 리턴



#4. tapply
#- 그룹 연산 
#- 하나의 대상에 대한 그룹 연산 가능
#- 하나의 그룹핑 컬럼만 가능
#- 하나의 연산 함수 가능
#- 결과 벡터 리턴 

tapply(X,                           #연산 대상
       INDEX,                       #그룹핑 대상
       FUN = NULL, 
       ...)


#예시) 부서별 평균 급여
tapply(emp$SAL, emp$DEPTNO, mean)



#5. mapply
#- 여러 대상에 함수를 적용

mapply(FUN, 
       ...)
       
       
#예시) 두 벡터에 대해 같은 위치에 있는 원소의 합 출력
v1 <- 1:10
v2 <- seq(10, 100, 10)

f_sum <- function(x, y) {
  x + y
}

mapply(f_sum, v1, v2)               #v1, v2 각각 fetch 가능 




#[ sqldf 패키지 ]
#R에서 SQL 문법을 사용하여 처리 가능함

install.packages('sqldf')
library(sqldf)

emp <- read.csv('data/emp.csv')
vsql1 <- 'select ename, deptno
            from emp 
           where deptno = 10'

sqldf(vsql1)



#예시) std에서 김주현 학생의 이름, 학년 출력
vsql3 <- 'select name, grade 
            from std
           where name = \'김주현\''

vsql3 <- "select name, grade 
            from std
           where name = '김주현'"

sqldf(vsql3)



#예시) std, pro 지도학생, 지도교수 이름
std <- read.csv('data/student.csv', fileEncoding = 'cp949')
pro <- read.csv('data/professor.csv', fileEncoding = 'cp949')

vsql4 <- "select s.name, p.name 
            from std s left outer join pro p
              on s.profno = p.profno"           #ANSI 표준(오라클 표준 X)

sqldf(vsql4)


