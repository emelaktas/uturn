#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 25 13:11:41 2017

@author: emelaktas
"""

# Demand distribution across the days of the week
import matplotlib.pyplot as plt; plt.rcdefaults()
import numpy as np
from matplotlib.ticker import FuncFormatter

plt.rcParams["font.family"] = "Times New Roman"

formatter = FuncFormatter(lambda y, pos: "%d%%" % (y))

fig, ax = plt.subplots()
ax.yaxis.set_major_formatter(formatter)

days = ('Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun')
y_pos = np.arange(len(days))
demand_proportion = [16.30, 14.08, 12.24, 13.41, 17.37, 14.49, 12.10]
 
plt.bar(y_pos, demand_proportion, align='center', alpha=0.5, color = 'gray')
plt.xticks(y_pos, days)
plt.ylabel('Percentage')

def autolabel(rects):
    """
    Attach a text label above each bar displaying its height
    """
    for rect in rects:
        height = rect.get_height()
        ax.text(rect.get_x() + rect.get_width()/2., 0.1+height,
                '%.2f%%' % float(height),
                ha='center', va='bottom')

rects1 = ax.bar(y_pos, demand_proportion)
fig, ax = plt.subplots()
ax.yaxis.set_major_formatter(formatter)
plt.bar(y_pos, demand_proportion, align='center', alpha=0.5, color = 'gray')
plt.xticks(y_pos, days)
plt.ylabel('Percentage')
autolabel(rects1)
plt.show()
fig.savefig("/Users/emelaktas/uturn/Percentage_of_daily_demand.pdf", bbox_inches='tight')
