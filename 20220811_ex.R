# [ 연습 문제 ]
# iris data set의 설명변수 데이터만 가지고 계층적 군집 분석 수행
# (군집거리별 시각화)

# 변수 스케일링 전, 변수 선택 전)
d1 <- dist(iris[,-5])
m1_sin <- hclust(d1, method='single')
m1_com <- hclust(d1, method='complete')
m1_cen <- hclust(d1, method='centroid')
m1_ave <- hclust(d1, method='average')
m1_ward1 <- hclust(d1, method='ward.D')
m1_ward2 <- hclust(d1, method='ward.D2')

dev.new()
par(mfrow=c(2,3))    # 2X3 화면 분할
plot(m1_sin, hang = -1, cex = 0.8)
rect.hclust(m1_sin, k = 3)

plot(m1_sin, hang = -1, cex = 0.8)
rect.hclust(m1_sin, k = 3)

plot(m1_com, hang = -1, cex = 0.8)
rect.hclust(m1_com, k = 3)

plot(m1_cen, hang = -1, cex = 0.8)
rect.hclust(m1_cen, k = 3)

plot(m1_ave, hang = -1, cex = 0.8)
rect.hclust(m1_ave, k = 3)

plot(m1_ward1, hang = -1, cex = 0.8)
rect.hclust(m1_ward1, k = 3)

plot(m1_ward2, hang = -1, cex = 0.8)
rect.hclust(m1_ward2, k = 3)

# 변수 스케일링 후, 변수 선택 후)
d1 <- dist(scale(iris[,3:4]))

m1_sin <- hclust(d1, method='single')
m1_com <- hclust(d1, method='complete')
m1_cen <- hclust(d1, method='centroid')
m1_ave <- hclust(d1, method='average')
m1_ward1 <- hclust(d1, method='ward.D')
m1_ward2 <- hclust(d1, method='ward.D2')

dev.new()
par(mfrow=c(2,3))    # 2X3 화면 분할
plot(m1_sin, hang = -1, cex = 0.8)
rect.hclust(m1_sin, k = 3)

plot(m1_com, hang = -1, cex = 0.8)
rect.hclust(m1_com, k = 3)

plot(m1_cen, hang = -1, cex = 0.8)
rect.hclust(m1_cen, k = 3)

plot(m1_ave, hang = -1, cex = 0.8)
rect.hclust(m1_ave, k = 3)

plot(m1_ward1, hang = -1, cex = 0.8)
rect.hclust(m1_ward1, k = 3)

plot(m1_ward2, hang = -1, cex = 0.8)
rect.hclust(m1_ward2, k = 3)




#[ 연습 문제 ]
#iris 데이터를 사용하여 표준화, 변수선택을 고려한 군집분석 수행
#군집의 수의 변화에 따른 tot.withinss 변화 시각화
iris_scale[, 3:4]

vwithinss <- c()
set.seed(0)        #반복 시 샘플링 씨드 고정
for (i in 2:10) {
  m1 <- kmeans(iris_scale[, 3:4], centers = i)
  vwithinss <- c(vwithinss, m1$tot.withinss)
}

dev.new()
plot(2:10, vwithinss, type = 'o', col = 'red', xlab = '군집수')




