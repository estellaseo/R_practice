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
