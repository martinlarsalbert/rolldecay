import pytest
import os
import sympy as sp

import rolldecay.paper_writing as paper_writing
import rolldecay
import rolldecayestimators.equations
import rolldecayestimators.symbols

paper_path = rolldecay.paper_path

def test_find_tex_files():
    file_paths = paper_writing._find_tex_files(paper_path=paper_path)
    assert len(file_paths) > 0
    file_path = file_paths[0]
    assert '.tex' in file_path

def test_find_eq_label():
    s=r"\label{eq:roll_decay_equation_cubic}"
    eq_labels = paper_writing._find_eq_labels(s=s)
    assert len(eq_labels) > 0
    eq_label=eq_labels[0]
    assert eq_label=='roll_decay_equation_cubic'


def test_find_eq_label_multiline():
    s=r"""

\begin{equation} \label{eq:roll_decay_equation_cubic}
A_{44} \ddot{\phi} + \left(B_{1} + B_{2} \left|{\dot{\phi}}\right| + B_{3} \dot{\phi}^{2}\right) \dot{\phi} + \left(C_{1} + C_{3} \phi^{2} + C_{5} \phi^{4}\right) \phi = 0
\end{equation}
    """
    eq_labels = paper_writing._find_eq_labels(s=s)
    assert len(eq_labels) > 0
    eq_label=eq_labels[0]
    assert eq_label=='roll_decay_equation_cubic'

def test_find_eq_labels():
    s=r"""
    \label{eq:roll_decay_equation_cubic}
    \label{eq:roll_decay_equation_linear}
    """
    eq_labels = paper_writing._find_eq_labels(s=s)
    assert len(eq_labels) ==2
    eq_label=eq_labels[0]
    assert eq_label=='roll_decay_equation_cubic'

    eq_label = eq_labels[1]
    assert eq_label == 'roll_decay_equation_linear'

def test_match_sympy_equations():
    eq_labels = [
        'roll_decay_equation_cubic',
        'roll_decay_equation_linear',
    ]

    equation_dict = paper_writing._match_sympy_equations(eq_labels=eq_labels)
    assert 'roll_decay_equation_cubic' in equation_dict
    assert 'roll_decay_equation_linear' in equation_dict
    assert isinstance(equation_dict['roll_decay_equation_cubic'], sp.Eq)

def test_get_symbols():
    equation_dict={
        'roll_decay_equation_cubic':rolldecayestimators.equations.roll_decay_equation_cubic,
        'roll_decay_equation_linear':rolldecayestimators.equations.roll_decay_equation_linear,
    }
    symbols = paper_writing._get_symbols(equation_dict=equation_dict)

    assert symbols['B_1'] == rolldecayestimators.symbols.B_1
    assert symbols['B_3'] == rolldecayestimators.symbols.B_3

def test_generate_latex_nomenclature():

    symbols = {
        'B_1':rolldecayestimators.symbols.B_1,
        'B_3': rolldecayestimators.symbols.B_3,
    }

    latex_nomenclature = paper_writing._generate_latex_nomenclature(symbols=symbols)
    a=1

def test_generate_nomenclature():

    latex_nomenclature = paper_writing.generate_nomenclature(paper_path=paper_path)
    a = 1
