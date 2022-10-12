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
    f = plot(data, label=label)
    for (i, col) in enumerate(eachcol(data))
        vars = [diag(c_vars[:,:,j])[i] for j in 1:length(s[1])]
        plot!(f, col, ribbon=0.254*vars, label=false) # 20%
        plot!(f, col, ribbon=0.525*vars, label=false) # 40%
        plot!(f, col, ribbon=0.842*vars, label=false) # 60%
        plot!(f, col, ribbon=1.28*vars, label=false) # 80%
    end
    display(f)
end