#설치: 외부 패키지의 경우 최초 1회 설치
install.packages('rJava')

#로딩: 외부 패키지의 경우 매 세션마다 로딩 후 작업
library(rJava)



getwd() # 별도의 명령어 없이 파일 불러올 수 있음
setwd('C:/Users/itwill/Documents') # 현재 세션에서만 유효함


#작업 directory 변경 방법: tools - global options


df1 <- read.csv('emp.csv') # 로딩 가능
sum(df1$SAL)


#[ 변수 ] - 상수나 명령어의 결과를 저장하기 위한 객체(이름 부여)
#변수 명명규칙 - 숫자 시작 불가, 예약어 사용 불가, 
#                특수기호 사용 자제(_ 가능), 한 자리의 변수 자제


#1. 생성
a1 <- 1
a1 + 3

a2 <- 'abcd'           #문자열: '', ""로 전달
a3 <- '2022/07/14'     #날짜가 아닌 문자로 인식
a4 <- Sys.Date()


#2. 변수 타입 확인
class(a1)
class(a2)
class(a3)
class(a4)


#3. 산술 연산
a1 + 100
a5 <- '10'
a1+a5   #연산 에러(문자와 숫자 연산불가, 묵시적 형 변환 불가)


#4. 형변환 함수
#1) as.Date() : 날짜로 파싱
a3 <- as.Date(a3)       #포맷 생략 가능
class(a3)               #날짜 타입
as.Date('07/14/2022')   #년월일 순서가 아닌 경우 자동 파싱 불가(포맷 전달 필수)
as.Date('07/14/2022', '%m/%d/%Y') # 포맷 전달로 파싱 가능

help(as.Date)

#참고 - 날짜 포맷 확인 방법
help("strftime")

#strftime: time -> str(f: format)
#strptime: str -> time(p: parsing)

# %Y: 4자 연도, %y: 2자 년도, %H: 시, %M: 분, %S: 초, 
# %w: 요일(숫자, 0: 일요일), %A: 요일(문자) 


#2) as.character() : 문자가 아닌 값을 문자로 변경
as.character(a3, '%A')       #a3 날짜의 요일
as.character(a3, '%w')
as.character(a3, '%y/%m/%d') #문자형 리턴


#3) as.numeric() : 문자를 숫자로 변경
a1 + as.numeric(a5)  #연산 가능


#오늘의 날짜 출력
Sys.Date()        #오늘 날짜(시간 출력 X)
Sys.time()        #오늘 날짜(시간 출력 O)



#[ 참고 ] 두 자리 연도 해석
as.Date('70/12/11', '%y/%m/%d')   #"1970-12-11"
as.Date('68/12/11', '%y/%m/%d')   #"1970-12-11"

#20XX: 00년~68년 (ORACLE: 00년~49년)
#19XX: 69년~99년 (ORACLE: 50년~99년)


#함수 사용 방법
#SQL과는 다르게 함수의 각 인수는 이름을 가짐
#인수는 이름과 함께 전달 가능(순서대로 전달 시에만 생략 가능)



#날짜 패키지(lubridate)
install.packages('lubridate')
library(lubridate)

year(d1)                     #년(숫자 리턴)
as.character(d1, '%Y')       #년(문자 리턴)
month(d1)                    #월
day(d1)                      #일
hour(Sys.time())             #시
minute(Sys.time())           #분
second(Sys.time())           #초
wday(Sys.Date())             #요일(숫자리턴, 일요일:1)
wday(Sys.Date(), label = T)  #요일(문자리턴)


d1 + 100               #100일 후
d1 + months(3)         #3개월 후
d1 + years(3)          #3년 후
Sys.time() + hours(3)  #3시간 후



#[ 데이터의 선택 ]
#데이터프레임: 행과 열의 2차원 구조의 자료구조(테이블)
#색인: indexing -> df[row(위치 or 이름), col]

#1) 하나의 컬럼 선택
df1$SAL

#2) 특정 행, 컬럼 위치 선택
#colnames(): 데이터프레임의 각 컬럼 추출
df1[2,]            #2nd row
df1[,2]            #2nd column
df1[2,2]           #2nd row and 2nd column

