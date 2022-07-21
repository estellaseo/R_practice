# -*- coding: utf-8 -*-
"""
Created on Thu Sep 30 10:17:05 2021

@author: TEA
"""
# 외부 파일 불러오기 
def f_read_txt(file, sep=',', fmt = str) :
    # 파일 불러오기
    c1 = open(file)
    v2 = c1.readlines()       # 각 라인을 리스트의 각 원소로 불러오기
    c1.close()
    
    # 불러온 파일 내용을 중첩 리스트로 변환
    outlist = []
    for i in v2 :
        vlist = i.replace('\n','').split(sep)
        inlist = []
        for j in vlist :
            inlist.append(fmt(j))
        outlist.append(inlist)
    
    return outlist


# 외부 파일로 저장하기
def f_write_txt(file, obj, sep=',', fmt = '%.2f') :
    c1 = open(file, 'w') 
    for inlist in obj : 
        vstr = ''
        for i in inlist :
            vtxt = fmt % i
            vstr = vstr + vtxt + sep
        vstr = vstr.rstrip(sep)
        c1.writelines(vstr + '\n')   
    c1.close()
    
    