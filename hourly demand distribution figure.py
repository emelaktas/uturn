#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 25 17:01:55 2017

@author: emelaktas
"""
import matplotlib.pyplot as plt; plt.rcdefaults()
import numpy as np
from matplotlib.ticker import FuncFormatter

plt.rcParams["font.family"] = "Times New Roman"

formatter = FuncFormatter(lambda y, pos: "%d%%" % (y))
fig, ax = plt.subplots()
ax.yaxis.set_major_formatter(formatter)

hours = ('6am', '7am', '8am', '9am', '10am', '11am', '12pm', '1pm', '2pm', '3pm', '4pm', '5pm', '6pm', '7pm', '8pm', '9pm', '10pm', '11pm')

demand_prop_hr = (1.51,	4.69,	6.70,	8.11,	7.84,	6.34,	4.90,	2.88, 1.27,	3.42,	7.39,	8.07,	8.46,	8.72,	9.61,	7.42, 2.34,	0.31)

y_pos = np.arange(len(hours))

rects2 = ax.bar(y_pos, demand_prop_hr)
fig, ax = plt.subplots()
ax.yaxis.set_major_formatter(formatter)
plt.bar(y_pos, demand_prop_hr, align='center', alpha=0.5, color = 'gray')
plt.xticks(y_pos, hours)
plt.ylabel('Percentage')
# autolabel(rects2)
for tick in ax.get_xticklabels():
    tick.set_rotation(90)
    
plt.show()
# save figure
fig.savefig("/Users/emelaktas/uturn/Percentage_of_hourly_demand.pdf", bbox_inches='tight')
