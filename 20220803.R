#[ 시각화 외부 패키지 ] ggplot2
install.packages('ggplot2')
library(ggplot2)


#1. 기본구성
#- ggplot: 데이터 이름, 변수 정의
#- aes: 변수 정의 



#2. 시각화 함수
#- geom_point(): 산점도 
#- geom_line(): 선그래프
#- geom_bar(): 막대그래프
#- geom_boxplot(): 상자그림 
#- geom_histogram(): 히스토그램 



#3. 옵션 함수
#- xlab(), ylab()
#- xlim(), ylim()
#- ggtitle()
#- theme()
#- geom_text()
#- facet_grid()



#1. 산점도
ggplot(data = ,
       mapping = aes(),
       ...)

dev.new()
ggplot(iris, aes(x = Sepal.Length, 
                 y = Sepal.Width)) +
  geom_point(size = 3,                        #점크기
             shape = 7,                       #모양
             color = 'purple')                #색상


#예제) 붓꽃 종류별 서로 다른 색 
v1 <- ggplot(iris, aes(x = Sepal.Length, 
                       y = Sepal.Width)) +
  geom_point(size = 3,                   
             shape = 10,                  
             aes(color = Species))


#[ 제목 변경 ]
#메인 제목, x축, y축 옵션 수정 
dev.new()
v1

v1 +
  ggtitle('메인제목') +
  xlab('X축 제목') + ylab('Y축 제목') +
  theme(plot.title = element_text(size = 20,         #메인 타이틀 크기
                                  color = 'red',     #메인 타이틀 색상
                                  hjust = 0.5),      #메인 타이틀 위치
        axis.title.x = element_text(size = 15,       #X축
                                     color = 'blue'),
        axis.title.y = element_text(size = 10,
                                    color = 'green',
                                    vjust = 0.5,
                                    angle = 0,       #Y축 라벨 각도
                                    face = 'bold'))  #Y축 글꼴


#[ 테마 변경 ]
# - theme_bw(), theme_void(), theme_grey(), theme_classic(),
# - theme_dark(), theme_gray(), theme_light(), theme_linedraw(), 
# - theme_minimal() 등

v1 +
  theme_bw()

v1 +
  theme_grey()

v1 + 
  theme_classic()

v1 + 
  theme_minimal()



#예제) 붓꽃 종류별 별개의 산점도
ggplot(iris, aes(x = Sepal.Length, 
                 y = Sepal.Width)) +
  geom_point(size = 3,                   
             shape = 10,                  
             aes(color = Species)) +
  facet_grid( ~ Species)                      #1X3형식

ggplot(iris, aes(x = Sepal.Length, 
                 y = Sepal.Width)) +
  geom_point(size = 3,                   
             shape = 10,                  
             aes(color = Species)) +
  facet_grid(Species ~ .) +                   #3X1형식
  xlab('X축') +
  ylab('Y축') +
  ggtitle('메인 제목', subtitle = '서브 제목')


#[ 격자 수정 ]
dev.new()
v1+
  theme(panel.grid = element_blank())

v1+
  theme(panel.grid = element_line(color = '#8ccde3',
                                  size = 0.3,
                                  linetype = 2))

#[ 격자 간격 ]
v1 +
  scale_y_continuous(breaks = seq(0, 5, 0.1))





#2. 선그래프 
cctv <- read.csv('data/cctv.csv', fileEncoding = 'cp949')
cctv1 <- cctv[cctv$구 == '강남구', ]
cctv2 <- cctv[cctv$구 %in% c('강남구', '강북구'), ]

#1) 단일 선그래프 
ggplot(cctv1, aes(x = 년도, y = 발생)) +
  geom_line(color = 'brown',                  #색상
            size = 2,                         #두께
            linetype = 2,                     #스타일
            lineend = 'round',                #끝모양
            arrow = arrow()) +                #화살표 출력
  theme_bw()                                  #베이직 테마



#2) 점, 선그래프 동시 출력 
ggplot(cctv1, aes(x = 년도, y = 발생)) +
  geom_line(color = 'purple') +
  geom_point(color = 'black') +
  geom_text(aes(label = 발생),                #value 출력
            hjust = -0.3,                     #좌우 이동
            vjust = -0.7) +                   #상하 이동
  theme(panel.background = element_blank())   #배경 삭제


#3) 구별 발생 추이 각각 선그래프 출력
ggplot(cctv2, aes(x = 년도, y = 발생)) +
  geom_line(color = 'purple') +
  geom_point(color = 'black') +
  facet_grid(구 ~ .,
             scales = 'free_y')               #y 축 단위 각자 사용

