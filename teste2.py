import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
dados = {'país':['Brasil','Argentina','Paraguai'],
        'ano':[2000,2002,2004],
        'população':[11800.30,20000.8,6000.3]}
df=pd.DataFrame(dados)
#print (df)
#plt.bar(dados["país"],dados["população"])

dados2={'A':[1,4,7],'B':[2,5,8],'C':[3,6,9]}
df2=pd.DataFrame(dados2)
#print(df2)

df3 = pd.DataFrame(data=np.array([[1,2,3], [4,5,6],
[7,8,9]]), columns=[48,49,50])


#print(df3.loc[2])
#print(df3.iloc[2])

df3['D']=df3.index
df3['E']=df3.index

df4 = pd.DataFrame(data=np.array([[1,2,3], [4,5,6],
[7,8,9], [40, 50, 60], [23, 35, 37]]), index = [2.5,
12.6, 4.8, 4.8, 2.5], columns=[48, 49, 50])
                                                

df4.reset_index().drop_duplicates(subset= 'index',
keep='last').set_index('index')
print(df4.drop_duplicates([48], keep='last'))

df4.drop(df4.columns[[2]], axis=1)
print(df4.drop(df4.index[2]))



print(df4)



