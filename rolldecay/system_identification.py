import signal_lab
import copy
import numpy as np
import matplotlib.pyplot as plt


def load(db_run):
    ascii_file = db_run.load()
    df_raw = ascii_file.channels

    df = signal_lab.mdl_to_evaluation.do_transforms(df=df_raw)
    df.rename(columns={'MA/Roll': 'phi'}, inplace=True)

    return df

def fit_predict_db_run(db_run, pipeline):
    df = load(db_run)
    scale_factor = db_run.model.scale_factor
    s, _pipline = fit_predict(df=df, pipeline=pipeline, scale_factor=scale_factor)
    return s, _pipline, df

def fit_predict(df, pipeline, scale_factor):

    _pipline = copy.deepcopy(pipeline)
    scaler = _pipline['scaler']
    scaler.scale_factor = scale_factor

    df.rename(columns={'MA/Roll': 'phi'}, inplace=True)

    # Fit:
    _pipline.fit(X=df)

    # Predict:
    estimator = _pipline[-1]
    s = {}
    s.update(estimator.parameters)
    s['score'] = estimator.score(X=estimator.X)
    s['mean_damping'] = estimator.calculate_average_linear_damping()

    if not 'd' in s:
        s['d'] = 0

    return s, _pipline


def plot_pipeline(db_run, pipeline, df):
    df_ = df.copy()
    df_['n'] = n = np.arange(len(df_))
    pipeline = copy.deepcopy(pipeline)
    pipeline['scaler'].scale_factor = db_run.model.scale_factor

    fig, axes = plt.subplots(nrows=len(pipeline))
    fig.set_size_inches(15, 7)
    ax = axes[0]
    df_.plot(x='n', y='phi', ax=ax, label='raw')
    ax.grid(True)
    ax.legend()

    for step, ax in zip(pipeline[0:-1], axes[1:]):
        step.fit(X=df_)
        df_ = step.transform(X=df_)

        df_.plot(x='n', y='phi', label=str(step), ax=ax)
        ax.set_xlim(n[0], n[-1])
        ax.grid(True)
        ax.legend()

    fig, ax = plt.subplots()
    fig.set_size_inches(15, 5)
    estimator = pipeline[-1]
    estimator.fit(X=df_)
    df_pred = estimator.predict(X=df_)
    estimator.plot_fit(ax=ax)