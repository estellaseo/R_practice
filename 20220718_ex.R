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
str_detect(v2, '^[:alpha:].+[@].+[.].+$')
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



#[ 연습문제 ]