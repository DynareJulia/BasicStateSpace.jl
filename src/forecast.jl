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
                            label::Vector{String};
                            seed::Color=RGB{Float64}(1.0,0.0,0.0),
                            colors::Vector{Symbol}=Symbol[]) where T<:Real
    @assert length(s[1]) == length(label)
    data = reduce(hcat,s)'
    vars = reduce(hcat, [diag(c_vars[:, :, i]) for i in 1:length(s)])'
    plots = []
    if length(colors)  == 0
        colors = distinguishable_colors(4, seed)
    else
        @assert length(colors) == 4
    end
    for (i, l) in enumerate(label)
        ##0.254 - 20%, 0.525 - 40%, 0.842 - 60%, 1.28 - 80%##
        f = plot(data[:, i], ribbon=1.28*vars[:, i], fillcolor=colors[1], label=false, linewidth=2.0)
        plot!(f, data[:, i], ribbon=0.254*vars[:, i], fillcolor=colors[2],label=false, linewidth=0.0)
        plot!(f, data[:, i], ribbon=0.525*vars[:, i], fillcolor=colors[3],label=false, linewidth=0.0)
        plot!(f, data[:, i], ribbon=0.842*vars[:, i], fillcolor=colors[4],label=false, linewidth=0.0)
        title!(f, l)
        push!(plots, f)
    end
    f = plot(plots..., layout=(length(label)))
    display(f)
end