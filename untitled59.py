import pandas as pd
df = pd.DataFrame({
    'col1': ['g', 't', 'n', 'w', 'n', 'g'],
    'col2': [5, 2, 5, 1, 3, 6],
    'col3': [0, 7, 2, 8,1, 2],
})
print(df)
print(df.sort_values(by=['col1']))