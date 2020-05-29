import rolldecay
import os
import matplotlib.pyplot as plt
import re
import sympy as sp
import rolldecayestimators.equations

# \label{eq:roll_decay_equation_cubic}
regexp_label = re.compile(pattern=r'\label{eq\:([^}]+)', flags=re.MULTILINE)

def save_fig(fig, name, full_page=False):
    """
    Save a figure to the paper
    :param fig: figure handle
    :param name: figure name (without extension)
    :return: None
    """

    fname = os.path.join(rolldecay.paper_figures_path,'%s.pdf'%name)
    fig.tight_layout()

    if full_page:
        width = 10
        height = width*1.618

    else:
        width = 10
        height = width / 1.618

    fig.set_dpi(300)
    fig.set_size_inches(width, height)
    plt.tight_layout()

    fig.savefig(fname=fname,dpi=300)

def generate_nomenclature(paper_path=None):
    """
    Generate a nomenclature based on the equation labels in the tex files under paper_path folder
    :param paper_path: None->Default is present paper
    :return:
    """
    eq_labels=[]

    if paper_path is None:
        paper_path=rolldecay.paper_path

    file_paths = _find_tex_files(paper_path=paper_path)
    for file_path in file_paths:
        with open(file_path, mode='r') as file:
            s = file.read()

        eq_labels+=_find_eq_labels(s=s)

    equation_dict = _match_sympy_equations(eq_labels=eq_labels)
    symbols = _get_symbols(equation_dict=equation_dict)
    latex_nomenclature = _generate_latex_nomenclature(symbols=symbols)

    return latex_nomenclature

def _find_tex_files(paper_path):

    file_paths = []
    for root, dirs, files in os.walk(paper_path, topdown=False):
        for name in files:
            if os.path.splitext(name)[-1]=='.tex':
                path = os.path.join(root, name)
                file_paths.append(path)

    return file_paths

def _find_eq_labels(s:str):
    return regexp_label.findall(string=s)

def _match_sympy_equations(eq_labels):
    avaliable_equation_dict = {key: value for key, value in rolldecayestimators.equations.__dict__.items() if isinstance(value, sp.Eq)}
    equation_dict = {}

    for eq_label in eq_labels:
        if eq_label in avaliable_equation_dict:
            equation_dict[eq_label] = avaliable_equation_dict[eq_label]

    return equation_dict

def _get_symbols(equation_dict:dict):

    symbols = {}
    for name,eq in equation_dict.items():
        free_symbols = {symbol.name:symbol for symbol in eq.free_symbols}
        symbols.update(free_symbols)

    return symbols

def _latex_unit(unit:str):
    latex_unit=unit.replace('*',r'\cdot ')
    latex_unit='$%s$'%latex_unit
    return latex_unit


def _generate_latex_nomenclature(symbols):

    """
    The method should create something like this:

    \mbox{}
    \nomenclature{$c$}{Speed of light in a vacuum inertial frame \nomunit{$m/s$}}
    \nomenclature{$h$}{Planck constant}
    \printnomenclature
    """

    content = ''
    for name,symbol in symbols.items():
        assert isinstance(symbol,sp.Symbol)

        description = ''
        unit = ''

        if hasattr(symbol,'description'):
            description=symbol.description

        if hasattr(symbol, 'unit'):
            unit=_latex_unit(unit=symbol.unit)

        latex = symbol._repr_latex_()

        row = r'\nomenclature{'+latex+'}{'+description+ r'\nomunit{' + unit + '}}\n'
        content+=row

    latex_nomenclature = r"\mbox{}" + '\n' + content + '\n' + r"\printnomenclature"
    return latex_nomenclature







