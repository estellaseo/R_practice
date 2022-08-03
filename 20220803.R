#[ 시각화 외부 패키지 ] ggplot2
install.packages('ggplot2')
library(ggplot2)


#1. 기본구성
#- ggplot: 데이터 이름, 변수 정의
#- aes: 변수 정의 



#2. 시각화 함수
#- geom_bar(): 막대그래프
#- geom_line(): 선그래프
#- geom_point(): 산점도 
#- geom_boxplot(): 상자그림 
#- geom_histogram(): 히스토그램 



#3. 옵션 함수
#- xlab(), ylab()
#- xlim(), ylim()
#- ggtitle()
#- theme()
#- geom_text()
#- facet_grid()



#[ 산점도 ]
ggplot(data = ,
       mapping = aes(),
       ...)

dev.new()
ggplot(iris, aes(x = Sepal.Length, 
                 y = Sepal.Width)) +
  geom_point(size = 3,                   #점크기
             shape = 7,                  #모양
             color = 'purple')           #색상


#예제) 붓꽃 종류별 서로 다른 색 
v1 <- ggplot(iris, aes(x = Sepal.Length, 
                       y = Sepal.Width)) +
  geom_point(size = 3,                   
             shape = 10,                  
             aes(color = Species))



#예제) 붓꽃 종류별 별개의 산점도
ggplot(iris, aes(x = Sepal.Length, 
                 y = Sepal.Width)) +
  geom_point(size = 3,                   
             shape = 10,                  
             aes(color = Species)) +
  facet_grid( ~ Species)                 #1X3형식

ggplot(iris, aes(x = Sepal.Length, 
                 y = Sepal.Width)) +
  geom_point(size = 3,                   
             shape = 10,                  
             aes(color = Species)) +
  facet_grid(Species ~ .) +              #3X1형식
  xlab('X축') +
  ylab('Y축') +
  ggtitle('메인 제목', subtitle = '서브 제목')





#[ 선그래프 ]
cctv <- read.csv('data/cctv.csv', fileEncoding = 'cp949')
cctv1 <- cctv[cctv$구 == '강남구', ]
cctv2 <- cctv[cctv$구 %in% c('강남구', '강북구'), ]

#1) 단일 선그래프 
ggplot(cctv1, aes(x = 년도, y = 발생)) +
  geom_line(color = 'brown',             #색상
            size = 2,                    #두께
            linetype = 2,                #스타일
            lineend = 'round',           #끝모양
            arrow = arrow()) +           #화살표 출력
  theme_bw()



#2) 점, 선그래프 동시 출력 
ggplot(cctv1, aes(x = 년도, y = 발생)) +
  geom_line(color = 'purple') +
  geom_point(color = 'black') +
  geom_text(aes(label = 발생),
            hjust = -0.3,                #좌우 이동
            vjust = -0.7) +              #상하 이동
  theme(panel.background = element_blank())   #배경 삭제


#3) 구별 서로 다른 선 그래프 출력
ggplot(cctv2, aes(x = 년도, y = 발생)) +
  geom_line(color = 'purple') +
  geom_point(color = 'black') +
  facet_grid(구 ~ .,
             scales = 'free_y')          #y 축 단위 각자 사용

ggplot(cctv2, aes(x = 년도, y = 발생)) +
  geom_line(color = 'purple') +
  geom_point(color = 'black') +
  facet_grid( ~ 구)                      #수치 비교하기 수월함




