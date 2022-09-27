
# ===================================================================
# 시계열 분석
# ===================================================================
# 과거 값을 사용하여 미래 값을 예측
# 대부분의 시계열 모델은 정상성을 가정함



# [ 정상성 ]
# - 시점에 상관 없이 시계열의 특성이 일정하다는 의미
# - 시계열 분석을 위해서 정상성 가정이 필요
# - 평균이 일정하고 분산이 시점에 의존하지 않음
# - 공분산은 단지 시차에만 존재하고 시점 차제에는 의존하지 않음



# [ 비정상성 ]
# - 평균이 시간 흐름에 따라 꾸준히 증가(추세 존재)
# - 분산, 공분산이 일정하지 않음



# [ 정상성 확인 ]
# 1. 시각화
# - plot
# - Q-Q plot
# - ACF(AutoCorrelation Function : 자기상관함수)
# - PACF(Partial AutoCorrelation Function : 부분자기상관함수)

# 2. 정상성 검정
# - ADF(Augmented Dickey-Fuller test)



# [ 정상성 변환 ]
# 비정상성의 데이터를 정상성을 만족할 수 있도록 변환하는 작업

# 1. 로그 변환 : 분산이 일정하지 않고 점차 증가할 경우

# 2. 차분 
#    - 평균이 일정하지 않는 경우 평균을 일정하게 만들어주는 효과
#    - 추세를 제거하기 위한 용도
#    - 1차 차분 : Yt - Yt-1
#    - 2차 차분 : 1차 차분의 결과를 다시 차분



# [ 분해 시계열 ]
# 시계열에 영향을 주는 일반적인 요인을 시계열에서 분리해 분석하는 방법

# 1) 추세 요인
# 2) 계절 요인
# 3) 순환 요인
# 4) 불규칙 요인



# [ 시계열 모형 종류 ]
# 1. 자기회귀모형(AR : Auto-Regressive)
#    - 현 시점의 자료를 p시점 전의 과거 자료로 설명
#    - 백색잡음(오차항)은 서로 독립, 평균이 0, 분산이 일정한 정규분포를 
#      따른다는 가정

# 2. 이동평균모형(MA : Moving Average)
#    - 시간이 지날수록 관측치의 평균값이 지속적으로 증가 혹은 감소 추세
#    - 현 시점 자료를 유한 개의 백색잡음(오차)의 선형 결합으로 표현
#    - 정상성 가정 필요 없음

# 3. 자귀 회귀 누적 이동평균 모형 ARIMA
#    - Auto Regressive Integrated Moving Average
#    - ARIMA(p, d, q) : AR(p) + diff(d) + MA(q)
#    - 분산이 일정하지 않은 경우 변환 필요
#    - 추세가 존재한다면 차분 필요(ARIMA의 경우 차분 연산 포함)
ARIMA(0, 0, 1) = MA(1)
ARIMA(2, 0, 0) = AR(2)

# p, q 추천
# - ACF : q 추천, q차 이후 자기상관이 0이 되는 시점 확인
# - PACF : p 추천, p차 이후 자기상관이 0이 되는 시점 확인
dev.new()
par(mfrow = c(2, 1))
Acf(DNile)                     # forecast::Acf 
                               # > 1차 시점부터 자기 상관계수 출력 
acf(DNile)                     # stat::acf
#                              # > 0차 시점부터 자기 상관계수 출력

dev.new()
par(mfrow = c(2, 1))
Acf(DNile)
Pacf(DNile)
# > p = 2, q = 1인 모델 고려해볼 수 있음
# DNile은 이미 1차 차분 진행  d = 0



# [ ARIMA 모델 학습 ]
# 1. 시계열 데이터 만들기
sales <- c(18, 33, 44 ,34, 56, 78, 34, 32, 50, 60)
tsales <- ts(sales, start = c(2000, 1), frequency = 12)

dev.new()
plot(tsales)


# 2. 단순이동평균으로 데이터 평활화하기
install.packages('forecast')
library(forecast)

dev.new()
par(mfrow = c(2, 2))
plot(Nile, main = 'Raw Time Series')
plot(ma(Nile,3), main = 'Simple Moving Averages(k=3)',
     ylim = c(min(Nile), max(Nile)))
plot(ma(Nile,7), main = 'Simple Moving Averages(k=7)',
     ylim = c(min(Nile), max(Nile)))
plot(ma(Nile,15), main = 'Simple Moving Averages(k=15)',
     ylim = c(min(Nile), max(Nile)))
# 단순이동평균선을 통해 추세를 확인할 수 있음


# 3. 차분을 통한 추세 감소(비정상성 > 정상성)
library(tseries)
ndiffs(Nile)                   # 차분 추천 > 1차 차분 추천

DNile <- diff(Nile, differences = 1)

# 4. 시각화를 사용한 정상성 확인
dev.new()
par(mfrow = c(1, 2))
plot(Nile)                     # 원본 데이터는 추세가 보임
plot(DNile)                    # 추세가 감소 혹은 보이지 않음


# 5. 정상성 검정(ADF)
# H0 : 비정상 시계열
# H1 : 정상 시계열

library(tseries)

# 1) raw data
adf.test(Nile)

