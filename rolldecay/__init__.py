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

