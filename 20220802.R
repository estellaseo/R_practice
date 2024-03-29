#[ 데이터 시각화: Data Visualization]

#1. 선그래프(산점도)
#reference: https://www.learnbyexample.org/r-plot-function/
#RGB color chart: https://www.rapidtables.com/web/color/RGB_Color.html
  
 plot(x,                     #X축 좌표(스칼라, 벡터)
      y,                     #Y축 좌표(스칼라, 벡터)
      type = 'p',            #그래프 종류
      xlim = NULL,           #x축 경계
      ylim = NULL,           #y축 경계
      xlab = ,               #x축 이름 
      ylab = ,               #y축 이름 
      main = ,               #메인 제목 
      col = ,                #색   
      lty = 1,               #선종류(1:solid, 2:dashed, 3:dotted, ...)
      pch = ,                #점종류
      cex = ,                #점크기
      lwd = ,                #선 굵기
      ann = F,               #제목 출력 여부            
      axes = F,              #축 전체 출력 여부
      xaxt = 'n',            #x축 눈금 출력 x 
      yaxt = 'n',            #y축 눈금 출력 x  
      ... )

help(plot)

 
dev.new()                    #figure 창 띄우기

#예시)
plot(c(1,2,3,4), c(10,12,8,15))                #산점도
plot(c(1,2,3,4), c(10,12,8,15), type = 'l')    #선그래프
plot(c(1,2,3,4), c(10,12,8,15), type = 'o')    #선그래프
plot(c(1,2,3,4), c(10,12,8,15), col = 'red')   #산점도
plot(c(1,2,3,4), c(10,12,8,15), type = 'o', 
     ylim = c(0,20), lty = 2, xlab = '일', 
     ylab = '판매량', main = '일자별 판매량',
     pch = 11, cex = 5, lwd = 5)


#데이터프레임 입력 가능(교차 산점도 출력) 
plot(iris[,-5],             #데이터프레임 산점도
     col = iris$Species)    #factor형 컬럼은 순서대로 1,2,3,...값을 가짐


#예시)
plot(c(1, 3, 14, 6))        #하나의 벡터 전달 시 Y값으로 간주(X는 index)


#눈금 조절
axis(side,                  #방향(1: X축, 2: Y축)
     at = ,                 #눈금(벡터)
     labels = ,             #각 눈금마다의 이름
     ... )


plot(c(1, 3, 14, 6), ann = F, axes = F) 
axis(1, 1:4)                #X축 눈금(이름 부여: lab argument)
axis(1, 1:4, lab = c('A', 'B', 'C', 'D'))

axis(2)                     #Y축 눈금(default값 그대로)




#데이터 프레임 비교 시각화(선그래프)
#컬럼별, 행별 서로 다른 선그래프 동시 출력 불가 -> package ggplot 활용


#예제) 과일별 연도별 Sales 증감 비교
library(reshape2)
library(googleVis)
Fruits

df2 <- dcast(Fruits, Year ~ Fruit, value.var = 'Sales')

plot(df2$Apples, type = 'o', col = 2, ylim = c(60, 120),
     axes = F, xlab = '연도', ylab = '판매량', main = '과일별 판매량 비교')
lines(df2$Bananas, type = 'o', col = 3)
lines(df2$Oranges, type = 'o', col = 4)

axis(1, at = 1:3, labels = df2$Year)
axis(2)


#범례 생성
legend(x,                   #범례 표현할 x축 좌표(범례 시작위치)
       y,                   #범례 표현할 y축 좌표(범례 끝위치)
       legend = ,           #각 그래프 설명
       lty,                 #선그래프 범례 표현시 라인 형태
       col,                 #색
       cex,                 #글자 크기
       fill,                #막대그래프 범례 표현시 막대 색
       title,               #범례 제목
       title.adj,           #좌우 위치
       title.col,           #범례색
       box.lty,             #범례 테두리 선종류
       box.lwd,             #테두리 선굵기
       box.col,             #테두리 색
       bty = 'n',           #테두리 출력 안함
       bg = rgb(1,0,0, alpha = 0.15))         #배경색(#9662E5)


legend(2.5,118, legend = colnames(df2)[-1], col = 2:4, lty = 1)
legend('topright', legend = colnames(df2)[-1], col = 2:4, lty = 1)
legend('topleft', legend = colnames(df2)[-1], col = 2:4, lty = 1)
legend('topright', legend = colnames(df2)[-1], col = 2:4, lty = 1)

