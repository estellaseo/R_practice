# 문자열 함수: stringr
install.packages('stringr')
library(stringr)

#stringr::str_replace()   참고: 외부패키지임을 알려주기 위해 (함수명::) 추가
#stringr::str_sub()

#str_sub(string, start = 1L, end = -1L)
str_sub('abcde', 3, 4)
