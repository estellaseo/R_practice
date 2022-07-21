# -*- coding: utf-8 -*-
from urllib.request import urlopen
import requests
from bs4 import BeautifulSoup
from urllib.request import HTTPError

vget = requests.get('https://sneakernews.com/category/adidas/page/2')

def f_page(index) :
    vget = requests.get('https://sneakernews.com/category/adidas/page/' + str(index)) 
                        
    if vget.status_code != 200 :
        return None
    else :
        soup = BeautifulSoup(html.text, 'html.parser')
        vlist = soup.select('div.post-content > h4 > a')
        
        vname = [ i.text for i in vlist ]
        
        return vname  
    
def adidas_crw() :
    page_num = 1
    df_result = []
    while True :
        vname = f_page(page_num)
        if vname is None :
            break
        else : 
            df_result.append({'page':page_num, 'name':vname})
        page_num += 1
    return df_result

import time
start = time.time()
df11 = adidas_crw()
end = time.time()

print(end - start)

f_page(1)
