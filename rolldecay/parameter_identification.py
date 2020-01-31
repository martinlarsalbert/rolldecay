import inspect
import numpy as np
from scipy.optimize import curve_fit

from rolldecay.simulation import  simulate
from rolldecay.equations_lambdify import calculate_acceleration


def f_direct(df, d, omega0, zeta):

    phi_old = df['phi']
    p_old = df['phi1d']

    phi2d = calculate_acceleration(d=d, omega0=omega0, p_old=p_old, phi_old=phi_old, zeta=zeta)
    return phi2d

def fit_direct(df, p0=None):

    popt,pcov = curve_fit(f=f_direct,xdata=df,ydata=df['phi2d'],p0=p0)
    signature = inspect.signature(f_direct)
    parameter_names = list(signature.parameters.keys())[1:]

    parameter_values = list(popt)
    parameters = dict(zip(parameter_names, parameter_values))

    return parameters,pcov

def f(df, omega0, d, zeta):
    phi0 = df['phi'].iloc[0]
    phi1d0 = df['phi1d'].iloc[0]

    t = df.index
    df_sim = simulate(t=t, phi0=phi0, phi1d0=phi1d0, omega0=omega0, d=d, zeta=zeta)
    return np.array(df_sim['phi'])

def fit(df, p0=None):
    ydata = df['phi']

    if p0 is None:
        p0 = [1, 1, 1]

    popt, pcov = curve_fit(f=f, xdata=df, ydata=ydata, p0=p0)

    signature = inspect.signature(f)
    parameter_names = list(signature.parameters.keys())[1:]

    parameter_values = list(popt)
    parameters = dict(zip(parameter_names, parameter_values))

    return parameters