#[ 자료 구조 ]
#1) 벡터: 1차원
#2) 리스트: 1차원에 가까운 key-value 자료구조(2차원 X)
#3) 행렬: 2차원
#4) 배열: 다차원
#5) 데이터프레임: 2차원


#[ 리스트 ]
#key-value 구조

#1. 생성
l1 <- list(name = c('홍길동', '최길동', '박길동'),
           sal = c(1000, 2000, 3000))
class(l1)
l1


#2. 색인
l1$name                        #벡터 리턴
l1['name']                     #리스트 리턴
li[['name']]                   #벡터 리턴


#3. 수정
l1['name', 2] <- '김길동'      #불가
l1$name[2] <- '김길동'         #가능

l1['name'][2]                  #NULL (리스트 색인 불가)
l1[['name']][2]                #가능 (벡터 색인 가능)


#key 추가/삭제
l1$comm <- c(100, 200, 300)    #추가
l1$comm <- NULL                #삭제





#[ 문자열 함수 ] 
#내장 함수 + 외부 패키지(stringr)
install.packages('stringr')
library(stringr)


#stringr:: 참고 - 외부패키지임을 알려주기 위해 (함수명::) 추가


#1) 대소치환
str_to_upper('abcd')   #uppercase
str_to_lower('ABCD')   #lowercase
str_to_title('abcd')   #Camelcase

str_to_lower(emp$ENAME) == 'smith'




#2) 문자열 추출(str_sub, substr)
#str_sub(string, start(추출시작위치), end(끝위치))
#추출시작위치 음수 가능, 끝위치 생략 시 끝까지 추출
str_sub('abcde', 2, 4)

#substr(x, start, stop)
#추출시작위치음수 가능, 끝위치 생략 불가
substr('abcde', 2, 4)




#3) 문자열 치환/삭제(str_replace)
#str_replace(string, pattern(찾을 문자열), replacement(바꿀 문자열))
str_replace('abcde', 'ab', 'AB')

str_replace('abcde', 'ab', '')           #삭제
str_replace('abcdeaa', 'a', '')          #하나의 a만 삭제
str_replace_all('abcd1abcd', 'a', '')    #모든 a 삭제


str_replace_all('abcd1abcd', 1, '')      #숫자형 입력 불가
str_replace_all('abcd1abcd', '1', '')    #문자열 전달


str_replace_all('abcd1abcd', '1', 0)     #숫자형 입력 불가
str_replace_all('abcd1abcd', '1', '0')   #문자열 전달


v1 <- c(1, 2, 3, NA, 4)
length(v1)
str_replace(v1, NA, '')                 #NA 입력 불가(문자만 가능)
str_replace(v1, '3', NA)                #NA 입력 불가(문자만 가능)


#str_replace_na(string, replacement(치환 값) = 'NA'(default))
str_replace_na(v1, '3')                 #문자형 3으로 치환



#4) 문자열 삭제(str_remove)
#str_remove(string, pattern(삭제 대상))

str_remove(card$의복, ',')
str_remove_all('abcaaa', 'a')



#[형 확인 함수]
# is.array()
# is.character()
# is.numeric()
# is.na()



#5) 패턴확인(str_detect)

#[ 정규표현식 ]
#https://cran.r-project.org/web/packages/stringr/vignettes/regular-expressions.html
#str_replace(), str_remove(), str_split(), str_locate 등에서 사용됨

# ^ : 시작
# $ : 끝
# []: 문자열 묶음
# . : 한자리 글자(예: .b - 위치 상관없이 _b를 포함하는)
# * : 0회 이상
# + : 1회 이상
# {n, m} : n회 이상 m회 이하
# | : or
# \\ : 일반기호화

