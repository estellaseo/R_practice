#[ 반복문 ]
#여러 대상에 대해 동시에 연산을 할 수 없을 경우 하나씩 연산하게 하는 행위
#fetch(여러 대상에서 하나씩 리턴) 기능 수행
#동일한 작업을 여러번 수행할 때


#1. for문
for (반복변수 in 대상) {
  반복문장
}


v1 <- c(1, 2, 3, 4, 10)
v1 + 1                    #벡터 연산 가능

if (v1 < 3) {             #불가
  'A'
} else {
  'B'
}

v2 <- c()                 #빈 벡터 선언 필수
for (i in v1) {           #fetch된 단 하나의 값에 대한 if문 연산 수행
  if (i < 3) {             
    v2 <- c(v2, 'A')
  } else {
    v2 <- c(v2, 'B')
  }
}
v2                        #for문에 의해 생성된 객체


#예시)
vresult <- c()
for (i in emp$DEPTNO) {
  if (i == 10) {
    vresult <- c(vresult, '인사부')
  } else if (i == 20) {
    vresult <- c(vresult, '재무부')
  } else {
    vresult <- c(vresult, '데이터분석부')
  }
}


#1) 위치 기반
v <- c()
for (i in 1:nrow(prof)) {
  vid <- c(vid, str_split(prof$EMAIL, '@')[[i]][1])
}
prof$EMAIL_ID <- vid


#2) 객체 기반
v <- c()
for (i in prof$EMAIL) {
  vid <- c(vid, str_split(i, '@')[[1]][1])
}
prof$EMAIL_ID <-vid


#3) for문에서 직접 컬럼 추가 
#- not recommended(not available in Python)
for (i in 1:nrow(prof)) {
  prof$EMAIL_ID[i] <- str_split(prof$EMAIL, '@')[[i]][1]
}



#[ NA와 NULL의 차이 ]

#1. NA
#- 결측치 표현 방식(들어오지 않은 값, 잘못 계산된 값)
#- 자리를 차지함(length에 포함됨)

v1 <- c(1, 2, 3, NA, 4)
length(v1)                  #[1] 5

#2. NULL
#- 없는 대상(객체 삭제)
#- 자리를 차지하지 않음(length X)

v2 <- c(1, 2, 3, NULL, 4)
length(v2)                  #[1] 4

v3 <- 1:5
v3[4] <- NULL               #v3[4] 제거 불가: replacement has length zero
v3 <- v3[-4]                #벡터 재생성: 삭제가 된 것처럼 처리 가능


emp$EMPNO <- NULL           #컬럼(key) 삭제 가능



#[ 형 확인 함수 ]
is.character(v3) 
is.na(v3 )                  #원소 각각 NA 유무 여부 확인
is.null(emp$ENAME2)         #객체 유무 여부 확인



#2. while문
#조건 기반으로 반복문 수행(조건이 TRUE일 때)
while (조건) {
  반복문장
}


#예시) 1~100 누적합/누적곱
#1) for문
vsum <- 0
for (i in 1:100) {
  vsum <- vsum + i
}

vmultiple <- 1
for (i in 1:100) {
  vmultiple <- vmultiple * i
}


#2) while문
vsum <- 0                   #시작 대상에 대한 정의 필수
j <- 1
while (j <= 100) {
  vsum <- vsum + j
  j <- j + 1                #next value에 대한 선언 필요
}
vsum