# Augmented Dickey-Fuller Test
# data:  Nile
# Dickey-Fuller = -3.3657, Lag order = 4, p-value = 0.0642
# alternative hypothesis: stationary

# > Nile 데이터는 정상성을 만족한다고 보기 어려움


# 2) 1차 차분 후
adf.test(DNile)

# Augmented Dickey-Fuller Test
# data:  DNile
# Dickey-Fuller = -6.5924, Lag order = 4, p-value = 0.01
# alternative hypothesis: stationary

# > DNile 데이터는 정상성을 만족함


# [ ACF, PACF ]
# : ARIMA 모델 결정 용도로도 사용(자기 상관 확인)

# 1. ACF 자기상관함수
# AC1 = Yt, Yt-1의 자기상관
# AC2 = Yt, Yt-2의 자기상관
# > q 결정 요인

# 2. PACF 부분자기상관함수
# PAC1 = Yt, Yt-1의 자기상관
# PAC2 = Yt, Yt-2의 자기상관, 중간값의 영향력 제거(Yt-1 시점 값 제거)
# PAC3 = Yt, Yt-3의 자기상관, 중간값의 영향력 제거(Yt-1, Yt-2 시점 값 제거)
# > p 결정 요인


# ARIMA : AR(p) + I(d) + MA(q)

dev.new()
par(mfrow = c(2, 1))

library(forecast)
Acf(DNile)
Pacf(DNile)

# 파란색 점선 구간 : 자기 상관이 없음 95%의 신뢰구간



# 잔차 적합도 확인
# 1) 정규성 검정
dev.new()
qqnorm(fit1$residuals)
qqline(fit1$residuals)

# 2) 독립성 검정(오차의 자기상관성)
# H0 : 잔차가 서로 독립적
# H1 : 잔차가 서로 독립적이지 않음
Box.test(fit1$residuals, type = 'Ljung-Box')

# 자동 ARIMA 모델 > p, d, q 추천
fit <- auto.arima(Nile)
fit



# ARIMA 모델 수정
fit2 <- arima(Nile, order = c(1, 1, 1))

# 1) 잔차 적합도 검정
# 1-1) 정규성 테스트
dev.new()
par(mfrow = c(1, 2))
qqnorm(fit2$residuals)
qqline(fit2$residuals)

hist(fit2$residuals)

# shapiro.test
shapiro.test(fit2$residuals)

# 1-2) 독립성 테스트
Box.test(fit2$residuals, type = 'Ljung-Box')
# p-value = 0.7431로 잔차가 서로 독립적

# 1-3) 등분산성 테스트
dev.new()
plot(fit2$residuals, type = 'p')


# 2) 회귀 계수의 유의성 검정
coeftest(fit2)

# 3) 예측
forecast(fit2, 3)

# 예측결과 시각화(신뢰구간 포함)
dev.new()
plot(forecast(fit2, 3), xlab = 'year', ylab = 'Nile Flow')

# 예시) AirPassengers 데이터를 사용한 승객수 예측
# 1. 정상성 확인
# 1) plot
dev.new()
plot(AirPassengers)

# 2) ADF test
# H0 : 비정상성
# H1 : 정상성
adf.test(AirPassengers)
# > 정상성을 만족한다는 test 결과, but 시각화 시 추세, 분산 증가로 확인
#   비정상성에 가까운 것으로 결론


# 2. 정상성 변환
# 1) 분산 증가 감소 > 로그 변환
Air_log <- log(AirPassengers)

par(mfrow = c(2, 1))
plot(AirPassengers)
plot(Air_log)


# 2) 차분
ndiffs(AirPassengers)        # 1차 차분 추천
DAir <- diff(AirPassengers, differences = 1)

par(mfrow = c(2, 1))
plot(AirPassengers)
plot(DAir)


# 3) 시계열 분해
fit <- stl(AirPassengers, s.window = 'period')
dev.new()
plot(fit)

fit$time.series


# 4) ACF, PACF 확인
dev.new()
par(mfrow = c(2, 1))
Acf(DAir)
Pacf(DAir)


# 5) auto.arima 확인
auto.arima(Air_lof)       
# ARIMA(0,1,1)(0,1,1)[12] 
# p d q seasonal(p,d,q), seasonal periods


# 6) 모형 확인
fit1 <- arima(Air_log, 
              order = c(0,1,1), 
              seasonal = list(order = c(0,1,1), periods = 12))


# 7) 유의성 검정
coeftest(fit1)

# z test of coefficients:
#   
#        Estimate Std. Error z value  Pr(>|z|)    
# ma1  -0.401828   0.089644 -4.4825 7.378e-06 ***
# sma1 -0.556945   0.073100 -7.6190 2.557e-14 ***


# 8) 잔차 적합도 검정
dev.new()
par(mfrow=c(1,2))
qqnorm(fit1$residuals)
qqline(fit1$residuals)

plot(fit1$residuals, type='p', main = 'residuals scatter', ylab='residuals')

Box.test(fit1$residuals, type = 'Ljung-Box')
# Box-Ljung test
# 
# data:  fit1$residuals
# X-squared = 0.030651, df = 1, p-value = 0.861


# 9) 예측
forecast(fit1, 12)

dev.new()
plot(forecast(fit1, 12*5), xlab='time', ylab='log(AirPassengers)')





