import pandas as pd
import numpy as np
import re
from io import StringIO
import re

def read(ascii_path :str)->pd.DataFrame:
    """
    Read funky ascii files (which have their head cut away)
    :param ascii_path:
    :return: pandas data frame containing the roll in radians as 'phi' and time [s] as index
    """

    with open(ascii_path, mode='r') as file:
        s = file.read()

    s1= re.sub(pattern=r'\t', repl=' ', string=s)
    #s2 = re.sub(pattern='^ *', repl='', string=s1)
    s3 = re.sub(pattern='^ *', repl='', string=s1, flags=re.MULTILINE)

    names = ['0', 'phi', '2', '3', '4', '5', '6', '7', '8']
    df = pd.read_csv(StringIO(s3), sep=' ', index_col=0, names=names)
    df['phi'] = np.deg2rad(df['phi'])

    return df
