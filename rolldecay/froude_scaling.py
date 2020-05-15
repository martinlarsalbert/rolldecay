import numpy as np
import pandas as pd

def froude_scale(data, description, skip=[]):
    scale_factor = data['scale_factor']

    denominators = {
        '-': None,
        'm': scale_factor,
        'm2': scale_factor ** 2,
        'm3': scale_factor ** 3,
        # 'knots':np.sqrt(scale_factor),
        # 'knot':np.sqrt(scale_factor),
        r'm/s': np.sqrt(scale_factor),
        'degrees': 1,
        'rad': 1,
        'rad/s': 1 / np.sqrt(scale_factor),
        'degrees/s': 1 / np.sqrt(scale_factor),
        'kW': scale_factor ** 2 / np.sqrt(scale_factor),
        'rpm': 1 / np.sqrt(scale_factor),
    }

    model_data = pd.DataFrame(index=data.index)
    for key, value in data.items():
        if key in skip or data[key].dtype == 'object':
            model_data[key] = value
            continue

        unit = description.loc[key]['unit']
        denominator = denominators[unit]
        if denominator is None:
            nondimensional_value = value
        else:
            nondimensional_value = value / denominator

        model_data[key] = nondimensional_value

    return model_data