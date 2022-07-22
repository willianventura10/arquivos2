import pandas as pd


df=pd.read_csv("d:\python\iriss.csv")

df.hist('comprimento')
df.plot.line()
df.plot.bar()
df.plot.area()
df.plot.pie(y='comprimento')
