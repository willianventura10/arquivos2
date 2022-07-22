import pandas as pd
arquivo = "d:\python\iris2.xlsx"
df = pd.read_excel(arquivo)
df.head()

print('PRODUTO')
for i in df.index:
    print(df['PRODUTO'][i])
    print(df['CUSTO'][i])

dados = {'país':['Brasil','Argentina','Paraguai'],
        'ano':[2000,2002,2004],
        'população':[11800.30,20000.8,6000.3]}
df2=pd.DataFrame(dados)
df2.to_excel('teste2.xlsx')

