#[ 연습문제 ]
#2000-2013년_연령별실업율_40-49세.csv 파일을 읽고
df1 <- read.csv('data/2000-2013년_연령별실업율_40-49세.csv', 
                fileEncoding = 'cp949')
head(df1)

#1) 아래와 같이 표현
#월   2000 2001 2002
#1월
#2월
#..

colnames(df1)[-1] <- str_sub(colnames(df1)[-1], 2, 5)
df1$월 <- str_c(df1$월, '월')


#2) 2005년 상반기의 실업율 평균
#case 1)
mean(df1[df1$월 %in% c('1월', '2월', '3월', '4월', '5월', '6월'), '2005'])
#case 2)
mean(df1[as.numeric(str_remove(df1$월, '월')) <= 6, '2005'])


#3) 2009년 실업율 중 2.5 미만인 경우 기존 실업율의 10% 증가값으로 수정
#case 1)
df1[df1$'2009' < 2.5, '2009'] <- df1[df1$'2009' < 2.5, '2009'] * 1.1
#case 2)
df1$'2009'[df1$'2009' < 2.5] <- df1$'2009'[df1$'2009' < 2.5] * 1.1


#4) 실업율이 2.0 미만인 해가 2회 이상인 월 추출
v1 <- df1[ , -1] < 2.0
#case 1)
df1$월[rowSums(v1, na.rm = T) >= 2]
#case 2)
df1[rowSums(v1) >= 2, '월']



#[ 연습문제 ] if
#급여 수준에 따라 다음과 같은 등급을 부여할 때, SMITH의 등급은?
#3000이상 A, 미만 B 
emp <- read.csv('data/emp.csv')
if (emp[emp$ENAME == 'SMITH', 'SAL'] >= 3000) {
  'A'
} else {
  'B'
}



#[ 연습문제 ] ifelse
#1) 10번 부서는 10% 인상, 나머지는 11% 인상된 급여를 NEW_SAL 컬럼에 추가
emp$NEW_SAL <- ifelse(emp$DEPTNO == '10', emp$SAL * 1.1, emp$SAL * 1.11)

#2) COMM에서 10% 인상, NA인 경우는 500 부여하여 NEW_COMM 컬럼에 추가
emp$NEW_COMM <- ifelse(is.na(emp$COMM), 500, emp$COMM * 1.1)



#[ 연습문제 ]
#10번 인사부, 20번 재무부, 30번 데이터분석부 DNAME 컬럼에 추가
emp$DNAME <- ifelse(emp$DEPTNO == 10, '인사부', 
                    ifelse(emp$DEPTNO == 20, '재무부', '데이터분석부'))

       


#[ 실습문제 ]
#1. student.csv 파일을 읽고
stud <- read.csv('data/student.csv', fileEncoding = 'cp949')
head(stud)

#1) 성별 컬럼 추가
stud$GENDER <- ifelse(str_sub(stud$JUMIN, 7, 7) == '1', '남자', '여자')


#2) 생년월일을 다음과 같이 표현하여 저장(1975/10/23 => 10/23, 1975)
stud$BIRTHDAY <- as.character(as.Date(stud$BIRTHDAY), '%m/%d, %Y')


#3) 비만컬럼 추가(표준몸무게보다 크면 비만, 작으면 저체중, 같으면 정상)
#   표준몸무게 = (키 - 100) * 0.9
nor_weight <- (stud$HEIGHT - 100) * 0.9
stud$BMI <- ifelse(stud$WEIGHT > nor_weight, '비만', 
                   ifelse(stud$WEIGHT == nor_weight, '정상', '저체중'))


#4) DEPTNO 컬럼 추가(DEPTNO2가 NA이면 DEPTNO1로 대체)
stud$DEPTNO <- ifelse(is.na(stud$DEPTNO2), stud$DEPTNO1, stud$DEPTNO2)



#2. read_test.csv 파일을 읽고
df1 <- read.csv('data/read_test.csv')

#1) 2019년 01월 a지점의 판매량의 총 합 출력
#case 1)
sum(as.numeric(df1[str_sub(df1$date, 1, 6) =='201901', 'a']), na.rm = T)

#case 2)
df1$a[!str_detect(df1$a, '^[0-9]+$')] <- NA    #숫자가 아닌 값 NA로 대체
sum(as.numeric(df1[str_detect(df1$date, '^201901'), 'a']), na.rm = T)

#[ 참고 ]
str_detect(c(1111, '.', 'a', 'a11'), '[0-9]+') #숫자를 포함


#2) 결측치가 포함된 날짜는 삭제
con1 <- str_detect(df1$a, '^[0-9]+$')
con2 <- str_detect(df1$b, '^[0-9]+$')
con3 <- str_detect(df1$c, '^[0-9]+$')
con4 <- str_detect(df1$d, '^[0-9]+$')
df1 <- df1[con1 & con2 & con3 & con4, ]


#3) b지점에서 판매량이 가장 많았던 날짜 확인
df1[df1$b == max(as.numeric(df1$b), na.rm = T), 'date']

#[ 참고 ]
#NA는 비교 연산자로 비교 불가 -> NA로 리턴됨됨
#조건에 만족하는 값으로 NA 동시 리턴
#NA가 아닌 조건 반드시 추가: & (!is.na(v1))


#4) 각 날짜별 판매량의 총합을 계산하여 total 컬럼 생성
df1$a <- as.numeric(df1$a)
df1$b <- as.numeric(df1$b)
df1$c <- as.numeric(df1$c)
df1$d <- as.numeric(df1$d)

#case 1)
df1$TOTAL <- df1$a + df1$b + df1$c + df1$d

#case 2)
df1$TOTAL <- rowSums(df1[, -1])


#5) 총 판매량이 0이상 400미만이면 'C', 400이상 600미만 'B', 600이상 'A' 
df1$GRADE <- ifelse(df1$TOTAL >= 600, 'A', 
                    ifelse(df1$TOTAL >= 400, 'B', 'C'))



