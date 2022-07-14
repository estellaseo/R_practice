# 설치: 외부 패키지의 경우 최초 1회 설치
install.packages('rJava')

# 로딩: 외부 패키지의 경우 매 세션마다 로딩 후 작업
library(rJava)

# 단축키
# ctrl + enter: 명령어단위 실행
# ctrl + shift + C: 주석처리/해제
# ctrl + o: 파일 열기

getwd() # 별도의 명령어 없이 파일 불러올 수 있음
setwd('C:/Users/itwill/Documents') # 현재 세션에서만 유효함

#작업 directory 변경 방법: tools - global options

df1 <- read.csv('emp.csv') # 로딩 가능
sum(df1$SAL)

#변수 - 상수나 명령어의 결과를 저장하기 위한 객체(이름 부여)
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
# as.Date() : 날짜로 파싱
# as.character() : 문자가 아닌 값을 문자로 변경
# as.numeric() : 문자를 숫자로 변경경