import random
import numpy as np
import matplotlib.pyplot as plt

list = []
picklist = []
dict = {'Salmon':0.2, 'Seabass':0.1, 'Flounder':0.5, 'Tuna':0.2}
def generate():

    for key in dict.keys():
        values = dict.get(key)
        print(key)
        count = values*10
        while(count > 0):
            add = key
            list.append(add)
            count -= 1
    #print(list)

def pick():
    rng = random.choice(list)
    #print(rng)
    return(rng)

def plot():
    generate()
    pickcount = 1000
    while(pickcount > 0):
        bleh = pick()
        if(bleh == 'Salmon'):
            picklist.append(1)
        if(bleh == 'Seabass'):
            picklist.append(2)
        if(bleh == 'Flounder'):
            picklist.append(3)
        if(bleh == 'Tuna'):
            picklist.append(4)
        pickcount -= 1
    #print(picklist)
    #names = ['Salmon', 'Seabass', 'Flounder', 'Tuna']
    #matplotlib.axes.set_xticklabels(names, rotation=45, rotation_mode="anchor", ha="right")
    plotlist = np.asarray(picklist)
    plt.hist(plotlist,range=[1,4])
    plt.show()

plot()