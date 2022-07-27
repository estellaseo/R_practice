#[ 연습문제 ] merge
# student, professor 테이블에서 각 학생 이름, 학년, 교수이름 출력
stud <- read.csv('data/student.csv', fileEncoding = 'cp949')
prof <- read.csv('data/prof.csv', fileEncoding = 'cp949')

merge(stud, prof, by = 'PROFNO', all.x = T)[,c('NAME.x', 'GRADE', 'NAME.y')]




#[ 연습문제 ] aggregate
#professor.csv 파일을 읽고
prof <- read.csv('data/prof.csv', fileEncoding = 'cp949')

#1) position별 pay의 평균
aggregate(prof$PAY, list(prof$POSITION), mean)

aggregate(PAY ~ POSITION, prof, mean)

tapply(prof$PAY, prof$POSITION, mean)


#2) position, deptno 별 pay의 평균
aggregate(prof$PAY, list(prof$POSITION, prof$DEPTNO), mean)

aggregate(PAY ~ POSITION + DEPTNO, prof, mean)


#3) position별 pay와 bonus의 최대값
aggregate(prof[, c('PAY', 'BONUS')], list(prof$POSITION), max, na.rm = T)
#NA 무시하여 연산

aggregate(cbind(PAY, BONUS) ~ POSITION, prof, max,
          na.rm = T, na.action = na.pass)
#na.action = na.omit(default setting)




#[ 연습문제 ]
#student, exam_01 파일을 사용하여
#각 학년별 성적우수자(최고 성적)의 이름, 학년 성적 출력
stud <- read.csv('data/student.csv', fileEncoding = 'cp949')
exam <- read.csv('data/exam_01.csv', fileEncoding = 'cp949')

stud2 <- merge(stud, exam, by = 'STUDNO')[ , c('NAME', 'GRADE', 'TOTAL')]
vresult <- aggregate(TOTAL ~ GRADE, stud2, max)

merge(stud2, vresult, by = c('GRADE', 'TOTAL'))




#[ 연습문제 ]
#professor 데이터를 사용하여
prof <- read.csv('data/prof.csv', fileEncoding = 'cp949')

#1) 학과별 평균 급여 출력
ddply(prof, .(DEPTNO), summarise, MEAN_PAY = mean(PAY))

#2) 학과별 평균급여보다 낮은 급여를 받는 교수 이름, 학과번호, 급여 출력
ddply(prof[, c('NAME', 'DEPTNO', 'PAY')], .(DEPTNO), subset, 
      PAY < mean(PAY))




#[ 연습문제 ] mapply
# DEPTNO가 10번일 때 10%, 20일 때 11%, 30일 때 12% 연봉 상승
#1) for문(위치기반)
vsal <- c()
for (i in 1:nrow(emp)) {
  if (emp$DEPTNO[i] == '10') {
    vsal <- c(vsal, emp$SAL[i] * 1.1)
  } else if (emp$DEPTNO[i] == '20') {
    vsal <- c(vsal, emp$SAL[i] * 1.11)
  } else {
    vsal <- c(vsal, emp$SAL[i] * 1.12)
  }
}
vsal

#2) mapply
f_sal <- function(deptno, sal) {
  if (deptno == '10') {
    vsal <- sal * 1.1
  } else if (deptno == '20') {
    vsal <- sal * 1.11
  } else {
    vsal <- sal * 1.12
  }
  return(vsal)
}
mapply(f_sal, emp$DEPTNO, emp$SAL)




#[ 실습문제 ]
# 1. professor.csv 파일을 읽고
prof <- read.csv('data/professor.csv',fileEncoding = 'cp949')

# 직급별로 계산되는 급여 출력
# 정교수 = PAY + BONUS * 5(BONUS가 NA인 경우 500)
# 조교수 = PAY*1.1 + BONUS (BONUS가 NA인 경우 500)
# 전임강사 = PAY + 100 
f_profsal <- function(position, pay, bonus) {
  if (position == '정교수' & !is.na(bonus)) {
    vresult <- pay + bonus * 5
  } else if (position == '정교수' & is.na(bonus)) {
    vresult <- pay + 500
  } else if (position == '조교수' & !is.na(bonus)) {
    vresult <- pay * 1.1 + bonus
  } else if (position == '조교수' & is.na(bonus)) {
    vresult <- pay + 500
  } else {
    vresult <- pay + 100
  }
  return(vresult)
}
prof_sal <- mapply(f_profsal, prof$POSITION, prof$PAY, prof$BONUS)
data.frame(NAME = prof$NAME, POSITION = prof$POSITION, SAL = prof_sal)




