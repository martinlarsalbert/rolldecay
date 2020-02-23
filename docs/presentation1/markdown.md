class: center, middle

# DEMOPS: Roll decay

Blablablab...

---

# Roll decay...

bla vlas

---

## Simulation of roll decay



```python
%matplotlib inline
%load_ext autoreload
%autoreload 2
```


```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from rolldecayestimators.equations_lambdify import calculate_acceleration, calculate_velocity
from rolldecayestimators.simulation import roll_decay_time_step,simulate
import rolldecay
import inspect
```


```python
from numpy import abs
```


```python
phi0 = np.deg2rad(2)
phi1d0 = 0

states0 = [phi0,phi1d0]
d = 0.076
T0 = 20
omega0 = 2*np.pi/T0
zeta = 0.044

N = 1000
t = np.linspace(0,120,N)

df = simulate(t=t, phi0=phi0, phi1d0=phi1d0, omega0=omega0, d=d, zeta=zeta)
```


```python
fig,ax = plt.subplots()
df.plot(y='phi', ax=ax);
```


![png](01.1_maa_simulation_files/01.1_maa_simulation_5_0.png)



```python
print(inspect.getsource(calculate_acceleration))

```

    def _lambdifygenerated(d, omega0, p_old, phi_old, zeta):
        return (-d*p_old*abs(p_old) - omega0**2*phi_old - 2*omega0*p_old*zeta)
    



```python
print(inspect.getsource(calculate_velocity))
```

    def _lambdifygenerated(p_old):
        return (p_old)
    



```python

```


```python

```
