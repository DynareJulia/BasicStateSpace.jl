function mean_forecast(model::StateSpaceModel{T}, 
                       initial_state::AbstractVector{T},
                       n::Integer) where T<:Real
    states = [initial_state]
    measurements = [model.C*initial_state + model.d]
    for i in 1:n-1
        sf = model.A*states[end] + model.c
        push!(states, sf)
        yf = model.C*states[end] + model.d
        push!(measurements, yf)
    end 
    (states, measurements)
end

function plot_mean_forecast(s::Vector{Vector{T}},
                            c_vars::Array{T, 3},
                            label::Matrix{String}) where T<:Real
    @assert length(s[1]) == size(label)[2]
    data = reduce(hcat,s)'
    vars = reduce(hcat, [diag(c_vars[:, :, i]) for i in 1:length(s)])'
    f = plot()
    for (i, l) in enumerate(label)
        plot!(f, data[:, i], label=l)
        plot!(f, data[:, i], ribbon=0.254*vars[:, i], label=false) # 20%
        plot!(f, data[:, i], ribbon=0.525*vars[:, i], label=false) # 40%
        plot!(f, data[:, i], ribbon=0.842*vars[:, i], label=false) # 60%
        plot!(f, data[:, i], ribbon=1.28*vars[:, i], label=false) # 80%
    end
    display(f)
end