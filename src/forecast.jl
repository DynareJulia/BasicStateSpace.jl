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
                            label::Vector{String},
                            linewidth::Float64=0.1) where T<:Real
    @assert length(s[1]) == length(label)
    data = reduce(hcat,s)'
    vars = reduce(hcat, [diag(c_vars[:, :, i]) for i in 1:length(s)])'
    f = plot()
    colors = distinguishable_colors(length(label))
    for (i, l) in enumerate(label)
        ##0.254 - 20%, 0.525 - 40%, 0.842 - 60%, 1.28 - 80%##
        plot!(f, data[:, i], label=l, c=colors[i], ribbon=1.28*vars[:, i], fillcolor=colors[i])
        plot!(f, data[:, i] + 0.254*vars[:, i], c=:black, label=false, linewidth=linewidth)
        plot!(f, data[:, i] - 0.254*vars[:, i], c=:black, label=false, linewidth=linewidth)
        plot!(f, data[:, i] + 0.525*vars[:, i], c=:black, label=false, linewidth=linewidth)
        plot!(f, data[:, i] - 0.525*vars[:, i], c=:black, label=false, linewidth=linewidth)
        plot!(f, data[:, i] + 0.842*vars[:, i], c=:black, label=false, linewidth=linewidth)
        plot!(f, data[:, i] - 0.842*vars[:, i], c=:black, label=false, linewidth=linewidth)
    end
    display(f)
end