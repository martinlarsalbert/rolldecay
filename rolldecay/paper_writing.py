import rolldecay
import os
import matplotlib.pyplot as plt

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