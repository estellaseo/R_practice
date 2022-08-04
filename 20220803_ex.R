#[ 연습문제 ] histogram
#student.csv 파일을 읽고 키에 대한 히스토그램 시각화
dev.new()
hist(stud$HEIGHT, breaks = seq(155, 185, 5), col = col1[2],
     main = '학생 키 히스토그램', xlab = '키', ylab = '학생 수')



#[ 연습문제 ] piechart
#영화이용현황.csv 파일을 읽고 각 연령대별(20, 30, 40대) 남, 여 이용 현황 비교
movie <- read.csv('data/영화이용현황.csv', fileEncoding = 'cp949')

movie$연령대별 <- str_c(str_sub(movie$연령대, 1, 1), '0대')
movie <- movie[, c('성별', '연령대별', '이용_비율...')]

movie_d <- ddply(movie, .(성별, 연령대별), 
                 summarise, 이용비율 = sum(이용_비율...))

movie_2040 <- movie_d[movie_d$연령대별 %in% c('20대', '30대', '40대'), ]
movie_2040 <- dcast(movie_2040, 성별 ~ 연령대별)


dev.new()

par(mfrow = c(1, 3))
par(mar = c(3.1, 3.1, 3.1, 2.1))
par(bg = '#F5F5F5')

hcl_palettes()                      


pie3D(movie_2040$`20대`, height = 0.1, 
      col = sequential_hcl(2, palette = 'Green-Yellow'),
      labels = str_c(round(movie_2040$`20대`/ sum(movie_2040$`20대`) * 100,
                           1), '%'),
      labelcex = 1,
      main = '20대 남녀 이용 현황', cex.main = 2,
      explode = 0.07)

legend('topleft', legend = c('남자', '여자'),
       fill = sequential_hcl(2, palette = 'Green-Yellow'))


pie3D(movie_2040$`30대`, height = 0.1, 
      col = sequential_hcl(2, palette = 'Purple-Orange'),
      labels = str_c(round(movie_2040$`30대`/ sum(movie_2040$`30대`) * 100,
                           1), '%'),
      labelcex = 1, main = '30대 남녀 이용 현황', cex.main = 2,
      explode = 0.07)

legend('topleft', legend = c('남자', '여자'),
       fill = sequential_hcl(2, palette = 'Purple-Orange'))


pie3D(movie_2040$`40대`, height = 0.1, 
      col = sequential_hcl(2, palette = 'Red-Blue'),
      labels = str_c(round(movie_2040$`40대`/ sum(movie_2040$`40대`) * 100,
                           1), '%'),
      labelcex = 1, main = '40대 남녀 이용 현황', cex.main = 2,
      explode = 0.07)

legend('topleft', legend = c('남자', '여자'),
       fill = sequential_hcl(2, palette = 'Red-Blue'))





#[ 실습문제 ]
# 한국소비자원.xlsx에는 
# 2021년 8월 한 달 동안의 상품에 대한 각 판매처별 가격 정보가 있다
# 상품별 가격 변동(분산)이 가장 큰 5개 상품에 대해
# 각 판매처별 가격을 비교하는 그래프 출력

install.packages('readxl')
library(readxl)
library(stringr)

df1 <- read_excel('data/한국소비자원.xlsx')
head(df1)

#Data cleansing
df1$판매가격 <- str_remove(df1$판매가격, '\\.0')
df1$판매가격[str_detect(df1$판매가격, '[:punct:]')] <- NA
df1$판매가격 <- as.numeric(df1$판매가격)

#분산 top5
library(plyr)
df1_v <- ddply(df1, .(상품명), summarise, 분산 = var(판매가격))
vname <- df1_v[order(df1_v$분산, decreasing = T)[1:5], '상품명']

df1_f <- df1[df1$상품명 %in% vname, c('상품명', '판매가격', '판매업소')]

#판매업소 그룹핑
unique(df1_f$판매업소)
df1_f$판매업소[str_detect(df1_f$판매업소, '이마트')] <- '이마트'
df1_f$판매업소[str_detect(df1_f$판매업소, 'GS')] <- 'GS더프레시'
df1_f$판매업소[str_detect(df1_f$판매업소, '롯데슈퍼')] <- '롯데슈퍼'
df1_f$판매업소[str_detect(df1_f$판매업소, '농협')] <- '농협'
df1_f$판매업소[str_detect(df1_f$판매업소, '현대백화점')] <- '현대백화점'
df1_f$판매업소[str_detect(df1_f$판매업소, '시장')] <- '시장'


df1_f2 <- df1_f[df1_f$판매업소 %in% c('이마트', 'GS더프레시', '롯데슈퍼', 
                        '농협', '현대백화점', '시장'), ]

#판매업소별 가격
df1_f3 <- ddply(df1_f2, .(상품명, 판매업소), summarise, 
                가격 = mean(판매가격))
library(reshape2)
df1_f4 <- dcast(df1_f3, 판매업소 ~ 상품명, value.var = '가격')
rownames(df1_f4) <- df1_f4$판매업소
df1_f4$판매업소 <- NULL

#시각화
dev.new()
library(colorspace)

barplot(as.matrix(df1_f4), beside = T, 
        col = qualitative_hcl(6, palette = 'Dark 2'), 
        border = T, ylim = c(0, 60000),
        legend.text = rownames(df1_f4),
        args.legend = list(cex = 0.9, x = 4, 10))

title(main = '판매처별 판매가격 비교', cex.main = 2, font.main = 4, 
      col.main = '#545050', xlab = '품목명', ylab = '판매가격')


