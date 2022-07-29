#[ 연습문제 ] break
#1~100의 누적합을 구하되, 3000이 넘는 시점을 확인, 그 시점까지의 누적합

vresult <- 0
for (i in 1:100) {
  vresult <- vresult + i
  if (vresult > 3000) {
    break
  }
}
print(i)
print(vresult)



#[ 연습문제 ]
#seoul.new.txt로 게시글번호, 제목, 날짜, 조회수 컬럼을 갖는 데이터 프레임 생성
t1 <- read.csv('data/seoul_new.txt', 
               header = F, fileEncoding = 'cp949', 
               sep = '|')

게시글번호 <- str_extract(t1$V1, '[0-9]+')
조회수 <- str_trim(str_extract(t1$V1, '[0-9]+ $'))
날짜 <- str_extract(t1$V1, '[0-9]+-[0-9]+-[0-9]+')

vresult <- t1$V1
for (i in c(게시글번호, 날짜, 조회수)) {
  vresult <- str_remove(vresult, i)
}     
제목 <- str_remove(str_remove(vresult, ' --  '), '^.')

str_remove(vresult, 날짜)

df_seoul <- data.frame(게시글번호, 제목, 날짜, 조회수)
head(df_seoul)



#[ 참고 ] 정규 표현식 다양한 표현 
# \d: 숫자 
# \D: 숫자가 아닌 것 
# \w: 문자, 숫자, _ 
# \W: 문자, 숫자, _가 아닌 것 
# \s: 공백 
# \S: 공백이 아닌 것 
# [[a-z][:punct:]]: 영문자, 특수문자 동시 전달


#정규 표현식으로 그룹핑하여 전달
df_seoul2 <- str_match(t1$V1, '([0-9]+) (.+) ([0-9]+-[0-9]+-[0-9]+) ([0-9]+)')
view(df_seoul2)

#sol2)
#스칼라 테스트
vtext <- str_split(str_trim(vresult[1]), ' ')[[1]]
vtext[1]
vtext[length(vtext)]
vtext[length(vtext)-1]
str_c(vtext[2:(length(vtext)-2)], collapse = ' ')


#전체 적용
vno <- c(); vcnt <- c(); vdate <- c(); vsub <- c(); # ; (명령어의 순차적 실행)
for (i in vresult) {
  vtext <- str_split(str_trim(i), ' ')[[1]]
  vno <- c(vno, vtext[1])
  vcnt <- c(vcnt, vtext[length(vtext)])
  vdate <- c(vdate, vtext[length(vtext)-1])
  vsub <- c(vsub, str_c(vtext[2:(length(vtext)-2)], collapse = ' '))
}

df_seoul2 <- data.frame(게시물번호 = vno, 
                        제목 = vsub, 
                        날짜 = vdate, 
                        조회수 = vcnt)
head(df_seoul2)




#[ 연습문제 ]
# 1. movie_ex1.csv 파일을 읽고
movie <- read.csv('movie_ex1.csv', fileEncoding = 'cp949')
head(movie)

# 1) 요일별로 이용비율이 가장 높은 연령대
vdate <- str_c(movie$년, movie$월, movie$일, sep = '/')
vdays <- as.character(as.Date(vdate), '%A')

df_age <- data.frame(날짜 = vdate, 요일 = vdays, 
                     연령대 = movie$연령대, 이용비율 = movie$이용_비율...)
head(df_age)

df_age2 <- ddply(df_age, .(요일, 연령대), summarise, 비율 = sum(이용비율))
df_age3 <- ddply(df_age2, .(요일), subset, 비율 == max(비율))

#요일순 나열
df_age3[c(4, 7, 3, 2, 1, 6, 5), ]    #indexing을 통한 직접 나열



# 2) 서울시 내에서 구별로 이용비율이 가장 높은 연령대
#서울시가 포함된 데이터 추출(%like%)
install.packages('DescTools')
library(DescTools)


movie[movie$지역.시도 %like% '서울%', ]
movie[str_detect(movie$지역.시도, '서울'), ]

movie[movie$지역.시도 == '서울특별시', ]
df_gu <- data.frame(movie[movie$지역.시도 == '서울특별시', 
                    c('지역.시군구', '연령대', '이용_비율...')])
head(df_gu)
df_gu2 <- ddply(df_gu, .(지역.시군구, 연령대), 
                summarise, 비율 = sum(이용_비율...))
ddply(df_gu2, .(지역.시군구), subset, 비율 == max(비율))




# 2. project_songpa_data.csv 파일을 읽고 동별 LAT, LON의 평균
# 단, 동이름은 다음과 같이 표현
# 풍납1동 => 풍납동
# 잠실본동 작은도서관(좌측진입구) => 잠실본동
# 장지동택지개발지구 => 장지동
# 잠실나루역 => 잠실나루역 or 잠실동

proj <- read.csv('data/project_songpa_data.csv', fileEncoding = 'cp949')
head(proj)
proj$name[is.na(str_extract(proj$name, '[가-힣0-9]+동'))]
proj$name[is.na(str_extract(proj$name, '[가-힣0-9]+[동역]'))] #동 or 역
proj[proj$name == '잠실나루역', 'name'] <- '잠실동'

vdong <- str_remove(str_extract(proj$name, '[가-힣0-9]+동'), '[0-9]+')
df_proj <- data.frame(동 = vdong, LAT = as.numeric(proj$LAT), 
                      LON = as.numeric(proj$LON))

ddply(df_proj, .(동), summarise, mean_LAT = mean(LAT), mean_LON = mean(LON))
  