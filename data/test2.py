# -*- coding: utf-8 -*-

vtxt = input('회문을 판별할 문자열을 입력하세요 : ')
vcnt = len(vtxt) // 2      # 반복 횟수
result = 0

for i in range(0, vcnt) :
    if vtxt[i] == vtxt[-(i+1)] :
        result = result + 0
    else : 
        result = result + 1

if (result == 0) & (len(vtxt) >= 2) :
    print('회문입니다')
else :
    print('회문이 아닙니다')