"""
This is a translation of Carl-Johans implementation in Matlab to Python
"""
import os.path
import numpy as np
from numpy import tanh, exp
import pandas as pd
import rolldecay

data_path = os.path.join(rolldecay.notebooks_path,'studies','Bw0_S175.csv')
data = pd.read_csv(data_path, sep=';')

def Bw0_S175(w):

    w_vec = data['w_vec']
    b44_vec = data['b44_vec']
    Bw0 = np.interp(w, w_vec,b44_vec)
    return Bw0

def Bw_S175(w, V, d, g=9.81):

    Bw0 = Bw0_S175(w)
    OMEGA = w * V / g
    zeta_d = w**2 * d / g
    A1 = 1 + zeta_d**(-1.2) * exp(-2 * zeta_d)
    A2 = 0.5 + zeta_d**(-1) * exp(-2 * zeta_d)

    Bw_div_Bw0 = 0.5 * (
                ((A1 + 1) + (A2 - 1) * tanh(20 * (OMEGA - 0.3))) + (2 * A1 - A2 - 1) * exp(-150 * (OMEGA - 0.25)**2))
    bw44 = Bw0 * Bw_div_Bw0

    return bw44

