import sympy as sp
from rolldecay.symbols import *

lhs = phi_dot_dot + 2*zeta*omega0*phi_dot + d*sp.Abs(phi_dot)*phi_dot + omega0**2*phi
roll_diff_equation = sp.Eq(lhs=lhs,rhs=0)