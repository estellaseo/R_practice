#[ 연습문제 ]
#apply_test2.csv 파일을 읽고 컬럼별 총합 구하기
test2<- read.csv('data/apply_test2.csv')
test2

colnames(test2)[-1] <- str_sub(colnames(test2)[-1], 2, 7)
test2[,] <- apply(test2, 2, str_remove_all, '[:punct:]')
test2[-1] <- apply(test2[-1], 2, as.numeric)
colSums(test2[-1], na.rm = T)




#[ 연습문제 ]
#emp.csv 파일에서 SAL 크기에 따른 등급 부여 함수 생성
#f_sal(emp$SAL)

#1) scalar input + sapply
f_sal <- function(x) {
  if (x < 2000) {
    'C'
  } else if (x < 3000) {
    'B'
  } else {
    'A'
  }
}

sapply(emp$SAL, f_sal)

#2) vector input
f_sal2 <- function(x) {
  vresult <- c()
  for (i in x) {
    if (i < 2000) {
      vresult <- c(vresult, 'C')
    } else if (i < 3000) {
      vresult <- c(vresult, 'B')
    } else {
      vresult <- c(vresult, 'A')
    } 
  } 
  return(vresult)
}
f_sal2(emp$SAL)




#[ 연습문제 ]
#emp에서 사번 입력 시 퇴직금 리턴 함수 생성
#단, 퇴직금 = 근속연수(정수) * 급여 * 0.1
emp = read.csv('data/emp.csv')

#1) scalar input
f_sal3 <- function(x) {
  vdata <- emp[emp$EMPNO == x, ]
  vsal <- vdata$SAL
  vdate <- as.Date(vdata$HIREDATE)
  vresult <- trunc(as.numeric(Sys.Date() - vdate)/365) * vsal * 0.1
  return(vresult)
}

f_sal3('7369')
sapply(emp$EMPNO, f_sal3)




#2) vector input
f_sal4 <- function(x) {
  vresult2 <- c()
  for (i in x) {
    vdata <- emp[emp$EMPNO == i, ]
    vsal <- vdata$SAL
    vdate <- as.Date(vdata$HIREDATE)
    vresult <- trunc(as.numeric(Sys.Date() - vdate)/365) * vsal * 0.1
    vresult2 <- c(vresult2, vresult)
  }
  return(vresult2)
}

f_sal4(emp$EMPNO)




#[ 연습문제 ]
#exam_01.csv, hakjum.csv 파일을 읽고 학번 입력 시 학점 리턴 함수 생성
exam <- read.csv('data/exam_01.csv')
hak <- read.csv('data/hakjum.csv')

#1) scalar input
f_hakjum()
vtotal <- exam[exam$STUDNO == 9715, 'TOTAL']

f_hakjum <- function(x) {
  for (i in 1:nrow(hak)) {
    vtotal <- exam[exam$STUDNO == x, 'TOTAL']
    if (vtotal >= hak$MIN_POINT[i] & vtotal <= hak$MAX_POINT[i]) {
      return(hak$GRADE[i])
    }
  }
}
f_hakjum('9715')
sapply(exam$STUDNO, f_hakjum)


#2) vector input
f_hakjum2 <- function(x) {
  vhakjum <- c()
  for (i in x) {
    vtotal <- exam$TOTAL[exam$STUDNO == i]
    vbool <- (vtotal >= hakjum$MIN_POINT) & (vtotal <= hakjum$MAX_POINT)
    vhakjum <- c(vhakjum, str_trim(hakjum[vbool, 'GRADE']))
  }
  return(vhakjum)
}

f_hakjum2(exam$STUDNO)




#[ 실습문제 ]
# 1. gogak.csv, gift.csv 파일을 읽고 고객번호를 입력하면 
# 가져갈 수 있는 가장 좋은 상품 한 개 리턴하는 함수 생성
gogak <- read.csv('data/gogak.csv', fileEncoding = 'cp949')
gift <- read.csv('data/gift.csv', fileEncoding = 'cp949')

