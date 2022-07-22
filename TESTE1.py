import numpy as np

arquivo = "d:\python\iriss.csv"

dados=np.genfromtxt(arquivo,delimiter=",",names=True)

dados["comprimento"]/(dados["largura"]*2)

from matplotlib import pyplot as plt

plt.bar(dados["comprimento"],dados["largura"])


