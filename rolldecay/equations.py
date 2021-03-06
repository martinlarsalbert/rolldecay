import sympy as sp
from rolldecay.symbols import *

# General roll motion equation according to Himeno:
lhs = A_44*phi_dot_dot + B_44 + C_44
rhs = M_44
roll_equation_himeno = sp.Eq(lhs=lhs, rhs=rhs)

# No external forces (during roll decay)
roll_decay_equation_general_himeno = roll_equation_himeno.subs(M_44,0)

b44_cubic_equation = sp.Eq(B_44,B_1*phi_dot + B_2*phi_dot*sp.Abs(phi_dot) + B_3*phi_dot**3 )
b44_quadratic_equation = sp.Eq(B_44,B_1*phi_dot + B_2*phi_dot*sp.Abs(phi_dot) )
b44_quadratic_linear = sp.Eq(B_44,B_1*phi_dot)

eqs = [roll_decay_equation_general_himeno,
            b44_quadratic_equation,
            ]
roll_decay_equation_himeno_quadratic =  roll_decay_equation_general_himeno.subs(B_44,
                                                        sp.solve(b44_quadratic_equation,B_44)[0])


restoring_equation = sp.Eq(C_44,m*g*GZ)
restoring_equation_linear = sp.Eq(C_44,m*g*GM*phi)
restoring_equation_cubic = sp.Eq(C_44,C_1*phi + C_3*phi**3 + C_5*phi**5)

C_equation = sp.Eq(C,C_44/phi)
C_equation_linear = C_equation.subs(C_44,sp.solve(restoring_equation_linear,C_44)[0])
C_equation_cubic = C_equation.subs(C_44,sp.solve(restoring_equation_cubic,C_44)[0])


roll_decay_equation_himeno_quadratic_c = roll_decay_equation_himeno_quadratic.subs(C_44,sp.solve(C_equation, C_44)[0])
zeta_equation = sp.Eq(2*zeta*omega0,B_1/A_44)
d_equation = sp.Eq(d,B_2/A_44)
omega0_equation = sp.Eq(omega0,sp.sqrt(C/A_44))

eq = sp.Eq(roll_decay_equation_himeno_quadratic_c.lhs/A_44,0)  # helper equation

subs = [
    (B_1, sp.solve(zeta_equation, B_1)[0]),
    (B_2, sp.solve(d_equation, B_2)[0]),
    (C / A_44, sp.solve(omega0_equation, C / A_44)[0])

]

roll_decay_equation_quadratic = sp.Eq(sp.expand(eq.lhs).subs(subs), 0)
roll_decay_equation_quadratic = sp.factor(roll_decay_equation_quadratic, phi_dot)

roll_decay_equation_linear = roll_decay_equation_quadratic.subs(d,0)

## Cubic model:
subs = [
    (B_44,sp.solve(b44_cubic_equation,B_44)[0]),
    (C_44,sp.solve(restoring_equation_cubic,C_44)[0])
]
roll_decay_equation_cubic = roll_decay_equation_general_himeno.subs(subs)

## Equivalt linearized damping:
B_e_equation = sp.Eq(B_e,B_1+8/(3*sp.pi)*omega0*phi_a*B_2)

## Analytical
diff_eq = sp.Eq(y.diff().diff() + 2*delta*omega0*y.diff() + omega0**2*y,0)
equation_D = sp.Eq(D,sp.sqrt(1-delta**2))

lhs = y
rhs = sp.exp(-delta*omega0*t)*(y0*sp.cos(omega0*D*t) + (y0_dot/(omega0*D) + delta*y0/D)*sp.sin(omega0*D*t))
analytical_solution_general = sp.Eq(lhs,rhs)

subs = [
    (y,phi),
    (y0, phi_0),
    (y0_dot, phi_0_dot),
    (y0_dotdot, phi_0_dotdot),
    (D,sp.solve(equation_D,D)[0]),
    (delta, zeta),
]

analytical_solution = analytical_solution_general.subs(subs)
analytical_phi1d = sp.Eq(phi_dot,sp.simplify(analytical_solution.rhs.diff(t)))
analytical_phi2d = sp.Eq(phi_dot_dot,sp.simplify(analytical_phi1d.rhs.diff(t)))
