#[ 연습문제 ] str_detect
prof <- read.csv('data/professor.csv', fileEncoding = 'cp949')

#1) ID에 a로 시작하고 두번째 글자가 n을 포함하는 교수의 정보 출력(대소구분 X)
#case 1) 논리 연산자 이용
prof[(str_detect(prof$ID, '^[Aa]')) & (str_detect(prof$ID, '^.[Nn]')), ]
#두번째 글자가 n인: str_detect(prof$ID, '^.[Nn]')
#case 2) 
prof[str_detect(prof$ID, '^[Aa][Nn]'), ]


#2) 특수 기호를 포함하는 교수의 이름과 아이디 출력
prof[str_detect(prof$ID, '[:punct:]'), c('NAME', 'ID')]


#3) prof ID에서 go가 연속 2회 이상 포함된 사람의 이름, ID 출력
prof[str_detect(prof$ID,'(go){2,}'), c('NAME', 'ID')]


#4) 글자로 시작해서 숫자로 끝나는 ID를 갖는 사람의 이름, ID 출력
#case 1)
prof[str_detect(prof$ID, '^[:alpha:].+[:digit:]$'), c('NAME', 'ID')]
#case 2)
prof[str_detect(prof$ID, '^[a-z].+[0-9]$'), c('NAME', 'ID')]




#[ 연습문제 ]
# 다음의 문자열에서 이메일 주소만 추출
v2 <- 'dfa@sdf abc@naver.com fg435 sdd22@hanmail.net,dff lkjf aa_123@google.com djfsd;jf'
v2 <- str_split(v2, ' ')[[1]]

v2[str_detect(v2, '.+[@].+[.].+$')]
v2[str_detect(v2, '[a-z0-9_]+@[a-z]+\\.[a-z]+')]




#[ 연습문제 ] str_split
#student.csv 파일에서 김재수 학생의 전화번호 국번 추출
stud <- read.csv('data/student.csv', fileEncoding = 'cp949')

str_split(stud[stud$NAME == '김재수', 'TEL'], '[)-]' )[[1]][2]




#[ 연습문제 ] str_c
#emp.csv. 파일을 읽고 아래와 같이 표현
emp <- read.csv('data/emp.csv')
#SMITH의 10% 인상된 급여는 880이다.

emp$updated_sal <- round(emp$SAL * 1.1)
str_c(emp$ENAME, '의 10% 인상된 급여는 ', emp$updated_sal, '이다.')




#[ 연습문제 ] str_pad, str_locate
#1) emp 데이터에서 sal 컬럼을 모두 4자리로 변경(800 -> 0800)
emp$SAL <- str_pad(emp$SAL, 4, 'left', 0)


#2) student 테이블에서 ID 값을 모두 10자리로 변경(앞에 * 삽입)
stud$ID <- str_pad(stud$ID, 10, 'left', '*')


#3) professor 데이터에서 ID 컬럼에 특수기호가 1회 이상 포함되는 교수 출력
prof[str_detect(prof$ID, '[:punct:]+'), ]




#[ 실습문제 ]
#1. disease 테이블을 읽고
df2 <- read.table('data/disease.txt', header = T, fileEncoding = 'cp949')
#< 간단 정리 >
#쉼표(,)로 분리, 구분되어 있는 테이블 -> read.csv
#tab으로 분리, 구분되어 있는 테이블 -> read.table
#header = T : first row를 column명으로 설정

#1) df2와 동일한 df3 생성 후 각 NA값을 각 컬럼의 최소값으로 수정
df3 <- df2
df3$콜레라 <- str_replace_na(df3$콜레라, min(df3$콜레라, na.rm = T))
df3$장티푸스 <- str_replace_na(df3$장티푸스, min(df3$장티푸스, na.rm = T))
df3$이질 <- str_replace_na(df3$이질, min(df3$이질, na.rm = T))
df3$대장균 <- str_replace_na(df3$대장균, min(df3$대장균, na.rm = T))
df3$A형간염 <- str_replace_na(df3$A형간염, min(df3$A형간염, na.rm = T))

