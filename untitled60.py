# -*- coding: utf-8 -*-
"""
Created on Thu Dec 30 11:27:46 2021

@author: w3110
"""
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from datetime import datetime


df = pd.DataFrame({'Animal': ['Falcon', 'Falcon',
                              'Parrot', 'Parrot'],
                   'Max Speed': [380., 370., 24., 26.]})
print(df.pivot())