help(legend)



#제목 표현
#세부 옵션 전달 가능

title(main = '제목',        
      sub = '소제목', 
      xlab = 'x', 
      ylab ='y',
      col.main = 2,
      col.lab = 3,
      col.sub = 4,
      font.main = 7,
      font.lab = 4,
      font.sub = 2,
      cex.main = 10,
      cex.lab = 5,
      cex.sub = 4)



#예제)
#산점도(점마다 다른 점모양과 색 전달)
dev.new()

#1) col, pch 벡터 전달
col1 <- ifelse(iris$Species == 'setosa', '#6440F2',
              ifelse(iris$Species == 'versicolor', '#2F6062', '#F07A13'))
pch1 <- ifelse(iris$Species == 'setosa', 18,
               ifelse(iris$Species == 'versicolor', 19 , 15))

plot(iris$Petal.Length, iris$Petal.Width, col = col1, pch = pch1)


#2) 각 level별로 서로 다른 그래프 출력 (각 옵션 전달 가능)
dev.new()
plot(iris$Petal.Length, iris$Petal.Width, type = 'n')

points(iris$Petal.Length[iris$Species == 'setosa'], 
       iris$Petal.Width[iris$Species == 'setosa'], 
       col = '#6440F2', pch = 18)

points(iris$Petal.Length[iris$Species == 'versicolor'], 
       iris$Petal.Width[iris$Species == 'versicolor'], 
       col = '#2F6062', pch = 19)

points(iris$Petal.Length[iris$Species == 'virginica'], 
       iris$Petal.Width[iris$Species == 'virginica'], 
       col = '#F07A13', pch = 15)

legend('topleft', legend=unique(iris$Species), 
       col = c('#6440F2', '#2F6062', '#F07A13'), pch = c(18,19,15),
       title='붓꽃종류', title.adj = 0.5,
       bg = '#FFE5CC')




#2. 막대 그래프
#범주형 자료에 대한 비교 시각화 기법

barplot(height,             #막대높이(벡터, 데이터프레임)
        width = 1,          #막대너비(벡터 전달 가능)
        space = NULL,       #막대 사이 공간
        names.arg = NULL,   
        legend.text = NULL, 
        beside = FALSE,
        horiz = FALSE, 
        density = NULL, 
        angle = 45,
        col = NULL, 
        border = par("fg"),
        main = NULL, 
        sub = NULL, 
        xlab = NULL, 
        ylab = NULL,
        xlim = NULL, 
        ylim = NULL, xpd = TRUE, log = "",
        axes = TRUE, axisnames = TRUE,
        cex.axis = par("cex.axis"), cex.names = par("cex.axis"),
        inside = TRUE, plot = TRUE, axis.lty = 0, offset = 0,
        add = FALSE, ann = !add && par("ann"), args.legend = NULL, ...)


dev.new()

barplot(c(100, 120, 150, 80), 
        col = 2:5, density = 30, angle = 90,
        names.arg = c('A', 'B', 'C', 'D'))
legend('topleft', legend = c('A', 'B', 'C', 'D'), fill = (2:5))



#데이터프레임(행렬)의 막대 그래프 출력
Fruits
t1 <- dcast(Fruits, Year ~ Fruit, value.var = 'Sales')
rownames(t1) <- t1$Year
t1$Year <- NULL

dev.new()
barplot(as.matrix(t1))              #누적 막대 그래프(stacked bar chart)
barplot(as.matrix(t1), beside = T)  #비교 막대 그래프

barplot(as.matrix(t1), beside = T, 
        col = rainbow(3), ylim = c(0, 120),
        density = 30, angle = 0,
        legend.text = rownames(t1),
        main = '과일의 연도별 판매량 비교',
        xlab = '과일', ylab = '판매량',
        args.legend = list(cex = 0.8, x = "topright"),
        cex.main = 3,
        col.main = 2,
        font.main = 2,   #2: bold, 3:italic, 4: bold italic
        cex.axis = 0.8,
        cex.lab = 1.5,
        col.lab = 5)




#[ 참고 ] 외부 팔레트 사용
library(colorspace)
hcl_palettes()                      #팔레트 종류 확인하기
dev.new()
hcl_palettes(plot = T)              #전체 팔레트 색상 확인
hcl_palettes('sequential', plot = T)#특정 팔레트 색상 확인

