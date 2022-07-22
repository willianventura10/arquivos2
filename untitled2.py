import numpy as np
import pandas as pd
df2 = pd.DataFrame(np.random.rand(7, 4), columns=['A', 'B', 'C', 'D'])
df2.plot.area();
df2.plot.area(stacked=False);
