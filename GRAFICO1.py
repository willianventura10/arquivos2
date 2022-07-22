import random
import matplotlib.pyplot as plt
x=range(1,50)
y=[random.random()*100 for i in x]

plt.plot(x,y, color='red', linestyle="dashed")

plt.grid(True)

plt.legend(['Dados aleatórios'])

plt.title('Gráfico')

plt.xlabel('Serie')
plt.ylabel('Valores aleatórios')
plt.savefig('grafico.pdf')
plt.savefig('grafico.jpg')