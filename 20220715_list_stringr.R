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




