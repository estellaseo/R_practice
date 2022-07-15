#[ 연습문제 ] extract dates
#2022/01/01로부터 100일 뒤 날짜의 요일 출력
d1 <- as.Date('2022/01/01') + 100
as.character(d1, '%A')



#[ 연습문제 ] add columns
#emp.csv 불러온 후 각 직원의 근무일수 출력
df1 <- read.csv('emp.csv')

df1$WDay <- Sys.Date() - as.Date(df1$HIREDATE)  #컬럼 추가
df1



#[ 연습문제 ] indexing
#emp.csv 파일을 읽고, 
# 1) sal이 3000이상인 직원의 이름, 급여 출력
df1[df1$SAL >= 3000, ]

# 2) job이 clerk인 직원의 사원번호, 이름, job 출력
df1[df1$JOB == 'CLERK', c('EMPNO', 'ENAME', 'JOB')]

# 3) Smith의 정보를 출력(입사일 제외)
df1[df1$ENAME == 'SMITH', c(T, T, T, T, F, T, T, T)]

#colnames(): 데이터프레임의 각 컬럼 추출
df1[df1$ENAME == 'SMITH', colnames(df1) != 'HIREDATE']





#[ 실습문제 ]
# 1. emp.csv 파일을 읽고
emp <- read.csv('emp.csv')
emp

# 1) 10번 부서원의 이름 출력
emp[emp$DEPTNO == '10', 'ENAME']

# 참고 - 차원 축소
emp$DEPTNO                  #차원 축소(2차원 -> 1차원)
emp[, 'DEPTNO']             #차원 축소(2차원 -> 1차원)
emp[, 'DEPTNO', drop = F]   #차원 유지(2차원)
emp['DEPTNO']               #차원 유지(2차원)

# 단일대상에 대해서는 벡터형태 출력이 선호됨
# (ex) mean(emp['DEPTNO]): WARNING- 2차원구조(df) 입력 시 NA 출력



# 2) 이름이 SMITH 또는 SCOTT의 이름, SAL, HIREDATE 출력
cols <- c('ENAME', 'SAL', 'HIREDATE')
emp[emp$ENAME %in% c('SMITH', 'SCOTT'), cols]


# 3) 10번 부서원 중 급여가 2000이상이면서 
#    입사일이 81년 8월 31일 이후인 사람의 이름, 입사일, 부서번호, 급여 출력
str(emp)            #df info 확인 가능

con1 <- emp$DEPTNO == 10
con2 <- emp$SAL >= 2000 
con3 <- as.Date(emp$HIREDATE) > as.Date('81/08/31', '%y/%m/%d')
cols2 <- c('ENAME', 'SAL', 'HIREDATE', 'DEPTNO')
emp[con1 & con2 & con3, cols2]
 

# 4) 월요일에 입사한 사람의 전체 컬럼 정보 출력(단, mgr, deptno 컬럼 제외)
emp$HIREDATE <- as.Date(emp$HIREDATE)         #컬럼 자체를 date type으로 변경
emp$WDAY <- as.character(emp$HIREDATE, '%A')  #컬럼 추가
emp$WDAY <- NULL                              #컬럼 삭제
emp[as.character(emp$HIREDATE, '%A') == '월요일', !(colnames(emp) %in% c('MGR', 'DEPTNO')) ]


# 5) KING의 매니저 번호를 7839로 수정
emp[emp$ENAME == 'KING', 'MGR'] <- 7839
emp

# 6) SAL이 2000 이하인 사람은 2500으로 수정
emp[emp$SAL <= 2000, 'SAL'] <- 2500
emp


# 7) 입사년도가 1980인 사람의 JOB을 MANAGER로 변경
hyear <- as.character(as.Date(emp$HIREDATE), '%Y')
emp[hyear == 1980, 'JOB'] <- 'MANAGER'
emp



# 2. student.csv 파일을 읽고 student 객체 생성 후
student <- read.csv('student.csv', fileEncoding = 'cp949')
student

# 1) 구유미 학생의 학번, 이름, 학년 출력
col3 <- colnames(student) %in% c('STUDNO', 'NAME', 'GRADE')
student[student$NAME =='구유미', col3]


# 2) 일지매와 오나라 학생의 이름, 학년, 전화번호 출력
stulist <- c('일지매', '오나라')
col4 <- c('NAME', 'GRADE', 'TEL')
student[student$NAME == stulist, col4]



# 3) 4학년 학생의 키의 평균(mean 함수 사용)
# 힌트 : 색인은 오로지 데이터를 찾는 기능, 변환(함수 등의 사용)은 불가
grade4 <- student$GRADE == 4
student[grade4, c('HEIGHT', 'GRADE')]
mean(student[grade4, 'HEIGHT'])

# 4) 키가 170 이상인 학생의 이름, 학년, 키 출력
stulist17 <- student$HEIGHT >= 170
student[stulist17, c('NAME', 'GRADE', 'HEIGHT')]



