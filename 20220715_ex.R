#[ 연습문제 ] list
#1) 다음의 값을 갖는 하나의 리스트를 생성
l2 <- list(name= c('서재수', '이미경', '김재수'),
           jumsu= c(90, 80, 77),
           deptno= c(101, 101, 102))


# 2) 서재수의 점수를 99점으로 수정
l2$jumsu[1] <- 99                    #해당 값 위치를 알 때
l2$jumsu[l2$name == '서재수'] <- 99  #해당 값 위치를 모를 때


# 3) name 키에만 홍길동 추가
l2$name <- c(l2$name, '홍길동')
l2$name[4] <- '홍길동'



# 4) hakjum 키에 다음을 생성(A+, A0, B0)
l2$hakjum <- c('A+', 'A0', 'B0')





#[ 연습문제 ] 문자열 추출
#여학생의 키 평균 출력
stud <- read.csv('student.csv', fileEncoding = 'cp949')
mean(stud[substr(stud$JUMIN, 7,7) == '2', 'HEIGHT'])


#태어난 월이 8월 이후인 학생                       - datatype 일치
str_sub(stud$BIRTHDAY, 6, 7) > '08'                #1) 문자, 문자
as.numeric(str_sub(stud$BIRTHDAY, 6, 7)) > 8       #2) 숫자, 숫자





#[ 연습문제 ] 문자열 치환
card <- read.csv('card_history.csv', fileEncoding = 'cp949')
#1) 식료품 총합
food <- as.numeric(str_replace(card$식료품, ',', ''))
sum(food)


#2) 7일 이전까지 의료비 지출 평균
card$의료비 <- as.numeric(str_replace(card$의료비, ',', ''))
mean(card[card$NUM < 7, '의료비'])





#[ 연습문제 ] replace NA
#10번 부서원을 제외한 직원의 COMM 평균. COMM 없는 경우 0으로 치환 후 계산
emp <- read.csv('emp.csv')

#case 1)
emp$COMM <- as.numeric(str_replace_na(emp$COMM, '0'))
#case 2)
is.na(emp$COMM) <- 0

mean(emp[emp$DEPTNO != 10, 'COMM'])               #NA를 0으로 지환 후 전체 평균


#참고 - NA 값 무시
mean(emp[emp$DEPTNO != 10, 'COMM'], na.rm = T)    #NA인 data 전체 무시





#[ 실습문제 ]
# 1. emp.csv 파일을 읽고 각 직원의 이름, 부서번호, 급여, 급여검토일 출력
# 단, 급여검토일은 입사일에서 3개월 후 날짜
emp <- read.csv('emp.csv')

emp$급여검토일 <- as.Date(emp$HIREDATE) + months(3)
emp[, c('ENAME', 'DEPTNO', 'SAL', '급여검토일')]




# 2. student.csv 파일을 읽고 
stud <- read.csv('student.csv', fileEncoding = 'cp949')

# 1) 주민번호를 아래와 같이 수정
# "7510231901810" => "751023-XXXXXXX"
stud$JUMIN <- str_replace(stud$JUMIN, str_sub(stud$JUMIN, 7), '-XXXXXXX')


# 2) 생년월일을 아래와 같이 치환
#     1975/10/23 => 1975년 10월 23일
stud$BIRTHDAY <- as.character(as.Date(stud$BIRTHDAY), '%Y년 %m월 %d일')


# 3) DEPTNO2 값이 없으면 DEPTNO1를 출력하여 DEPTNO 컬럼 추가
stud$DEPTNO <- stud$DEPTNO2
stud$DEPTNO <- str_replace_na(stud$DEPTNO, as.character('DEPTNO1'))
class(stud$DEPTNO1)



# 3. professor.csv 파일을 읽고
prof <- read.csv('professor.csv', fileEncoding = 'cp949')

# 1) BONUS가 NA인 교수는 NA가 아닌 교수의 평균 보너스로 수정
avg_bonus <- as.character(mean(prof$BONUS, na.rm = T))
prof$BONUS <- as.numeric(str_replace_na(prof$BONUS, avg_bonus))


# 2) 각 교수의 직급을 교수/ 강사 여부만 출력하여 POSITION2 컬럼에 저장
prof$POSITION2 <- str_sub(prof$POSITION, -2)




# 4. data2.csv를 읽고[(for문 없이)]
df2 <- read.csv('data2.csv', fileEncoding = 'cp949')

# 1) 4호선 라인의 전체 시간의 승차의 총합(승차 인원의 총 합)
line4 <- as.numeric(str_remove_all(df2[df2$노선번호 == 'line_4', '승차'], ','))
sum(line4)


# 2) 1호선 라인의 9시~12시 시간대까지의 하차의 총합(위치 색인 불가)
class(df2$시간)    #integer 타입
df2$시간 <- strptime(str_sub(df2$시간, -2), '%H') - hours(1)
getoff <- df2[hour(df2$시간) %in% c(9, 10, 11), '하차']
sum(as.numeric(str_remove_all(getoff, ',')))


df2$시간 <-as.numeric(str_sub(df2$시간, -2)) - 1
getoff <- df2[df2$시간 %in% c(9, 10, 11), '하차']
sum(as.numeric(str_remove_all(getoff, ',')))
