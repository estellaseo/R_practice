# -*- coding: utf-8 -*-

i = 1
outlist=[]
while 1 :
    vstr = input('%d번째 값을 입력하세요 : ' % i)
    if vstr == 'q' :
        break
    inlist = vstr.split(',')
    outlist.append(inlist)
    i = i + 1

for i in outlist :
    for j in i :
        print(j, end=' ')
    print()
