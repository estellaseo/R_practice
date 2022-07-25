#[ 연습문제 ] matrix
#emp.csv 파일을 읽고
emp <- read.csv('data/emp.csv', fileEncoding = 'cp949')

#1) 사번, 이름, 부서번호만 선택하여 emp2로 생성
emp2 <- emp[, c('EMPNO', 'ENAME', 'DEPTNO')]


#2) emp2에 SAL 컬럼을 추가
emp2 <- cbind(emp2, SAL = emp$SAL) 


#3) emp2에 (9999, 홍길동, 10, 9000) 행 추가
emp2 <- rbind(emp2, '15' = c(9999, '홍길동', 10, 9000)) #벡터로 행 추가


mean(emp2$SAL)
str(emp2)



#[ 연습문제 ] apply function
#card_history.csv 파일에서 모든 컬럼의 천단위 구분기호 제거
card <- read.csv('data/card_history.csv', fileEncoding = 'cp949')

apply(card, 1, str_remove, ',')                  #연산 가능(but 행렬 전치)
t(apply(card, 1, str_remove, ','))               #t() 원 데이터 형식 유지

apply(card, 2, str_remove, ',')                  #가능
apply(card, c(1, 2), str_remove, ',')            #가능

card <- apply(card, c(1, 2), str_remove, ',')
class(card)                                      #자료구조: "matrix" "array" 

card <- as.data.frame(apply(card, c(1, 2), str_remove, ','))
class(card)

#[ 참고 ] apply 행렬 리턴 시 데이터프레임 형태 유지
card[,] <- apply(card, c(1, 2), str_remove, ',') #데이터만 추출하여 변환

# 사용자 정의 함수 사용
card[,] <- apply(card, 2, f1)
str(card)



#[ 연습문제 ]
#1. professor.csv 파일에서 email_id 추출
prof <- read.csv('data/professor.csv', fileEncoding = 'cp949')

#for문
email_id <- c()
for (i in prof$EMAIL) {
  email_id <- c(email_id, str_split(i, '@')[[1]][1])
}

#사용자 정의 함수
f1 <- function(x) {
  str_split(x, '@')[[1]][1]
}
prof$EMAIL_ID <- sapply(prof$EMAIL, f1)



#2. emp.csv 파일에서 부서명(10: 인사부, 20: 재무부, 30: 총무부)
emp <- read.csv('data/emp.csv', fileEncoding = 'cp949')

#for문
dname <- c()
for (i in emp$DEPTNO) {
  if (i == 10) {
    dname <- c(dname, '인사부')
  } else if (i == '20') {
    dname <- c(dname, '재무부')
  } else {
    dname <- c(dname, '총무부')
  }
}

#사용자 정의 함수
f2 <- function(x) {
  if (x == 10) {
    '인사부'
  } else if (x == '20') {
    '재무부'
  } else {
    '총무부'
  }
}
emp$DNAME <- sapply(emp$DEPTNO, f2)



#[ 연습문제 ]
test1 <- read.csv('data/apply_test.csv')

#1) detpno와 name 컬럼 분리 후 저장
f_split <- function(x, sep = '-', n = 1) {
  str_split(x, sep)[[1]][n]
}
test1$DEPTNO <- as.numeric(sapply(test1$deptno.name, f_split, '-', 1))
test1$NAME <- sapply(test1$deptno.name, f_split, '-', 2)
test1$deptno.name <- NULL

test1 <- test1[ , c(6, 5, 1:4)]        #컬럼 순서 재설정



#2) 컬럼별 총 합(NA 또는 '-'을 0으로 일괄 치환 후 계산)
f_na <- function(x) {
  if (is.na(x) | !str_detect(x, '.+[0-9].+')) {
    x <- '0'
  } else {
    x <- x
  }
}
test1[3:6] <- as.numeric(apply(test1[3:6], c(1, 2), f_na))
total <- colSums(test1[3:6])   

test2 <- read.csv('data/apply_test.csv')