v1 <- c('abcdd', 'Amdf', 'baaa', 'dffa!', '20220718', '가나다')
str_detect(v1, 'a')                #a를 포함하는
str_detect(v1, '^a')               #a로 시작하는
str_detect(v1, 'a$')               #a로 끝나는
str_detect(v1, '^[aA]')            #a, A로 시작하는
str_detect(v1, '[0123456789]')     #숫자를 포함하는
str_detect(v1, '[:digit:]')
str_detect(v1, '[0-9]')            #%-%일 때 -: 범위를 지정하는 기호로 해석
str_detect(v1, '[0-9-]')           #숫자와 하이픈(-)을 포함하는
str_detect(v1, '[A-z]')            #영어를 포함하는
str_detect(v1, '[가-힣]')          #한글을 포함하는
str_detect(v1, '[:alpha:]')        #글자를 포함하는(문자 모두)
str_detect(v1, '[:punct:]')        #특수기호를 포함하는
str_detect(v1, '^[aA].+[fF]$')     #a로 시작, f로 끝나는(대소구분 X)
str_detect(v1, '[dD]{2}')          #d가 연속 2회 이상 반복(대소구분 X)
str_detect(v2, '[fF]{2, 2}')       #f가 연속 2회만 반복(대소구분 X)
str_detect(v1, '^a|c$')            #a로 시작 또는 c로 끝나는
str_detect(v1, '[.]')              #마침표(.)를 포함하는



#6) 문자열 분리(str_split)
str_split('a:b:c', ':')            #리스트 자료구조로 리턴
str_split('a:b:c', ':')[2]         #일부 원소 추출불가(2층 색인)
str_split('a:b:c', ':')[[1]][2]    #추출 가능



#7) 문자열 결합(str_c, paste)
str_c(a1,                          #원본 문자열
      sep = '/',                   #분리구분기호(여러 대상간 원소의 결합)
      collapse = NULL)             #분리구분기호(한 대상 내 원소의 결합)

str_c('a', 'b', 'c', sep = '/')
str_c(c('a', 'b', 'c'), collapse = '/')

paste(a1,
      sep = ' ',
      collapse = NULL)

paste('a', 'b', 'c', sep = '/')
paste(c('a', 'b', 'c'), collapse = '/')



#8) 문자열 삽입(str_pad)
str_pad(string = ,                          #원본 문자열
        width = ,                           #총 자리수
        side = c('left', 'right', 'both'),  #삽입방향
        pad = ' ')                          #삽입할 문자열

str_pad('506', 4, 'left', '0')              #결과: '0506'



#9) 공백 삭제(str_trim)
str_trim(sting = ,                          #원본 문자열
         side = c('left', 'right', 'both')) #삭제 방향

str_trim('   ab   ', 'left')                #왼쪽 공백 삭제
str_trim('   ab   ', 'right')               #오른쪽 공백 삭제
str_trim('   ab   ')                        #양쪽 모두 공백 삭제



#10) 문자열 위치(str_locate_all)
str_locate(string = ,                       #원본 문자열
           pateern = )                      #찾고자 하는 문자열(정규식 가능)

str_locate('ababa', 'a')                    #최초 발견 'a'위치 리턴
str_locate('ababa', 'ab')                   #두글자 이상을 경우 start != end

str_locate_all('ababa', 'a')

str_locate_all('ababa', 'a')[[1]][2, 'start']



#11) 반복(str_dup)
str_dup(string = ,              #원본 문자열
        times = )               #반복 횟수

str_dup('abc', 5)
str_dup(c('abc', 'ab'), 5)


#[ 참고 ] 벡터 원소의 반복
rep(x,                          #원본 문자열         
    each = ,                    #각각 반복
    time = )                    #전체 반복

rep(c('abc', 'ab'), each = 5)
rep(c('abc', 'ab'), time = 5)



#12) 문자열 개수(str_count)
str_count(string = ,            #원본 문자열
          pattern = )           #찾을 문자열(정규식 가능)

v1 <- c('abc', 'ab', 'ddddd')
str_count(v1, 'a')              #a가 포함된 횟수
str_count(v2, '[ab]')           #a 또는 b가 포함된 횟수
str_count(v2, '.')              #각 문자열의 크기기


length(v1)                      #벡터 원소의 개수
length(emp)                     #2차원 컬럼의 수
ncol(emp)                       #2차원 컬럼의 수
nrow(emp)                       #2차원 행의 수


