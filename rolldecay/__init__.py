#from pint import UnitRegistry
#ureg = UnitRegistry()
#Quantity = ureg.Quantity
#radian = ureg.radian
#second = ureg.second
#dimensionless = ureg.Quantity(1,units='dimensionless').units
#nondimensional = dimensionless

import os

dir_path = os.path.dirname(__file__)
base_path = os.path.split(dir_path)[0]
data_path = os.path.join(base_path,'data')
paper_path = os.path.join(base_path,'paper')
notebooks_path = os.path.join(base_path,'notebooks','rolldecay')

equations_path = os.path.join(paper_path,'equations')


paper_figures_path= os.path.join(paper_path,'figures')