# 1) scalar input
f_gift1 <- function(x) {
  vpoint <- gogak[gogak$GNO == x, 'POINT']
  con1 <- (vpoint >= gift$G_START) & (vpoint <= gift$G_END)
  gift[con1, 'GNAME']
}
sapply(gogak$GNO, f_gift1)


# 2) vector input
f_gift2 <- function(x) {
  vresult <- c()
  for (i in gogak$GNO) {
    vpoint <- gogak[gogak$GNO == i, 'POINT']
    con1 <- (vpoint >= gift$G_START) & (vpoint <= gift$G_END)
    vresult <- c(vresult, gift[con1, 'GNAME'])
  }
  return(vresult)
}
f_gift2(gogak$GNO)



# 2. student.csv, professor.csv 파일을 읽고
# 학번을 입력하면 지도교수명 출력하는 함수 생성
# 단, 지도교수가 없는 경우 지도교수없음 출력
stud <- read.csv('data/student.csv', fileEncoding = 'cp949')
prof <- pread.csv('data/professor.csv', fileEncoding = 'cp949')

# 1) scalar input
f_prof <- function(x) {
  vprofno <- stud[stud$STUDNO == x, 'PROFNO']
  if (!is.na(vprofno)) {
    vprofname <- prof[prof$PROFNO == vprofno, 'NAME']
  } else {
    '지도교수 없음'
  }
}
sapply(stud$STUDNO, f_prof)


# 2) vector input
f_prof2 <- function(x) {
  vprofname <- c()
  for (i in stud$STUDNO) {
    vprofno <- stud[stud$STUDNO == i, 'PROFNO']
    if (!is.na(vprofno)) {
      vprofname <- c(vprofname, prof[prof$PROFNO == vprofno, 'NAME'])
    } else {
      vprofname <- c(vprofname, '지도교수 없음')
    }
  }
  return(vprofname)
}

f_prof2(stud$STUDNO)



# 3. emp.csv 파일을 읽고 
emp <- read.csv('data/emp.csv', fileEncoding = 'cp949')

# 1) 부서별 최대연봉출력
tapply(emp$SAL, emp$DEPTNO, max)


# 2) 위에 해당하는사람(부서별 최대연봉자)의 이름, 급여, 부서번호 출력
max_group <- tapply(emp$SAL, emp$DEPTNO, max)

vname <- c()
vsal <- c()
vdeptno <- c()
for (i in max_group) {
  vname <- c(vname, emp[emp$SAL == i, 'ENAME'])
  vsal <- c(vsal, emp[emp$SAL == i, 'SAL'])
  vdeptno <- c(vdeptno, emp[emp$SAL == i, 'DEPTNO'])
}

df1 <- data.frame(vname, vsal, vdeptno)



# 3) 다음과 같은 형태로 출력(부서별 이름 나열, 어떤 형태도 상관X)
#                              ENAME
# 10                    CLARK_KING_MILLER
# 20         SMITH_JONES_SCOTT_ADAMS_FORD
# 30 ALLEN_WARD_MARTIN_BLAKE_TURNER_JAME

DEPTNO <- seq(10, 30, 10)
ENAME <- c()
for (i in DEPTNO) {
  ENAME <- c(ENAME, str_c(emp[emp$DEPTNO == i, 'ENAME'], collapse = '_'))
}

df2 <- data.frame(ENAME)
rownames(df2) <- DEPTNO


# 4. card_history.csv 파일을 읽고
# 아래와 같이 일자별(NUM) 각 지출품목의 지출 비율 출력
card <- read.csv('data/card_history.csv', fileEncoding = 'cp949')


#    식료품  의복   외식비  책값 온라인소액결제 의료비
# 1   8.63  63.61   3.83    12.90           2.49   8.54
# 2  11.57  62.74   3.65    13.55           1.72   6.77
# 3  14.76  53.09   4.50    13.20           4.50   9.96

card[ , ] <- as.numeric(sapply(card, str_remove_all, ','))
card$total <- rowSums(card[-1], na.rm = T)

f_ratio <- function(x) {
  round(x/card$total*100, 2)
}

df3 <- apply(card[-1], 2, f_ratio)
row.names(df3) <- unlist(card[1])


