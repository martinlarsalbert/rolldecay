from pylatex.base_classes.containers import Container
from pylatex import NoEscape
import sympy as sp
from sympy.physics.vector.printing import vlatex


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
