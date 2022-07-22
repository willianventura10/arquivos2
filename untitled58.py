import pandas as pd
df = pd.DataFrame({'A':['a','a','c','d','e1','f','e','e','g'],'B':[1,2,8,5,3,4,2,6,8],'/' 
                   'C':[8,7,6,5,4,3,2,1,0]})
df2 = df.groupby(['A'])['B'].agg(['sum'])
print(df)
print('')
print(df2)
print(df2.sort_values(by=['sum']))
#print(df)
#print(df)
