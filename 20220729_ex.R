#[ 연습문제 ] rank
#emp.csv 파일을 읽고
#부서별 연봉이 낮은 순서대로 순위를 부여했을 때 두번째로 작은 직원 추출
emp <- read.csv('data/emp.csv')

emp <- ddply(emp, .(DEPTNO), mutate, VRANK = rank(-SAL, ties.method = 'min'))
emp[emp$VRANK == 2, ]



#[ 연습문제 ] stack: melt
#melt_ex.csv와 아래 가격 데이터를 사용하여 연도별 매출 총액 출력
df_price <- data.frame(year = c(2000,2000,2000,2001,2001,2001),
                       name = c('latte','americano','mocha','latte',
                                'americano','mocha'),
                       price = c(1500,1000,2000,1800,1200,2300))

m1 <- read.csv('data/melt_ex.csv')
m2 <- melt(m1, id.vars = c('year', 'mon'),
           variable.name = 'menu',
           value.name = 'qty')
head(m2)
head(df_price)

library(dplyr)
#데이터 조인
m3 <- merge(m2, df_price, by.x = c('year', 'menu'), by.y = c('year', 'name'))
#매출 계산
m3$total <- m3$qty * m3$price
#연도별 그룹핑
ddply(m3, .(year), summarise, VSUM = sum(total))



#[ 연습문제 ] stack: melt
#2000-2013년_연령별실업율_40-49세.csv를 long data로 변경 후 연도별 실업율 평균
df1 <- read.csv('data/2000-2013년_연령별실업율_40-49세.csv', 
                fileEncoding = 'cp949')

colnames(df1)[-1] <- str_sub(colnames(df1)[-1], 2,5)
df2 <- melt(df1, id.vars = '월', variable.name = '연도', value.name = '실업율')
ddply(df2, .(연도), summarise, 평균_실업율 = mean(실업율))




#[ 실습문제 ]
# 1. 교습현황.csv 파일을 읽고
df1 <- read.csv('data/교습현황.csv', fileEncoding = 'cp949', skip = 1)
head(df1)

#필요한 컬럼 선택
df1_n <- df1[-(1:4)]

#stack
df1_s <- melt(df1_n, id.vars = '교습과정',
     variable.name = '연도', value.name = '매출')

#컬럼 정리
df1_s$매출 <- as.numeric(str_remove_all(df1_s$매출, ','))
df1_s$year <- str_sub(df1_s$연도, 2, 5)
df1_s$month <- str_remove(str_sub(df1_s$연도, 7), '.$')
df1_s$연도 <- NULL


# 1) 교습과정별 연도별 매출 총액 확인
ddply(df1_s, .(교습과정, year), summarise, VSUM = sum(매출))


# 2) 교습과정별 월별 매출 총액 확인
df1_mon <- ddply(df1_s, .(교습과정, month), summarise, VMON_SUM = sum(매출))


# 3) 교습과정별로 매출이 가장 높은 월 확인
ddply(df1_mon, .(교습과정), subset, VMON_SUM == max(VMON_SUM))




# 2. 부동산_매매지수현황.csv 파일을 읽고
df2 <- read.csv('data/부동산_매매지수현황.csv', 
                fileEncoding = 'cp949', skip = 1)
head(df2)

#컬럼 정리
df2 <- df2[-2, ]
colnames(df2)[1] <- '연도'
colnames(df2)[seq(2, ncol(df2), 2)] <- str_sub(colnames(df2)[seq(2, ncol(df2), 2)], 1, 2)
colnames(df2)[seq(3, ncol(df2), 2)] <- colnames(df2)[seq(2, ncol(df2), 2)]
colnames(df2)[-1] <- str_c(colnames(df2)[-1], df2[1, -1], sep = '_')
df2 <- df2[-1, ]

df2_s <- melt(df2, id.vars = '연도',
              variable.name = '지역', value.name = '지수')

df2_s$year <- str_sub(df2_s$연도, 1, 4)
df2_s$지수 <- as.numeric(df2_s$지수)
df2_s <- df2_s[c(4, 2, 3)]
head(df2_s)


# 1) 지역별로 매매지수가 가장 활발한 연도 출력
df2_act <- df2_s[str_detect(df2_s$지역, '활발함'), ]

df2_act2 <- ddply(df2_act, .(지역, year), summarise, 매매지수 = sum(지수))
ddply(df2_act2, .(지역), subset, 매매지수 == max(매매지수))


# 2) 연도별, 지역별로 활발함과 한산함 지수의 평균 출력
ddply(df2_s, .(year, 지역), summarise, 지수_평균 = round(mean(지수), 3))


# 3) 연도별 활발함이 높은 순서대로 상위 3개 지역 출력
df2_act3 <- ddply(df2_act, .(year, 지역), summarise, 매매지수 = sum(지수))
df2_rank <- ddply(df2_act3, .(year), mutate, 
                  순위 = rank(-매매지수, ties.method = 'min'))
orderBy(~year + 순위, df2_rank[df2_rank$순위 %in% c(1, 2, 3), ])



