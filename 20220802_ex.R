#[ 연습 문제 ] plot
#data.csv 파일을 읽고 연도별 구직자 수에 대한 월 변화 추이를 선그래프로 출력
df3<- read.csv('data/data.csv', fileEncoding = 'cp949')
df3_d <- dcast(df3, 월 ~ 년도, value.var = '총구직자수')

dev.new()

plot(df3_d$'2014', type = 'o', col = '5', ylim = c(2000, 13000),
     xlab = '월', ylab = '총구직자수', 
     main = '연도별 구직자수 월 변화 추이', pch = 20, bty="o")
grid()
lines(df3_d$'2015', type = 'o', col = '6', pch = 20)
lines(df3_d$'2016', type = 'o', col = '7', pch = 20)
lines(df3_d$'2017', type = 'o', col = '8', pch = 20)
lines(df3_d$'2018', type = 'o', col = '9', pch = 20)

axis(1, at = 1:12, labels = df3_d$월)
axis(2)
legend('topright', legend = colnames(df3_d)[-1], col = 5:9, 
       lty = 1, bg = '#E5D8D8')



#[ 연습 문제 ] barplot
#상반기사원별월별실적현황_new.csv파일을 읽고
df5 <- read.csv('data/상반기사원별월별실적현황_new.csv', 
                fileEncoding = 'cp949')

#직원별 각 직원의 월별 성취도 비교 시각화
df6 <- dcast(df5, 월 ~ 이름, value.var = '성취도')
rownames(df6) <- str_c(rownames(df6), '월')
df6$월 <- NULL
df6[ , ] <- sapply(df6, as.numeric)

barplot(as.matrix(df6), beside = T, 
        col = rainbow(6), ylim = c(0, 1.3), 
        density = 40, angle = 45, 
        legend.text = rownames(df6),
        main = '직원별 월 성취도',
        xlab = '직원', ylab = '성취도',
        args.legend = list(cex = 0.8, x = 'topleft'))





#[ 연습 문제 ] barplot
#영화이용현황.csv 파일을 읽고
#요일별 연령대(10대, 20대, 30대, .., 60대 이상)별 영화관이용현항
#비교 막대그래프 시각화
t3 <- read.csv('data/영화이용현황.csv', fileEncoding = 'cp949')

t3$날짜 <- as.Date(str_c(t3$년, t3$월, t3$일, sep = '/'))
t3$요일 <- as.character(t3$날짜, '%A')
t3$그룹 <- str_c(str_extract(t3$연령대, '^[0-9]'), '0대')
t3$그룹 <- str_replace(t3$그룹, '60대|70대', '60대 이상')
t4 <- ddply(t3, .(그룹, 요일), summarise, 이용비율 = sum(이용_비율...))

t5 <- dcast(t4, 그룹 ~ 요일, value.var = '이용비율')
rownames(t5) <- t5$그룹
t5$그룹 <- NULL
t5 <- t5[, c(4, 7, 3, 2, 1, 6, 5)]

barplot(as.matrix(t5), beside = T, 
        col = rainbow(nrow(t5)), ylim = c(0, 8.5),
        density = 40, angle = c(0, 15, 30, 45, 60, 75, 90),
        legend.text = rownames(t5),
        main = '요일별 연령대별 영화관 이용현황',
        xlab = '요일', ylab = '이용비율',
        args.legend = list(cex = 0.7, x = 'topright'),
        cex.main = 2, las = 1)





#[ 실습 문제 ]
# 1. subway2.csv 파일을 읽고 승차가 가장 많은 상위 5개 역에 대해 
# 시간대별 승차인원의 증감 추이 시각화
df1 <- read.csv('data/subway2.csv', fileEncoding = 'cp949', skip = 1)

#컬럼 정리
df1 <- df1[df1$구분 =='승차', -2]   #구분 컬럼 제거
library(stringr)
df1$전체 <- str_remove(df1$전체, '\\([0-9]+\\)')
head(df1)
df1 <- aggregate(df1[, -1], list(df1$전체), sum)

