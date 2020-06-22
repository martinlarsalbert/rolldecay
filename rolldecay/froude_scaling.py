import numpy as np
import pandas as pd


skip_default = [
    'model_number',
    'loading_condition_id',
    'B_1A',
    'B_2A',
    'B_3A',
    'C_1A',
    'C_3A',
    'C_5A',
    'B_1A',
    'B_1',
    'B_2',
    'B_3',
    'C_1',
    'C_3',
    'C_5',
    'A_44',
    'omega0_fft',
    'omega0',
    'omega0_hat',
    'score',
    'id',
    'project_number',
    'series_number',
    'run_number',
    'test_number',
    'scale_factor',
    'g',
    'rho',
    'B_1_hat',
    'B_2_hat',
    'CB',
    'phi_start',
    'phi_stop',
    'B_44_HAT',
    'B_F_HAT',
    'B_W_HAT',
    'B_E_HAT',
    'B_BK_HAT',
    'B_L_HAT',
    'B_e',
    'B_e_hat',
    'trim',
]

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
        if key in skip or key in skip_default or data[key].dtype == 'object':
            model_data[key] = value
            continue

        unit = description.loc[key]['unit']

        if unit=='knot':
            raise ValueError('%s has unit knot, not allowed...' % key)
        if unit=='knots':
            raise ValueError('%s has unit knots, not allowed...' % key)

        denominator = denominators[unit]
        if denominator is None:
            nondimensional_value = value
        else:
            nondimensional_value = value / denominator

        model_data[key] = nondimensional_value

    return model_data