#[ 연습문제 ] sqldf 패키지
# std, exam, hakjum 데이터 로딩 후 각 학생의 이름, 학년, 성적, 학점 출력
std <- read.csv('data/student.csv', fileEncoding = 'cp949')
exam <- read.csv('data/exam_01.csv', fileEncoding = 'cp949')
hakjum <- read.csv('data/hakjum.csv', fileEncoding = 'cp949')


vsql2 <- 'select s.name, s.grade, e.total, h.grade SCORE
            from std s, exam e, hakjum h 
           where s.studno = e.studno 
             and e.total between h.min_point and h.max_point'
sqldf(vsql2)





#[ 실습문제 ]
# 1.employment.csv 파일을 읽고
df1 <- read.csv('data/employment.csv', fileEncoding = 'cp949')


#column names, row names 변경
temp_col <- str_sub(colnames(df1)[-1], 2, 5)
colnames(df1)[-1] <- str_c(temp_col, unlist(df1[1, -1]), sep = '_')
rownames(df1) <- unlist(df1[1])
df1 <- df1[-1, ]


# 1) 연도별 총근로일수의 평균
df2 <- df1[str_detect(colnames(df1), '총근로일수')]
#결측치 제거
df2[df2 == '-'] <- NA
#숫자 변형
df2[,] <- apply(df2, 2, as.numeric)


colMeans(df2, na.rm = T)



# 2) 고용형태별 월급여액 평균
# (전체근로자와 전체근로자(특수형태포함)가 다른 그룹이 되도록)
df3 <- df1             #백업
df3[df3 == '-'] <- NA
#(,) 제거
df3 <- apply(df3, 2, str_remove_all, '[:punct:]')
#숫자 변형
df3 <- apply(df3, 2, as.numeric)


rowMeans(df3, na.rm = T)




# 2. subway2.csv 파일을 읽고 아래를 수행
# 단, 전체 컬럼에는 역이름이 모두 표현될 수 있게
sub <- read.csv('data/subway2.csv ', skip = 1, fileEncoding = 'cp949')
head(sub)

colnames(sub)[-c(1, 2)] <- as.numeric(str_sub(colnames(sub)[-c(1,2)], 2, 3))

# 1) 역별 승차의 총 합
for (i in 1:nrow(sub)) {
  if (sub$전체[i] == '') {
    sub$전체[i] <- sub$전체[i-1]
  } else {
    sub$전체[i]
  }
}


# 함수화
f_fillna <- function(x) {
  vresult <- c()
  for (i in 1:length(x)) {
    if (x[i] == '') {
      vresult <- c(vresult, x[max(i-1,1)])  
      # max(i-1,1) : i가 1일때 0이 색인되는것 방지
    } else {
      vresult <- c(vresult, x[i])
    }
  }
  return(vresult)
}

f_fillna(c(1,"",2,""))
f_fillna(c("",2,"",3))

# 이전값 가져오는 함수
install.packages('zoo')
zoo::na.locf(c(1,NA,2,NA))               # 이전값 가져오기
zoo::na.locf(c(NA,2,NA,3))               # 첫번째 NA 생략
zoo::na.locf(c(NA,2,NA,3), na.rm = F)    # 첫번째 NA 표현
zoo::na.locf(c(NA,2,NA,3), fromLast = T) # 이후값 가져오기



sub_on <- sub[sub$구분 =='승차', -2]
str(sub_on)
rowSums(sub_on[3:ncol(sub_on)])
sub_on$승차합 <- rowSums(sub_on[3:ncol(sub_on)])


# 2) 역별 하차의 총 합
sub_off <- sub[sub$구분 =='하차', ]
rowSums(sub_off[3:ncol(sub_off)])
sub_off$하차합 <- rowSums(sub_off[3:ncol(sub_off)])


# 3) 시간대별 총 합
son <- colSums(sub_on[3:ncol(sub_on)])   #시간대별 승차
soff <- colSums(sub_off[3:ncol(sub_off)]) #시간대별 하차
total <- son + soff



