
import random
i=2
um=0
dois=0
lista=[]
while i>0:
    lista.append(random.randrange(1,3))
    i=i-1

for i in lista:
    if i==1:
        um=um+1
    else:
        dois=dois+1
print((um/len(lista))*100)
print((dois/len(lista))*100)
        
