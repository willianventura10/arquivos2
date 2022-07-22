# -*- coding: utf-8 -*-
"""
Created on Thu Aug 19 17:04:53 2021

@author: w3110
"""
import numpy as np
import matplotlib.pyplot as plt
x=np.arange(5)
y=[2*x for i in x]
plt.plot(x,y);
plt.show()
plt.savefig('grafico.pdf')
print(y)