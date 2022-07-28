#[ 연습문제 ]
#student 테이블에서 성별 키가 큰 순서대로 성렬(단, 성별은 남여 순으로)
#1) 성별을 숫자로 생성한 경우 정렬 결과
stud <- read.csv('data/student.csv', fileEncoding =  'cp949')
stud
stud[order(substr(stud$JUMIN, 7, 7), stud$HEIGHT, decreasing = T), ]

#2) 성별을 M, F로 생성한 경우 정렬 결과
gender <- c()
for (i in 1:nrow(stud)) {
  if (substr(stud$JUMIN[i], 7, 7) == 1) {
    gender <- c(gender, 'M')
  } else {
    gender <- c(gender, 'F')
  }
}
stud$GENDER <- gender
stud[order(stud$GENDER, stud$HEIGHT, decreasing = T), ]

stud$GENDER2 <- ifelse(stud$JUMIN, 7, 7 == 1, '남', '여')

#대상 컬럼이 모두 숫자일 경우 decreasing 벡터 전달 가능
#대상 컬럼이 문자, 숫자 컬럼 각각일 경우 decreasing 벡터 전달 불가

#해결방법 (method = "radix")
#Now available for both Korean and English
stud[order(substr(stud$JUMIN, 7, 7), 
           stud$HEIGHT, decreasing = c(F, T), method = 'radix'), ]




#[ 연습문제 ]
#emp 테이블에서 각 직원의 이름, 급여, 상위관리자 이름, 급여를 출력
#단, 상위관리자에 없는 경우도 출력

#1) DB 접속해서 SQL로 해결
emp1 <- dbGetQuery(con1, 'select e1.ename, e1.sal, e2.ename, e2.sal
                            from emp e1, emp e2
                           where e1.mgr = e2.empno(+)')


#2) 데이터 추출 후 R로 해결
emp2 <- dbGetQuery(con1, 'select * from emp')
emp3 <- emp2[, c('ENAME', 'SAL')]

vmgr <- c()
vsal <- c()
for (i in emp2$MGR) {
  if (is.na(i)) {
    vmgr <- c(vmgr,NA)
    vsal <- c(vsal,NA)
  } else {
    vmgr <- c(vmgr, emp2[emp2$EMPNO == i, 'ENAME']) 
    vsal <- c(vsal, emp2[emp2$EMPNO == i, 'SAL']) 
  }
}

emp3$ENAME2 <- vmgr
emp3$SAL2 <- vsal

merge(emp2, emp2, 
      by.x= 'MGR', by.y = 'EMPNO', 
      all.x = T)[, c('ENAME.x', 'SAL.x', 'ENAME.y', 'SAL.y')]




#[ 실습문제 ]
#교습현황.csv 파일을 읽고
df1 <- read.csv('data/교습현황.csv', skip = 1, fileEncoding = 'cp949')
head(df1[-c(1:5)])

#데이터프레임 정리
#삭제 및 숫자 처리
df1[-c(1:5)] <- as.numeric(sapply(df1[-c(1:5)], str_remove_all, ','))
head(df1)

#컬럼명 정리
colnames(df1)[-c(1:5)] <- str_sub(colnames(df1)[-c(1:5)], 2,5)
sum(is.na(df1))      #전체 데이터의 NA 개수
colSums(is.na(df1))  #컬럼별 NA 개수

#2016~2018 매출 총합
df1$total <- rowSums(df1[-c(1:5)])

#구별, 동별 컬럼 추가
df1$주소_구 <- str_extract(df1$교습소주소, '[가-힣]+구')       #'..구'
df1$주소_구[is.na(df1$주소_구)]
df1$주소_동 <- str_extract(df1$교습소주소, '\\([:alnum:]+동')  #[가-힣0-9]
df1$주소_동 <- str_remove(df1$주소_동, '\\(')
df1$교습소주소[is.na(df1$주소_동)]
unique(df1_sales$주소_동)


# 1. 구별, 교습과정별 2016~2018 매출 총 합이 가장 큰 교습소 이름 출력
# 예) 관악구 음악 성가피아노교습소
# 단, 현 데이터에서 교습소명이 중복되는 경우 하나의 교습소로 그룹핑 후 처리


#[ 참고 ] 컬럼 재배치 
v1 <- c(colnames(df1)[1:2], 
        '주소_구', '주소_동', 
        colnames(df1)[3:(ncol(df1)-2)])   #컬럼 이름을 indexing후 벡터 생성
df1 <- df1[, v1]                          #벡터의 컬럼 순서대로 df 생성


#교습소명 통합
library(plyr)
df3 <- ddply(df1, .(교습소명, 교습과정, 주소_구, 주소_동), 
                   summarise, VSUM = sum(total))
nrow(df3)
length(unique(df3$교습소명))

#구별, 교습과정별 매출 최고
df3_1 <- ddply(df3, .(주소_구, 교습과정, 교습소명), summarise, TSUM=sum(VSUM))
ddply(df3_1, .(구, 교습과정), subset, TSUM == max(TSUM))




# 2. 구별, 교습과정별 매출 총 합(2016~2018 전체 총 합)이 가장 큰 동이름 출력
# 예) 관악구 음악 신림동

df3_2 <- ddply(df3, .(주소_구, 교습과정, 주소_동), summarise, TSUM=sum(VSUM))
ddply(df3_2, .(주소_구, 교습과정), subset, TSUM == max(TSUM))




