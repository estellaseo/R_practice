#[ 연습문제 ] ggplot line graph
#마지막 연도 기준 가장 범죄 발생 횟수가 가장 많은 구 5개에 대해 
#연도별 범죄 발생 횟수 증감추이 비교 선그래프
cctv <- read.csv('data/cctv.csv', fileEncoding = 'cp949')
head(cctv)

cctv3 <- ddply(cctv, .(구), subset, 년도 == max(년도))

vname <- cctv3$구[order(cctv3$발생, decreasing = T)][1:5]
cctv4 <- cctv[cctv$구 %in% vname, ]


ggplot(cctv4, aes(x = 년도, y = 발생, color = 구)) +
  geom_line(size = 0.8, linetype = 1, lineend = 'round') + 
  theme_light() +
  theme(panel.grid = element_line(color = 'grey',
                                  size = 0.3,
                                  linetype = 3)) +
  ggtitle('연도별 범죄 발생 횟수 추이') +
  scale_color_manual(values = sequential_hcl(5, 'SunsetDark')) +
  theme(plot.title = element_text(size = 20,
                                  color = 'black',
                                  hjust = 0.5,
                                  face = 'bold'), 
        axis.title.x = element_text(size = 12,
                                    color = 'black'),
        axis.title.y = element_text(size = 12,
                                    color = 'black',
                                    vjust = 1,
                                    angle = 0)) +
  geom_text(aes(label = 발생), hjust = 1, vjust = 2, 
            color = 'black', size = 2.5)





#[ 연습문제 ]
#cars 데이터 산점도 시각화(x: speed, y: dist)
#dist에서 이상치 개수, 위치값(box plot 기준)

#- 이상치
summary(cars)

q1 <- 26.00
q3 <- 56.00
con1 <- cars$dist >= q3 + (q3 - q1) * 1.5
con2 <- cars$dist <= q1 - (q3 - q1) * 1.5

#이상치 개수
outlier <- cars$dist[con1 | con2]
length(outlier)

#이상치이면 행번호를, 정상치이면 NA 출력
v2 <- ifelse(cars$dist == outlier, rownames(cars), NA)

#시각화
dev.new()
ggplot(cars, aes(x = speed,  y = dist)) +
  geom_point(size = 1,
             color = 'navy') +
  geom_text(aes(label = v2), na.rm = T,
            hjust = -0.3, 
            vjust = -0.7,
            color = 'black') +
  theme(plot.title = element_text(size = 20,
                                  color = 'black',
                                  hjust = 0.5,
                                  face = 'bold'), 
        axis.title.x = element_text(size = 12,
                                    color = 'black'),
        axis.title.y = element_text(size = 12,
                                    color = 'black',
                                    vjust = 1,
                                    angle = 0))

boxplot(cars)





#[ 연습 문제 ] bar plot
#학과별로 교수의 직급별 평균연봉 비교
prof <- read.csv('data/professor.csv', fileEncoding = 'cp949')
prof$DEPTNO <- as.character(prof$DEPTNO)
prof2 <- ddply(prof, .(POSITION, DEPTNO), summarise, 평균연봉 = mean(PAY))

ggplot(prof2, aes(x = DEPTNO, y = 평균연봉, fill = POSITION)) + 
  geom_bar(stat = 'identity',
           position = 'dodge', na.rm = T) + 
  scale_fill_manual(values = sequential_hcl(3, 'Dark')) 




#[ 연습 문제 ] histogram
#cctv 데이터에서 구별로 cctv 수 총합을 구한 후 
#cctv수에 대한 분포를 확인하기 위한 히스토그램 출력
library(plyr)
library(colorspace)
cctv2 <- ddply(cctv, .(구), summarise, 총합 = sum(CCTV수))

ggplot(cctv2, aes(x = 총합)) +
  geom_histogram(bins = 10, closed = 'right',
                 fill = sequential_hcl(1, 'sunset'), 
                 color = NA, na.rm = T) +
  ggtitle('구별 CCTV수') +
  theme(plot.title = element_text(size = 20,
                                  color = 'black',
                                  hjust = 0.5,
                                  face = 'bold'), 
        axis.title.x = element_text(size = 10,
                                    color = 'black'),
        axis.title.y = element_text(size = 10,
                                    color = 'black',
                                    vjust = 1,
                                    angle = 0))



