"""
This module contains some tests devloped while debuggin the roll decay test parameter identification estimators.
"""
import pytest
import numpy as np
import rolldecay
import os

from rolldecayestimators.direct_estimator import DirectEstimator,NorwegianEstimator
from rolldecayestimators.transformers import CutTransformer, LowpassFilterDerivatorTransformer, ScaleFactorTransformer
from rolldecay.equations_lambdify import calculate_acceleration, calculate_velocity
from sklearn.pipeline import Pipeline
from rolldecay.simulation import  simulate
import rolldecay.read_funky_ascii

@pytest.fixture
def pipeline_norwegian():
    lowpass_filter = LowpassFilterDerivatorTransformer(cutoff=0.5)
    scaler = ScaleFactorTransformer(scale_factor=29.565)
    cutter = CutTransformer(phi_max=np.deg2rad(8), phi_min=np.deg2rad(0.05))
    norwegian_estimator = NorwegianEstimator(calculate_acceleration=calculate_acceleration, simulate=simulate)

    steps = [
        ('filter', lowpass_filter),
        ('scaler', scaler),
        ('cutter', cutter),
        ('norwegian_estimator', norwegian_estimator)]
    yield Pipeline(steps)  # define the pipeline object.


def test_1(pipeline_norwegian):
    ascii_file_path = os.path.join(rolldecay.data_path, r'project1\Ascii files\20084871052k.05.asc')
    df_raw = rolldecay.read_funky_ascii.read(ascii_path=ascii_file_path)[['phi']]
    pipeline_norwegian.fit(X=df_raw)
