module BasicStateSpace

using LinearAlgebra, MKL, Plots

include("state_space_model.jl")
include("variance.jl")
include("forecast.jl")

export StateSpaceModel, conditional_variance, mean_forecast, 
ConditionalVarianceWS, plot_mean_forecast
end # module BasicStateSpace