#3) 다수 행, 컬럼 위치 선택
df1[c(1, 10),]     #1st, 10th row

#첫번째행(SMITH)의 empno, ename, sal 선택
df1[1, c(1, 2, 6)]                  #위치 기반 선택
df1[1, c('EMPNO', 'ENAME', 'SAL')]  #이름 기반 선택


#4) 조건을 사용한 선택(조건 색인) - 대부분 행 색인
df1 <- read.csv('emp.csv')
df1$DEPTNO == 10            #논리값 출력
df1[df1$DEPTNO == 10,]      #논리값대로 추출



#논리값을 사용한 색인
#TRUE, T
df2 <- data.frame(col1 = 1:4, col2 = c('a', 'b', 'c', 'd'), col3 = c(10, 20, 30, 40))

df2
df2[c(1, 3),]
df2[c(T, F, T, F),]      #1st, 3nd row
df2[, c(T, F, T, F)]     #1st, 3nd col


#연산자
# >, <, >=, <=
# ==
# !=



#[ 자료구조]
# 0. 스칼라
# 1. 벡터
# 2. 리스트
# 3. 행렬
# 4. 배열
# 5. 데이터프레임



#[ 벡터 ] - R에서 가장 기본이 되는 자료구조
# 1차원 구조: 한 방향으로만 데이터가 정렬될 수 있음
# 동일한 데이터 타입으로 구성된 데이터 집합


#1. 생성
v1 <- c(1, 2, 3)
v2 <- c(1, 2, '3')    #문자타입으로 모두 변경


#2. 연산
v1 + 10       #나열형으로 출력 [1] 11 12 13
class(v1)     #벡터를 구성하는 데이터의 데이터타입 출력
class(df1)    #데이터프레임임을 할 수 있음

v3 <- c(10, 20, 30)
v4 <- c(10, 20, 30, 40, 50)
v1 + v3       #서로 같은 크기를 갖는 벡터끼리 연산 가능
v1 + v4       #서로 다른 크기를 갖는 벡터리끼 연산 가능(작은 벡터 원소 반복)
            


#3. 색인
#positional indexing: 위치 색인
#label indexing: 이름 색인(조건 색인)

v1 <- 1:5

#벡터 이름 출력
names(v1) <- c('a', 'b', 'c', 'd', 'e')     #벡터의 각 원소 이름 부여
names(v1)                                   #벡터의 각 원소 이름 확인


v1[3]           #3번째 추출 위치 색인
v1['c']         #이름 색인

v1[c(3, 5)]     #3, 5 추출 위치 색인
v1['c', 'e']    #이름 색인

v1[-3]          #위치 색인인 경우 제외
v1[-'c']        #이름 색인 사용 불가

v1[1:3]         #slice indexing(연속범위 선택)
v1['a':'c']     #문자의 연속적 출력 불가

v1[c(T, T, F, F, F)]  #boolean vector 전달 가능
v1[v1 < 3]            #조건 색인 가능


#4. 수정(선택 후 덮어쓰기)
# 두번째 값 20으로 수정
v1[2] <- 20
v1

# 4, 5를 동시에 40, 50으로 수정
v1[c(4, 5)] <- c(40, 50)
df1


# 두번째, 세번째 이름을 B, C로 수정
names(v1[2:3]) <- c('B', 'C')   #수정 불가
names(v1)[2:3] <- c('B', 'C')   #수정 가능
names(v1)
v1


#[ 논리 연산자 ]
#1) and: &
(v1 >= 3) & (v1 <= 5)

#2) or: |
(v1 > 3) | (v1 < 5)

#3) not: !
!(v1 < 3)


#[ 포함 연산자 ] - IN 연산자
#SMITH 또는 SCOTT 선택
#case 1)
df1[(df1$ENAME == 'SMITH') | (df1$ENAME == 'SCOTT'), ]
#case 2)
df1[df1$ENAME %in% c('SMITH', 'SCOTT'), ]

# NOT IN
df1[!(df1$ENAME %in% c('SMITH', 'SCOTT')), ]


