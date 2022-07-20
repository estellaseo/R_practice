#[ 참고 ] - 객체(변수) 삭제
#현재 정의된 변수 확인
ls()
objects()

#변수 삭제
rm(a1)
rm(list = ls())      #전체 변수 삭제



#[ 기타 연산자 ]
trunc(7/3)           #몫
7 %/% 3              #몫
7 %% 3               #나머지

2^4                  #거듭제곱
2**4                 #거듭제곱곱

1e1               # 10
1e1^13            # 10^13



#[ 숫자 함수 ]
#na.rm = T
min
max
mean
sum
count                #없음(dplyr 패키지 로딩 후 사용 가능)
length               #count 대신 사용
sqrt                 #루트

var(1:10)            #분산
sd                   #표준편차

log(5)
log2(5)

exp(10)              #e^10



#[ 가변형 인수 전달 방식 ] 
#... : 여러 인수를 허용하는 인수 전달 방식
sum(1, 10)          #sum(..., na.rm) 11
mean(c(1, 10))      #mean(x, ...)



#[ 조건문 ]
#조건별 치환, 연산 리턴

#< if문 > 
if (test) {
  yes
} else {
  no
}

#예시)
v1 <- 10
if (v1 %% 2 == 0) {
  '짝수'
} else {
  '홀수'
}

#응용) 전 직원의 급여 등급
if (emp$SAL >= 3000) {         #length error 발생(벡터 연산 불가)
  'A'                          #if문의 조건에 여러 결과를 동시에 전달 불가
} else {                       #가능하게 하기 위해 반복문 활용
  'B'
}


#두번째 조건
if (condition1) {
  yes for con1
} else if (condition2) {
  yes for con2, no for con1
} else {
  no for con1 and con2
}
  


#< ifelse 함수 >
#벡터 연산 가능
ifelse(test,    #조건
       yes,     #참일 때 리턴
       no)      #거짓일 때 리턴(생략 불가가)

#예시
ifelse(v1 %% 2 == 0, '짝수', '홀수')

#응용) 전 직원의 급여 등급
ifelse(emp$SAL >= 3000, 'A', 'B')



#[ 행 이름 변경 ]
rownames(df1) <-df1$date
df1$date <- NULL 