ggplot(cctv2, aes(x = 년도, y = 발생)) +
  geom_line(color = 'purple') +
  geom_point(color = 'black') +
  facet_grid( ~ 구)                           #수치 비교하기 수월함


#4) 하나의 공간에 구별 발생 추이 선그래프 출력
dev.new()
ggplot(cctv2, aes(x = 년도, y = 발생, color = 구)) +
  geom_line(size = 1.3) +
  geom_point(size = 1.5, color = 'brown') +
  scale_color_manual(values = sequential_hcl(5, 'SunsetDark')) #라인 색상




#[ 범례 ]
#1) 범례 지우기 
v1 +
  theme(legend.position = 'none')

#2) 범례 위치 변경 
v1 +
  theme(legend.position = 'top') 

#3)범례 바탕, 테두리 변경 
v1 + 
  theme(legend.background = element_rect(color = 'black',     #테두리 색상
                                         fill = 'gainsboro')) #배경 색상

#4) 범례 제목 변경 
v1 + 
  scale_color_discrete(name = '종류')




#[ 눈금(axis tick) 변경 ]
g1 <- ggplot(cctv4, aes(x = 년도, y = 발생, color = 구)) +
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

g1 + xlim(2002, 2015)                         #X축 눈금 범위 지정

g1 +
  scale_x_continuous(limit = c(2002, 2014))   #X축 눈금 범위 지정

g1 +
  scale_x_continuous(breaks = seq(2002, 2014, 1),
                     minor_breaks = NULL)     #X축 눈금 단위 연단위로 변경





#3. 막대 그래프 bar plot
std <- read.csv('data/student.csv', fileEncoding = 'cp949')

library(plyr)
std2 <- ddply(std, .(GRADE), summarise, VMEAN = mean(HEIGHT))


#1) X값만 전달 시 > count value 출력
ggplot(std2, aes(x = GRADE)) +
  geom_bar(fill = 'purple',                    #바 색상
           color = 'black',                    #테두리 색상
           alpha = 0.5)                        #투명도

#2) X, Y값 전달 시
ggplot(std2, aes(x = GRADE, y = VMEAN)) +
  geom_bar(fill = 'purple',                    
           color = 'black',                    
           alpha = 0.5, 
           stat = 'identity')                  #Y값 출력시 선언 필요

#3) 그룹별 서로 다른 막대 출력 
library(stringr)
std$GENDER <- ifelse(str_sub(std$JUMIN, 7, 7) == 1, '남', '여')
std3 <- ddply(std, .(GRADE, GENDER), summarise, VMEAN = mean(HEIGHT))

ggplot(std3, aes(x = GRADE, y = VMEAN, fill = GENDER)) +
  geom_bar(stat = 'identity',
           position = 'dodge') +               #없을 경우 stacked bar
  ylim(0, 230)                                 #Y값 범위 설정


#2, 3학년 평균 키 성별 모두 표현 
std3 <- rbind(std3, c(2, '여', NA))
std3 <- rbind(std3, c(3, '남', NA))
str(std3)
std3$VMEAN <- as.numeric(std3$VMEAN)

ggplot(std3, aes(x = GRADE, y = VMEAN, fill = GENDER)) +   #fill = 성별
  geom_bar(stat = 'identity',
           position = 'dodge', na.rm = T) + 
  scale_fill_manual(values = sequential_hcl(2, 'SunsetDark')) +
  ylim(0, 230)





#4. 상자그림 box plot
#하나의 상자그림
ggplot(iris, aes(y = Sepal.Length)) +
  geom_boxplot()

#그룹별 상자그림
ggplot(iris, aes(x = Species, y = Sepal.Length)) +
  geom_boxplot(outlier.color = 'red',
               outlier.shape = 4,
               outlier.size = 5)





#5. 히스토그램 Histogram
#도수 기반)
ggplot(std, aes(x = HEIGHT)) +
  geom_histogram(
    #binwidth = 5,                             #계급 크기
    #bins = 10,                                #막대 수 지정
    breaks = seq(140, 190, 10),                #계급 구간 지정
    closed = 'right',                          #닫힘 방향(left_close:[a, b))
    fill = 'lightblue',                        #바 색상
    color = 'black',                           #테두리 색상
    na.rm = T                                  #NA 포함 시 경고 생략
  )


#확률 기반)
ggplot()
ggplot(cctv2, aes(x = 총합)) +
  geom_histogram(aes(y = ..density..),         #확률을 나타내도록
                 breaks = seq(0, 6500, 500),
                 fill = sequential_hcl(1, 'sunset'), 
                 color = NA, na.rm = T) +
  geom_density(color = 'red')                  #분포곡선 출력





#6. 파이차트 pie chart








