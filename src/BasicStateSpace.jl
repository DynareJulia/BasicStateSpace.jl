module BasicStateSpace

using LinearAlgebra, MKL, Plots, Colors
using RecipesBase

include("state_space_model.jl")
include("variance.jl")
include("forecast.jl")

export StateSpaceModel, conditional_variance, mean_forecast, 
ConditionalVarianceWS, plot_forecast, MeanForecast
end # module BasicStateSpace
