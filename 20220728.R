#[ 반복 제어문 ]
#반복문 안에서 반복문의 흐름 제어 

#1. next
#반복문의 일부 조건에 대해서 명령 실행 생략
#예시) 1-100까지 반복하다 50일 때 skip
#continue in Python

for (i in 1:10) {
  if (i == 5) {
    next
  }
  print(i)
}



#2. break
#반복문 일부 조건 달성 시 반복문 중단 
#예시) 1-100까지 반복하다 50일 때 중단 후 다음 프로그램 실행
#break in Python

for (i in 1:10) {
  if (i == 5) {
    break
  }
  print(i)
}

for (i in 1:5) {
  cmd1
  cmd2
  for (j in 1:3) {
    cmd3
    if ( ... ) {
      break
    }
    cmd4             #break 시 실행 X
  }
  cmd3               #break와 관계없이 항상 실행
}




#[ 외부 파일 입출력 ]
#1. read.csv
#(,)로 분리 구분된(default: csv 파일) 파일을 불러올 때 주로 사용
help(read.csv)

read.csv(file,                       #파일명
         header = TRUE,              #header = T : 첫 행을 컬럼화
         sep = ",",                  #분리구분기호 sep = ",",
         na.strings = "NA",          #NA 처리할 문자열
         nrows = -1,                 #불러올 행의 수
         skip = 0,                   #skip할 행의 수
         fileEncoding = "",          #인코딩 옵션
         ...)


read.table('data/read_test.csv')
read.table('data/read_test.csv', sep = ',', header = T)  #same as read.csv
read.csv('data/read_test.csv', skip = 1)
read.csv('data/read_test.csv', col.names = c('a', 'b'))


t1 <- read.csv('data/read_test.csv')
str(t1)
t2 <- read.csv('data/read_test.csv', 
               na.strings = c('-', '?', '!', 'null', '.')) #정규표현식 전달 X
str(t2)



#2. read.table
#공백 또는 탭으로 분리된 파일을 불러올 때 주로 사용 

read.table(file, 
           header = FALSE, 
           sep = "", 
           ...)



#3. scan
#벡터의 형태로 외부 파일 불러오기
help(scan)

scan(file = "",                              #파일명
     what = double(),                        #문자로딩여부
     sep = "",                               #분리구분기호
     na.strings = "NA",
     flush = FALSE, fill = FALSE, strip.white = FALSE,
     quiet = FALSE, blank.lines.skip = TRUE, multi.line = TRUE,
     comment.char = "", allowEscapes = FALSE,
     fileEncoding = "", encoding = "unknown", text, skipNul = FALSE)

scan('data/file2.txt', sep = ',')            #동일형 아닐 경우 에러 발생
scan('data/file2.txt', sep = ',', what = "") #문자형으로 불러오기


scan()                                       #사용자가 직접 입력 가능(숫자)
scan(what = "")                              #문자형으로 반환



#4. readLines
#라인 단위의 벡터 불러오기 
#활용 예시) 한줄 단위로 불러올 때 의미가 있는 데이터(한줄 감상평 등)
readLines('data/file1.txt')                  #[1] "1,2,3" "4,5,6"



#5. readline
#사용자에게 스칼라 입력을 요구할 때 사용 
readline()                                   #스칼라 문자형으로 반환

readline('파일을 삭제할까요?(Y/N): ')



#6. write.csv
#파일 쓰기(R의 객체를 외부 파일로 저장)
help(write.csv)

Usage
write.table(x,                    #객체명
            file = "",            #저장할 파일명
            sep = " ",            #컬럼명 분리구분 기호
            row.names = TRUE,     #행이름 저장 여부
            col.names = TRUE,     #열이름 저장 여부
            fileEncoding = "")    #인코딩 옵션

write.csv(df_seoul2, 'data/df_result.csv', fileEncoding = 'cp949')




#[ 최대값/최소값 위치 찾기 ]
which.min()                        #최소값 위치
which.max()                        #최대값 위치


m1 <- matrix(c(1:12), nrow = 3)
which.max(m1)                      #1차원 리턴
apply(m1, 2, which.max)            #컬럼별 최대값 위치
apply(m1, 1, which.max)            #행별로 최대값 위치




#[ Sampling ]
#데이터 분석 시 예측 모델링의 정확도(예측 점수)를 확인하기 위함
#train data and test data have to be separated

nrow(iris) * 0.7
iris[1:105, ]                      #Wrong sampling (편향된 class 값을 가짐)

#1. sample
sample(x,                          #데이터
       size,                       #추출 개수
       replcae = F,                #복원추출 여부
       prob = NULL)                #추출 비율


#1) row number
rn <- sample(1:150, size = 105)    #random numbers for indexing

iris[rn, ]                         #train data set (70%)
iris[-rn, ]                        #test data set (30%)



#2) group number
rn2 <- sample(1:2, size = 150, replace = T, prob = c(0.7, 0.3))

iris[rn2 == 1, ]                   #train data set(70%)
iris[rn2 == 2, ]                   #test data set(70%)

table(rn2)                         #종류별 count


