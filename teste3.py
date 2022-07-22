import pandas as pd
import numpy as np

df = pd.DataFrame(data=np.array([[1,2,3], [4,5,6],
[7,8,9], [40, 50, 60], [23, 35, 37]]), index = [2.5,
12.6, 4.8, 4.8, 2.5], columns=[48, 49, 50])
                                                

df.iloc[1]=5
df.iloc[2]=5

df.rename(index={2.5:'a'})
newcols = {48 : 'a','B' : 'new_column_2','C' : 'new_column_3'}

df.rename(columns=newcols, inplace = True)
df = df.replace([5, 40], [0, 35])
df = df.replace([0], [35])
print(df)

writer = pd.ExcelWriter('myDataFrame.xlsx')
df.to_excel(writer, 'DataFrame')
writer.save()

