import numpy as np

class BisSystem():
    """ Class that handles conversion from and to bis system"""

    def __init__(self,lpp,volume,g = 9.81,rho = 1000, units={}):

        self.lpp = lpp
        self.volume = volume
        self.g = g
        self.rho = rho
        self.__update_denomintors()
        self.units = units

        self.unit_physical_quantity = {
            'non_dimensional':'non_dimensional',
            '-': 'non_dimensional',
            'kg':'mass',
            'm':'length',
            'm**2':'area',
            'm2': 'area',
            'm**3':'volume',
            'm3': 'volume',
            r'kg/m**3':'density',
            's':'time',
            r'm/s':'linear_velocity',
            r'm/s**2': 'linear_acceleration',
            r'rad/s': 'angular_velocity',
            r'rad/s**2': 'angular_acceleration',
            'rad':'angle',
            'N':'force',
            'Nm':'moment',
        }

    def __update_denomintors(self):

        rho = self.rho
        volume = self.volume
        Lpp = self.lpp
        g = self.g

        denominators = {}
        denominators['non_dimensional']         = 1
        denominators['mass']                    = rho*volume
        denominators['length']                  = Lpp
        denominators['area']                    = Lpp**2
        denominators['volume']                  = Lpp**3
        denominators['density']                 = denominators['mass'] / denominators['volume']
        denominators['time']                    = np.sqrt(Lpp/g)
        denominators['hz']                      = (1/denominators['time'])
        denominators['linear_velocity']         = np.sqrt(Lpp*g)
        denominators['linear_acceleration']     = g
        denominators['angle']                   = 1
        denominators['angular_velocity']        = np.sqrt(g/Lpp)
        denominators['angular_acceleration']    = g/Lpp
        denominators['force']                   = rho*g*volume
        denominators['moment']                  = rho*g*volume*Lpp
        self.denominators = denominators


    def get_unit(self,key):
        unit = self.units.get(key)

        if unit is None:
            raise ValueError('Cannot find unit for:"%s"' % key)

        return unit

    def get_denominator(self,key):

        unit = self.get_unit(key)

        physical_quantity = self.unit_physical_quantity.get(unit)
        if physical_quantity is None:
            raise ValueError('Cannot determine physical_quantity for unit:"%s"' % unit)

        denominator = self.denominators.get(physical_quantity)
        if denominator is None:
            raise ValueError('Cannot find a denominator for physical_quantity:"%s"' % physical_quantity)

        return denominator

    def to_bis(self,key,value):

        denominator = self.get_denominator(key = key)
        nondimensional_value = value / denominator

        return nondimensional_value


    def from_bis(self,key,nondimensional_value):

        denominator = self.get_denominator(key = key)
        value = nondimensional_value * denominator

        return value

    @staticmethod
    def only_numeric(df):
        mask = df.dtypes != 'object'
        numeric_columns = df.columns[mask]
        return df[numeric_columns]

    def df_to_bis(self,df):

        nondimensional_df = df.copy()

        for key,data in self.only_numeric(nondimensional_df).items():
            nondimensional_df[key] = self.to_bis(key = key,value = data)

        nondimensional_df['bis'] = True
        return nondimensional_df

    def df_from_bis(self,nondimensional_df):

       df = nondimensional_df.copy()
       for key,data in self.only_numeric(nondimensional_df).items():
           df[key] = self.from_bis(key = key,nondimensional_value = data)

       df['bis'] = False
       return df
