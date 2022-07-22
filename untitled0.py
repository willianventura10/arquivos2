import matplotlib.pyplot as plt
import numpy as np
x = range(1, 4)

# -*- coding: utf-8 -*-
import matplotlib.pyplot as plt
import numpy as np
x = range(1, 7)
plt.plot(x, [xi * 2 for xi in x], label='Legenda 1')
plt.plot(x, [xi * 3.0 for xi in x], label='Legenda 2')
plt.plot(x, [xi / 3.5 for xi in x], label='Legenda 3')
plt.grid(True)
plt.axis(xmin=1, xmax=8, ymax=20)
plt.xlabel('EIXO X')
plt.ylabel('EIXO Y')
plt.title('GRÁFICOS DE LINHA')
plt.legend()
plt.show() 
