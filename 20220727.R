#[ 정렬 ]

#1. order
order(...,                                  #정렬대상(벡터)
      na.last = T,                          #NA 배치 순서
      decreasing = F,                       #내림차순 정렬 여부
      method = c('auto', 'shell', 'radix')) #정렬방식


#예시)
v1 <- c(1, 3, 10, 2, 6)
order(v1)                                   #[1] 1 4 2 5 3 : 배치순서 리턴
                                            #정렬 결과를 즉시 리턴하지 않음
v1[order(v1)]                               #indexing으로 정렬 결과 리턴
v1[order(v1, decreasing = T)] 


#emp 테이블에서 급여를 낮은 순으로 정렬
emp[order(emp$SAL), ]


#emp에서 부서별로 급여 낮은 순 정렬 
#1차 정렬: 부서, 2차 정렬: 급여
emp[order(emp$DEPTNO, emp$SAL), ]

#부서별로 급여가 높은 순 정렬 
emp[order(emp$DEPTNO, emp$SAL, decreasing= c(F, T)), ]




#2. sort
sort(x,                                     #정렬대상
     decreasing = F,                        #내림차순 정렬 여부
     ...)                                   #기타 옵션

sort(v1)                                    #정렬 결과를 즉시 리턴
sort(emp$SAL)                               #데이터프레임 정렬 불가




#3. doBy::orderBy
install.packages('doBy')
library(doBy)

orderBy(formula = ,                         # ~ 정렬컬럼1 + 컬럼2 + ...
        data)                               #데이터(데이터프레임)


#예시) 부서별 급여 오름차순으로 정렬
orderBy(~ DEPTNO + SAL, emp)

#부서별(오름차순), 급여(내림차순) 정렬
orderBy(~ DEPTNO - SAL, emp)

#예시) 성별(남, 여순), 키(내림차순) 정렬
orderBy(~ -GENDER, HEIGHT, stud)




#4. plyr::arrange
library('plyr')

arrange(df,                                 #데이터(데이터프레임)
        ...)                                #정렬컬럼(나열형)


#예시) 부서별(오름차순) 급여(내림차순) 정렬
arrange(emp, DEPTNO, -SAL)
arrange(emp, DEPTNO, desc(SAL))


#예시) 성별(남, 여순), 키(내림차순) 정렬
arrange(stud, desc(GENDER), -HEIGHT)





#[ DB connect ]
#업무 환경 

#ORACLE INSTALL
#1) oracle server 설치: instance(메모리) + DB(디스크)
#2) oracle client 설치: instance(메모리)

#현 시스템 구성 환경
#orange 호환 문제(64bit oracle과 연결 불가)로 인해 32bit oracle 설치함
# R(64bit) <-> oracle(32bit) 호환 문제 발생 
#oracle(64bit) client 설치 


#데이터베이스 접속 정보
#IP: 192.168.17.8 - DB가 설치된 서버의 IP
#PORT :               1521 (서비스포트)
#userid: scott
#password: oracle
#SID(service identifier)


#[ 참고 ] DB 접속 정보 확인 방법 
#1) IP 확인: cmd - ipconfig 입력 - IPv4 주소 확인
#2) port, SID 확인: cmd - lsnrctl status - PORT = , 서비스 인스턴스 확인


#통신 객체
#1) ORACLE : C:\app\itwill\product\11.2.0\client_1\ojdbc6.jar
#2) R: RJDBC packages

install.packages('RJDBC')
library(RJDBC)


# DB connection
JDBC(driverClass = ,         #담당자 이름
     classPath = )           #담당자 위치


jdbcdriver <- JDBC(driverClass = 'oracle.jdbc.OracleDriver',    #driver 이름
     classPath = 'C:/app/itwill/product/11.2.0/client_1/ojdbc6.jar') 
     #driver 위치

con1 <- dbConnect(jdbcdriver,                                   #driver 정보
                 'jdbc:oracle:thin:@192.168.17.8:1521:orcl',    #DB 접속정보
                 'scott',                                       #userid
                 'oracle')                                      #password


#sql 실행
dbGetQuery(conn = ,           #connection 이름
           statement = )      #SQL 문장

#1) 조회
dbGetQuery(con1, 'select ename, sal, nvl(comm, 0) COMM from emp')


#2) 수정(insert, update, delete): auto commit
dbSendUpdate(con1, 
             "insert into emp_t1(empno, ename, sal) 
              values (1111, 'a', 9000 )")


#3) 데이터 생성 
dbWriteTable(con1, 'table1', df2) 