#case 1) 컬럼에서 색인
df3$A형간염[is.na(df3$A형간염)] <- min(df3$A형간염, na.rm = T)
#case 2) 데이터프레임에서 색인
df3[is.na(df3$A형간염), 'A형간염'] <- min(df3$A형간염, na.rm = T)


#2) A형간염의 컬럼 이름을 A간염으로 변경(df2에서)
colnames(df2)[colnames(df2) == 'A간염'] #해당 컬럼명으로 indexing


#3) df2에서 NA를 하나라도 포함한 행 제외
#case 1) 컬럼별 선택하여 제거
df2<- df2[!is.na(df2$콜레라), ]
df2<- df2[!is.na(df2$장티푸스), ]
df2<- df2[!is.na(df2$이질), ]
df2<- df2[!is.na(df2$대장균), ]
df2<- df2[!is.na(df2$A간염), ]

#case 2) 논리연산자를 이용하여 변수로 묶음
na_col <- is.na(df2$콜레라)|is.na(df2$장티푸스)|is.na(df2$이질)|is.na(df2$대장균)|is.na(df2$A간염)
df2 <- df2[!na_col, ]




#2. professor.csv 파일을 읽고
prof <- read.csv('data/professor.csv', fileEncoding = 'cp949')

#  HPAGE가 없는 교수의 홈페이지 주소를 아래와 같이 수정
#  http://www.edu.com/email_id
email_id <- str_remove(prof$EMAIL, '[@].+')
email_id2 <- str_sub(prof$EMAIL, 1, str_locate(prof$EMAIL, '@')[, 'start']-1)

sub_hpage <- str_c('http://www.edu.com/', email_id)
prof$HPAGE[prof$HPAGE == ''] <- sub_hpage[prof$HPAGE == '']




#3 . movie_ex1.csv 파일을 읽고
df3 <- read.csv('data/movie_ex1.csv', fileEncoding = 'cp949')
head(df3)

#주말(토,일) 20,30대 연령층의 이용_비율(%)의 총 합을 출력
df3$DATE <- as.Date(str_c(df3$년, df3$월, df3$일, sep = '/'), '%Y/%m/%d')
weekend <- as.character(df3$DATE, '%A') %in% c('토요일', '일요일')
age_con1 <- df3$연령대 %in% c('20대', '30대')
  
sum(df3[weekend & age_con1, '이용_비율...'])




#4. subway2.csv 파일을 읽고
sub <- read.csv('data/subway2.csv', fileEncoding = 'cp949', skip = 1)
head(sub)

#1) 환승역의 경우 2호선 라인의 09~10 시간대의 총 승차 인원 확인
#컬럼명 변경
#case 1)
colnames(sub)[3:length(colnames(sub))] 
#case 2)
colnames(sub)[-c(1, 2)] <-  as.numeric(str_sub(colnames(sub)[-c(1,2)], 2, 3))

#2호선 환승역
transfer2 <- str_detect(sub$전체, '\\(2\\)')
sum(sub[transfer2 & sub$구분  == '승차', '9'])    #9시 시간대 컬럼 추출
sum(sub[transfer2 & sub$구분  == '승차', 9])      #9번째 컬럼 추출


#2) 하차 인원에 대해 아래와 같이 정리
#  전체      5     6       7      8
#서울역(1) 7829	48553	 110250	 233852
#시청(1)   4142	19730 	67995	 175458

#case 1)
sub[sub$전체 == '', '전체'] <- sub[!sub$전체 == '', '전체']

#case 2)
sub$전체[seq(2, length(sub$전체), 2)] <- sub$전체[seq(1, length(sub$전체), 2)]

sub[sub$구분 =='하차', -2] #조건 출력