#[ 실습 문제 ]
# 1. taxi_call.csv 파일을 읽고
# 택시 콜 수가 많은 상위 5개 시군구에 대해
# 각 시군구별 택시 콜 수의 시간대별 변화를 
# 확인할 수 있는 선그래프 출력
t1 <- read.csv('data/taxi_call.csv', fileEncoding = 'cp949')
head(t1)

library(plyr)
library(ggplot2)
library(colorspace)
#시군구별 총합
t2 <- ddply(t1, .(발신지_시군구), summarise, VSUM = sum(통화건수))
vname <- t2$발신지_시군구[order(t2$VSUM, decreasing = T)[1:5]]
# top5 시군구 정보 추출
t3 <- t1[t1$발신지_시군구 %in% vname, ]
#구별, 시간대별 정리
t4 <- ddply(t3, .(발신지_시군구, 시간대), summarise, 통화수 = sum(통화건수))
#시각화
dev.new()
ggplot(t4, aes(x = 시간대, y = 통화수, color = 발신지_시군구)) +
  geom_line(size = 0.8) +
  scale_color_manual(values = sequential_hcl(5, 'Purple-Orange')) +
  theme(legend.background = element_rect(fill = 'gainsboro')) +
  scale_color_discrete(name = '시/군/구') +
  ggtitle('시군구별 택시 콜 수의 시간대별 변화') +
  theme(plot.title = element_text(size = 20,
                                  color = 'black',
                                  hjust = 0.5,
                                  face = 'bold'), 
        axis.title.x = element_text(size = 12,
                                    color = 'black'),
        axis.title.y = element_text(size = 12,
                                    color = 'black',
                                    vjust = 1,
                                    angle = 0)) +
  scale_x_continuous(breaks = seq(0, 23, 1),
                     minor_breaks = NULL)




# 2. 보스턴 데이터(boston.csv) 범죄율 컬럼(CRIM) top10 중 
# 10번째 범죄율 값으로 1~10위의 범죄율 값을 변경 후 
# AGE 변수 80이상의 범죄율 평균 산출(5.759)
boston <- read.csv('data/boston.csv')
head(boston)

boston[order(boston$CRIM, decreasing = T)[1:10], 'CRIM'][10]
boston[order(boston$CRIM, decreasing = T)[1:10], 'CRIM'] <- 25.9406

round(mean(boston$CRIM[boston$AGE >= 80]), 3)




# 3. 주어진 housing.csv 데이터 첫번째 행 부터 순서대로 80%까지의 데이터를 
#추출 후 'total_bedrooms' 변수의 결측값(NA)을 'total_bedrooms' 변수의 
# 중앙값으로 대체하고 대체 전 표준편차와 대체 후의 표준편차 차이(양수) 출력
# (1.975)
house <- read.csv('data/housing.csv')
head(house)

house1 <- house[1:(nrow(house) * 0.8), ]
house2 <- house[1:(nrow(house) * 0.8), ]
head(house1)

house1$total_bedrooms[is.na(house1$total_bedrooms)] <- 436
median(house1$total_bedrooms, na.rm = T)   #436

round(sd(house2$total_bedrooms, na.rm = T) - sd(house1$total_bedrooms), 3)




# 4. insurance.csv 파일을 읽고
# 데이터의 특정컬럼(bmi, charges)의 이상치
# (이상치 기준 : 평균 + (표준편차 * 1.5) 이상)를 찾아 이상치들의 합 산출 
# (6425591.75067)
insu <- read.csv('data/insurance.csv')
head(insu)

#bmi
bmi_outlier <- sum(insu$bmi[insu$bmi > (mean(insu$bmi) 
                                        + (sd(insu$bmi) * 1.5))])
#charges
charges_outlier <- sum(insu$charges[insu$charges > (mean(insu$charges) 
                                 + (sd(insu$charges) * 1.5))])


#[ 변환함수 sprintf ]
sprintf('%.5f',                         #출력 포맷('%5d', '%.5f, '%s')
        bmi_outlier + charges_outlier)  #원본 데이터(문자형 X)

sprintf('%5d', 123)                     #"  123"
sprintf('%05d', 123)                    #"00123"

sprintf('%5s', 123)
sprintf('%5s', 123)

sprintf('%.2f', 123)                    #소수점 셋째자리에서 반올림


