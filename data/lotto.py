# -*- coding: utf-8 -*-
# 로또 번호 추첨 프로그램
print('로또 번호를 생성중입니다....')
import time
time.sleep(5)

import random

result = []
for i in range(0,50000) :
    lotto = []
    while len(lotto) < 6 :
        vno = random.randrange(1, 46)
        if vno not in lotto :
            lotto.append(vno)
    result.append(lotto)

lotto_num = []
for i in result :
    for j in i :
        lotto_num.append(j)
    
import numpy as np    
from pandas import Series  

lotto_cnt = []  
for i in range(1,46) :
    lotto_cnt.append(lotto_num.count(i))
      
s1 = Series(lotto_cnt, index = np.arange(1,46))   
output = list(s1.sort_values(ascending=False)[:6].index)
output.sort()

vstr = ''
for i in output :
    vstr = vstr + str(i) + ' '

print('로또 추천 번호 ======> %s' % vstr)