qualitative_hcl(7, palette = 'Pastel 1')



#하나의 figure에 여러 그래프 그리기
dev.new()
par(mfrow = c(1, 3))


#예제)
barplot(c(120, 50, 140, 230, 140),
          col = qualitative_hcl(5, palette = 'Pastel 1'))
barplot(c(120, 50, 140, 230, 140),
        col = sequential_hcl(5, palette = 'Purple-Blue'))
barplot(c(120, 50, 140, 230, 140),
        col = diverging_hcl(5, palette = 'Blue-Red'))





#3. 상자 수염 그림 Box plot
#연속형 변수(숫자형) 분포 확인, 비교
#이상치 검정 시각화 기법
#최대, 최소, 이상치, 중앙값, 사분위수, 범위(IQR)
#IQR: Q3 - Q1

#이상치 정의
#x >= Q3 + 1.5 * IQR (정상치 최대 범위)
#x <= Q1 - 1.5 * IQR (정상치 최소 범위)

#요약정보
summary(iris[, -5])

dev.new()
boxplot(iris[, -5])





#4. 히스토그램 Histogram
#연속형 변수의 분포 확인을 위한 시각화 기법
#도수분포표를 시각화한 것

hist(x,                             #연속형 변수(벡터)
     breaks = 'Sturges',            #계급 구간(벡터)
     freq = NULL,                   #빈도수 기반
     probability = !freq,           #확률 기반
     include.lowest = T,            #첫 구간 시작 값(최소값) 구간 포함 여부
     right = T,                     #오른쪽 닫힘 여부(이하)
     ...)


vheight <- c(180, 172, 168, 177, 182, 164, 161, 177, 160, 171, 166, 163)
dev.new()
hist(vheight, breaks = seq(160, 185, 5), pro = T) #pro: 밀집도(확률)



#kde: 커널 밀도 함수(히스토그램 분포화)
install.packages('ks')
library(ks)
v1 <- kde(vheight, positive = T)
plot(v1, col = col1[3])

v2 <- 2^rnorm(100)
v2_kde <- kde(v2, positive = T)
plot(v2_kde, col = col1[2])





#5. 파이차트 Pie Chart
#비교 시각화 기법

pie(x,                              #각 파이 크기(벡터) 
    labels = names(x),              #파이 이름(벡터)
    edges = 200, 
    radius = 0.8,
    clockwise = FALSE, 
    init.angle = ,
    ...)

dev.new()
pie(c(30, 70), labels = c('남', '여'), 
    radius = 0.4, init.angle = 90, clockwise = T,
    col = col1[3:4], density = 30, border = 1)


#3D 파이차트
install.packages('plotrix')
library(plotrix)

pie3D(x,                            #파이 크기(벡터)
      height = ,                    #파이 높이
      labels = ,                    #파이 이름
      labelcex = ,                  #글자 크기
      labelcol = ,                  #글자 색
      explode = ,                   #파이 간격
      ...)

v1 <- c(10, 20, 30, 40)
v2 <- c('월', '화', '수', '목')
v3 <- str_c(v2, '\n', v1, '%')

par(mfrow = c(1, 1))

lp <- pie3D(v1, height = 0.1, col = col1[1:4], labels = v3, 
            labelcex = 1, main = '요일별 파이차트', explode = 0.05)


#[ 참고 ] 라벨 좌표값 수동 설정
lp                                  #각 파이별 라벨 위치 확인
lp[1] <- 0.4                        #첫번째 파일 라벨 위치 좌표값 설정
lp[3] <- 1.8

pie3D(v1, height = 0.1, col = col1[1:4], labels = v3, 
      labelcex = 1, main = '요일별 파이차트', explode = 0.05)



#[ 참고 ] 그래프 바깥에 범례 표시 
library(googleVis)
m1 <- dcast(Fruits, Fruit ~ Year, value.var = 'Sales')

dev.new()
par('mar')                          #현재 설정된 여백 값 확인
par(mar = c(5, 4, 4, 8),
    xpd = T)                        #여백 값 변경 

barplot(as.matrix(m1[-1]), beside = T,
        col = col1[2:4], ylim = c(0, 120))

legend('topright', legend = m1$Fruit,
       fill = col1[2:4], inset = c(-0.3, 0.5))  #기존 위치에서 조절(x,y 좌표)




