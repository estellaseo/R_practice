#[ 연습문제 ] for loop
#1. emp 파일을 읽고
emp <- read.csv('data/emp.csv')

#SAL에 따른 등급을 만들어 GRADE 컬럼에 추가
sal_grade <- c()

for (i in emp$SAL) {
  if (i < 3000) {
    sal_grade <- c(sal_grade, 'C')
  } else if (i < 4000) {
    sal_grade <- c(sal_grade, 'B')
  } else {
    sal_grade <- c(sal_grade, 'A')
  }
}

emp$GRADE <- sal_grade



#2. professor 파일을 읽고 
prof <- read.csv('data/professor.csv', fileEncoding = 'cp949')

#email id 추출(단, split 함수 사용)
email_id <- c()

for (i in 1:length(prof$PROFNO)) {
  split_id <- str_split(prof$EMAIL, '@')[[i]][1]
  email_id <- c(email_id, split_id)
}

prof$EMAIL_ID <- email_id 




#[ 연습문제 ] for loop
#1. deptno가 10이면 인사부, 20이면 재무부, 30이면 총무부로 DNAME 컬럼 생성
dno <- c()

for (i in emp$DEPTNO) {
  if (i == 10) {
    dno <- append(dno, '인사부')
  } else if (i == 20) {
    dno <- append(dno, '재무부')
  } else {
    dno <- append(dno, '총무부')
  }
}

emp$DNAME <- dno



#2. 10번 부서 급여 10% 인상, 20번 11%, 30번 12% NEW_SAL 컬럼 생성
nsal <- c()

for (i in 1:nrow(emp)) {
  if (emp$DEPTNO[i] == 10) {
    nsal <- c(nsal, emp$SAL[i] * 1.1)
  } else if (emp$DEPTNO[i] == 20) {
    nsal <- c(nsal, emp$SAL[i] * 1.11)
  } else {
    nsal <- c(nsal, emp$SAL[i] * 1.12)
  }
}

emp$NEW_SAL <- nsal



#3. emp.csv, dept.csv를 불러온 후
emp <- read.csv('data/emp.csv')
dept <- read.csv('data/dept.csv')

#각 직원의 부서명을 dept.csv 파일을 참고하여 emp 테이블에 DNAME 컬럼 추가
vdname <- c()

#위치 기반
for (i in 1:nrow(emp)) {
  vdname <- c(vdname, dept[emp$DEPTNO[i] == dept$DEPTNO, 'DNAME'])
}
emp$DNAME <- vdname


#객체 기반
for (i in emp$DEPTNO) {
  vdname <- c(vdname, dept$DNAME[dept$DEPTNO == i])
}
emp$DNAME <- vdname



#[ 연습문제 ] for / While loop
#1~100까지 짝수의 합
#for문
esum <- 0
for (i in seq(2, 100, 2)) {
  esum <- esum + i
}
esum

#while문
esum <- 0
i <- 2
while (i <= 100) {
  esum <- esum + i
  i <- i + 2
}
esum


#[ 예습 ] apply 함수
card <- read.csv('data/card_history.csv', fileEncoding = 'cp949')
f1 <- function(x) {
  as.numeric(str_remove_all(x, ','))
}
apply(card, 2, f1)




#[ 실습문제 ]
# 1. exam_01.csv, student.csv 파일을 각각 exam, std로 읽어온 후
# 각 학생의 시험 성적을 exam에서 찾아 std의 JUMSU라는 컬럼에 삽입
exam <- read.csv('data/exam_01.csv', fileEncoding = 'cp949')
stud <- read.csv('data/student.csv', fileEncoding = 'cp949')

score <- c()
for (i in stud$STUDNO) {
  score <- c(score, exam$TOTAL[exam$STUDNO == i])
}
stud$JUMSU <- score




# 2. 위에서 얻은 시험성적을 사용하여
# hakjum.csv 파일을 읽고 hakjum 파일의 기준에 따라 학점을 계산,
# std의 HAKJUM 컬럼에 삽입
hak <- read.csv('data/hakjum.csv', fileEncoding = 'cp949')

grade <- c()
for (i in stud$JUMSU) {
  for (j in 1:nrow(hak)) {
    if (i >= hak$MIN_POINT[j] & i <= hak$MAX_POINT[j]) {
      grade <- c(grade, hak$GRADE[j])
    }
  }
}
stud$HAKJUM <- str_trim(grade)         #빈공백 제거: str_trim()



vhakjum <- c()
for (i in stud$JUMSU) {
  vbool <- (i >= hak$MIN_POINT) & (i <= hak$MAX_POINT)
  vhakjum <- c(vhakjum, hak$GRADE[vbool])
}
stud$HAKJUM <- str_trim(vhakjum)




# 3. for문을 사용하여 다음 출력(print)
# [1] "     *     "
# [1] "    ***    "
# [1] "   *****   "
# [1] "  *******  "
# [1] " ********* "


tstar <- '*'
for (i in 1:5) {
  star_order <- str_pad(tstar, 11, 'both')
  print(star_order)
  tstar <- str_c(tstar, '**')
}


for (i in 1:5) {
  v1 <- str_pad(' ', 6-i, 'left', ' ')
  v2 <- str_pad('*', 2*i-1, 'left', '*')
  print(str_c(v1, v2, v1))
}