#상위 5개역 추출
df1$TOTAL <- rowSums(df1[-1])
df1 <- df1[order(df1$TOTAL, decreasing = T), ]
df1_v <- df1[1:5, ]
df1_v$TOTAL <- NULL
colnames(df1_v)[-1] <- as.numeric(str_sub(colnames(df1_v)[-1], 2, 3))
colnames(df1_v)[-1] <- str_c(colnames(df1_v)[-1], '시')
head(df1_v)

#행렬 전치
df1_t <- data.frame(t(df1_v))
colnames(df1_t) <- df1_t[1, ]
df1_t <- df1_t[-1, ]
df1_t

#plot 그리기
library(colorspace)
col1 <- sequential_hcl(5, palette = 'Batlow')
dev.new()

plot(df1_t$`강 남`, type = 'o', col = col1[1], ylim = c(0, 500000),
     xaxt = 'n', yaxt = 'n', xlab = '시간', ylab = '승차인원', pch = 20,
     main = '시간대별 승차인원 증감 추이')
lines(df1_t$`잠 실`, type = 'o', col = col1[2], pch = 20)
lines(df1_t$사당, type = 'o', col = col1[3], pch = 20)
lines(df1_t$`신 림`, type = 'o', col = col1[4], pch = 20)
lines(df1_t$`삼 성`, type = 'o', col = col1[5], pch = 20)

axis(1, at = 1:nrow(df1_t), labels = rownames(df1_t))
axis(2, at = seq(1, 500000, 100000), 
     labels = c('10만', '20만', '30만', '40만', '50만'))

legend('topright', legend = colnames(df1_t), 
       col = col1, lty = 1)




# 2. 병원현황.csv 파일을 읽고
df2 <- read.csv('data/병원현황.csv', fileEncoding = 'cp949', skip = 1)
head(df2)


#컬럼 정리
library(stringr)
df2 <- df2[, -c(3, 4)]
df2 <- df2[!df2$표시과목 =='계', ]
colnames(df2)[-c(1,2)] <- str_sub(colnames(df2)[-c(1,2)], 2, 5)

#long data로 변환
library(reshape2)
df2_l <- melt(df2, na.rm = T, variable.name = '연도', value.name = '병원수')


# 1) 연도별 병원수가 가장 많은 표시과목 확인
library(plyr)
df2_s <- ddply(df2_l, .(연도, 표시과목), summarise, 
               총합 = sum(병원수, na.rm = T))

doBy::orderBy(~ -연도, ddply(df2_s, .(연도), 
                                    subset, 총합 == max(총합)))



# 2) 연평균 병원수 기준 각 상위 5개 표시과목에 대해 
#    연도별로 표시과목에 대한 비교 막대그래프 출력
library(dplyr)
library(reshape2)
df2_s <- ddply(df2_s, .(연도), mutate, 
               VRANK = rank(-총합, ties.method = 'min'))
df2_s5 <- df2_s[df2_s$VRANK %in% c(1, 2, 3, 4, 5), ]
df2_r <- dcast(df2_s5, 표시과목 ~ 연도, value.var = '총합')
rownames(df2_r) <- df2_r$표시과목
df2_r$표시과목 <- NULL
df2_r <- df2_r[ , c(5, 4, 3, 2, 1)]


install.packages('colorspace')
library(colorspace)
hcl_palettes()
dev.new()
hcl_palettes()

 
dev.new()
par(bg = '#ECE4E4')
par('mar')
par(mar = c(5.1, 6.1, 4.1, 3.1))

barplot(as.matrix(df2_r), beside = T, 
        col = qualitative_hcl(5, palette = 'Dark 2'), 
        border = F,
        ylim = c(0, 8500),
        legend.text = rownames(df2_r),
        args.legend = list(cex = 0.8, bg = '#DFD8D8', x = "topright"))

title(main = '연도별 병원수 현황 비교', cex.main = 2, font.main = 4, 
      col.main = '#545050', xlab = '연도', ylab = '병원수')