# 2. gogak, gift 파일을 읽고
gogak <- read.csv('data/gogak.csv', fileEncoding = 'cp949')
gift <- read.csv('data/gift.csv', fileEncoding = 'cp949')
# 각 고객마다 가져갈 수 있는 모든 상품을 나열하여
# 아래와 같은 형태로 출력(출력순서 상관 X)
# 이름       상품
# 서재수   참치세트   
# 이미경  참치세트, 샴푸세트, 세차용품세트, 주방용품세트  
# ...


f_giftlist <- function(x) {
  vscore <- gogak[gogak$GNAME == x, 'POINT']
  vgname <- gift[vscore >= gift$G_START, 'GNAME']
  vlist <- str_c(vgname, collapse = ', ')
  return(vlist)
}

df1 <- data.frame(이름 = gogak$GNAME, 상품 = sapply(gogak$GNAME, f_giftlist))


#[ 참고 ] for문에서 데이터프레임 생성
df_name <- data.frame()
for (i in gogak$GNAME) {
  vscore <- gogak[gogak$GNAME == i, 'POINT']
  vgname <- gift[vscore >= gift$G_START, 'GNAME']
  vlist <- str_c(vgname, collapse = ', ')
  df_name <- rbind(df_name, data.frame(이름 = i, 상품 = vlist))
}




# 3. delivery.csv 파일을 읽고
deli <- read.csv('data/delivery.csv', fileEncoding = 'cp949')
head(deli)

# 1) 일자별 총 통화건수를 구하여라
#aggregate 함수
vdeli <- aggregate(통화건수 ~ 일자, deli, sum)

#ddply 함수
library(plyr)
vdeli <- ddply(deli, .(일자), summarise, total = sum(통화건수))



# 2) 시간대별 배달이 가장 많은 업종 출력
vdeli2 <- aggregate(통화건수 ~ 시간대 + 업종, deli, sum)
ddply(vdeli2, .(시간대), subset, 통화건수 == max(통화건수))



# 3) 일자별 배달콜수에 대한 전일 대비 증감률을 구하여라(단 첫날은 0%)
#solution 1)
vresult2 <- 0
for (i in 2:nrow(vdeli)) {
  deliv <- ((vdeli$통화건수[i]-vdeli$통화건수[i-1])/vdeli$통화건수[i-1]) * 100
  vresult2 <- c(vresult2, deliv)
}

vdeli$증감률 <- round(vresult2, 2)

#solution 2)
vtotal <- vdeli$total
vdeli$total2 <- c(vtotal[1], vtotal[-length(vtotal)])
(vdeli$total - deli2$total2)/ deli2$total2 * 100


#[ 참고 ] 외부패키지 활용 (data.table::shift)
install.packages('data.table')
library(data.table)

shift(x,                                  #원본데이터
      n =1,                               #이동간격
      fill = NA,                          #가져올 값 부재시 표현
      type = c('lag', 'lead', 'shift'))   #방향


shift(c(1, 2, 3, 4))                      #default: 이전값 가져오기
shift(c(1, 2, 3, 4), n = 2)               #이전이전 값 가져오기
shift(c(1, 2, 3, 4), type = 'lag')        #이전값 가져오기
shift(c(1, 2, 3, 4), type = 'lead')       #이후값 가져오기
      
      


# 4) 각 읍면동별 통화건수의 총 합을 출력
# (단, 각 동은 숫자를 포함하고 있는 경우 
# 숫자를 제외한 동까지 표현하도록 함 (ex 을지로6가 => 을지로))

deli$읍면동 <- str_remove_all(deli$읍면동, '[0-9][가-힣]$')
unique(deli$읍면동)

aggregate(통화건수 ~ 읍면동, deli, sum)



#[ 참고 ] str_extract 추출
str_extract('가나다abc123', '[가-힣]+')
str_extract_all('서울시 동작구 신대방1동 1층', '[가-힣0-9]+동')



