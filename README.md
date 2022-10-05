# BasicStateSpace.jl

WORK IN PROGRESS

A package for basic operations with discrete time state space
operations

## State Space model

- Transition equation:
$$ s_t = c + A s_{t-1} + B u_t $$
- Measurement equation:
$$ y_t = d + D s_t + e_t $$
with $E(u) = E(e) = 0$.
- Variance of shocks:
$$ Var(u) = Q$$
- Variance of measurement errors:
$$ Var(e) = H$$

## Computations

- unconditional mean: 
$$s = (I - A)^{-1}d$$
$$y = d + C s
- unconditional variance:
$$ Var(s) = A Var(s) A' + B Q B'$$
$$ Var(y) = C Var(s) C' + H$$
- mean forecast:
$$ s^f_{T+k} = c + A^k s_T$$
$$ y^f_{T+k} = d + C s^f_{T+k}
- variance of forecast error:
$$ V(s^f_{T+k} - s_{T+k}) = \sum_{i=1:k} A^{i-1}BQB'A^{i-1}'$$
$$ V(y^f_{T+k} - y_{T+l} = C Var(s^f_{T+k} C' + H$$
- impulse response funtion (IRF)to shock on u_{i1}::
$$ s^r_1 = c + A s^r_0 + Bu_{i1} $$
$$ s^r_t = c + A s^r_{t-1} 1 < t <= T$$
$$ y^r_t = d + Cs^r_t$$
- variance of IRF taking into account future shocks: identical to
  variance of forecast error
