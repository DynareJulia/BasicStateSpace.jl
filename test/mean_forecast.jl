using Revise

using BasicStateSpace
using LinearAlgebra
using MKL
using Plots

N_s = 3
N_u = 3
N_y = 3

A = [[0.9 0.0 0.0];
     [-0.5 0.8 0.0];
     [0.0 0.2 -0.5];]

B = Diagonal([0.1, 0.3, 0.1])
c = [0.1, 0.1, 0.1]
d = [0.1, 0.3, 0.5]
C = 0.001*randn((N_y, N_s))
Q = Diagonal([1.0, 1.0, 1.0])
H = Diagonal([1.0, 1.0, 1.0])

model = StateSpaceModel(A, B, c, d, C, Q, H)
states, measurements = mean_forecast(model, [0.9, 0.5, 0.1], 10)

ws = ConditionalVarianceWS(3)
states_c_vars, meas_c_vars = conditional_variance(model, ws, 10)

plot_mean_forecast(states, states_c_vars, ["x", "y", "z"]; seed=RGB{Float64}(0.0, 0.0, 1.0))