from pylatex.base_classes.containers import Container
from pylatex import NoEscape
import sympy as sp
from sympy.physics.vector.printing import vlatex
import re

class GeneralContainer(Container):
    _latex_name = 'generalcontainer'

    def __init__(self):
        super().__init__()

    def dumps(self):
        s = ''
        for child in self:
            if isinstance(child, str):
                s_ = child
            else:
                s_ = child.dumps()
            s += s_
        return s


from pylatex.base_classes.containers import Container


class Equation(Container):
    _latex_name = 'equation'

    def __init__(self, sympy_equation, label=None):
        #super().__init__(data=NoEscape(sp.latex(sympy_equation)))
        super().__init__(data=NoEscape(vlatex(sympy_equation)))

        self.label = label

    def dumps(self):

        if self.label is None:
            s = '\\begin{equation}\n'
        else:
            s = '\\begin{equation} \\label{%s}\n' % self.label

        for child in self:
            if isinstance(child, str):
                s_ = child
            else:
                s_ = child.dumps()

            s += s_

        s += '\n\\end{equation}\n'

        return s


class Multiline(Equation):
    _latex_name = 'equation'

    def dumps(self):

        if self.label is None:
            s = '\\begin{equation}\n'
        else:
            s = '\\begin{equation} \\label{%s}\n' % self.label

        for child in self:
            if isinstance(child, str):
                s_ = child
            else:
                s_ = child.dumps()

            s += self.multiline(s_)

        s += '\n\\end{equation}\n'

        return s

    def multiline(self, s):

        s2 = s.replace('+', '+ \\\\ \n')

        s3 = '\\begin{aligned} \n %s \\\\ \n \\end{aligned}' % s2
        return s3


def hatify_symbol(symbol):
    """
    Add hat sign instead of symbol_...hat
    :param symbol:
    :return:
    """
    name = symbol.name

    if ('HAT' in symbol.name):
        name = '\hat{%s}' % symbol.name.replace('_HAT', '')

    if ('hat' in symbol.name):
        name = '\hat{%s}' % symbol.name.replace('_hat', '')

        
    name = name.replace('omega0',r'\omega_0')  # Dirty last minute fix
    name = name.replace('phi_a',r'\phi_a')  # Dirty last minute fix
       
    result = re.search('_(.+)', name)
    if result:
        replacement = '_{%s}' % result.group(1)
        name = re.subn('_(.+)', replacement, name, count=1)[0]

    return sp.symbols(name)

def hatify(equation):
    """
    Add hat sign instead of symbol_...hat in equation
    :param equation:
    :return:
    """

    new_equation = equation.copy()
    for symbol in equation.free_symbols:
        new_equation = new_equation.subs(symbol, hatify_symbol(symbol))

    return new_equation

def rename_symbol(symbol,renamers):
    
    if symbol.name in renamers:
        return renamers[symbol.name]
    else:
        return symbol

def rename(equation, renamers):
    """
    Rename certain symbols in the equation 
    :param equation:
    :param reanmers {r'\phi':r'phi_a'}
    :return:
    """

    new_equation = equation.copy()
    for symbol in equation.free_symbols:
        new_equation = new_equation.subs(symbol, rename_symbol(symbol, renamers=renamers))

    return new_equation
