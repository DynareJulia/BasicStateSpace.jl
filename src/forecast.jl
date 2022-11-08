Base.@kwdef mutable struct MeanForecast{T<:Real}
    states::Vector{Vector{T}}
    measurements::Vector{Vector{T}}
    state_labels::Vector{String}
    measurement_labels::Vector{String}
end

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
    MeanForecast(states, measurements, model.state_labels, model.measurement_labels)
end

function plot_forecast(mf::MeanForecast{T},
                       c_vars::ConditionalVariance{T};
                       seed::Color=RGB{Float64}(1.0,0.0,0.0),
                       colors::Vector{Symbol}=Symbol[]) where T<:Real
    s = mf.states
    @assert length(s[1]) == length(mf.state_labels)
    data = reduce(hcat,s)'
    vars = reduce(hcat, [diag(c_vars.states_variance[:, :, i]) for i in 1:length(s)])'
    plots = []
    if length(colors)  == 0
        colors = distinguishable_colors(4, seed)
    else
        @assert length(colors) == 4
    end
    for (i, l) in enumerate(mf.state_labels)
        ##0.254 - 20%, 0.525 - 40%, 0.842 - 60%, 1.28 - 80%##
        f = plot(data[:, i], ribbon=1.28*vars[:, i], fillcolor=colors[1], label=false, linewidth=2.0)
        plot!(f, data[:, i], ribbon=0.254*vars[:, i], fillcolor=colors[2],label=false, linewidth=0.0)
        plot!(f, data[:, i], ribbon=0.525*vars[:, i], fillcolor=colors[3],label=false, linewidth=0.0)
        plot!(f, data[:, i], ribbon=0.842*vars[:, i], fillcolor=colors[4],label=false, linewidth=0.0)
        title!(f, l)
        push!(plots, f)
    end
    f = plot(plots..., layout=(length(mf.state_labels)))
    display(f)
end

@recipe function f(mf::MeanForecast)
    legend := false
    link := :both
    grid := false
    layout := length(mf.state_labels)
    s = mf.states
    data = reduce(hcat, s)'
    for i in 1:length(mf.state_labels)
        @series begin
            seriestype := :line
            subplot := i
            title := mf.state_labels[i]
            data[:, i]
        end
    end
end

@recipe function f(mf::MeanForecast, c_vars::ConditionalVariance;
                   seed=RGB{Float64}(1.0,0.0,0.0),
                   colors=Symbol[])

    legend := false
    grid := false
    layout := length(mf.state_labels)
    s = mf.states
    data = reduce(hcat, s)'
    vars = reduce(hcat, [diag(c_vars.states_variance[:, :, i]) for i in 1:length(s)])'

    if length(colors)  == 0
        colors = distinguishable_colors(4, seed)
    else
        @assert length(colors) == 4
    end

    for (i, l) in enumerate(mf.state_labels)
        
        @series begin
            seriestype := :line
            subplot := i
            ribbon := 1.28*vars[:, i]
            linewidth := 2
            fillcolor := colors[1]
            data[:, i]    
        end

        @series begin
            seriestype := :line
            subplot := i
            linewidth := 0
            fillcolor := colors[2]
            ribbon := 0.254*vars[:, i]
            data[:, i]
            
        end

        @series begin
            seriestype := :line
            subplot := i
            linewidth := 0
            fillcolor := colors[3]
            ribbon := 0.525*vars[:, i]
            data[:, i]
        end
        
        @series begin
            seriestype := :line
            subplot := i
            linewidth := 0
            fillcolor := colors[4]
            ribbon := 0.842*vars[:, i]
            title := l
            data[:, i] 
        end

    end

end