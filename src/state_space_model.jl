Base.@kwdef struct StateSpaceModel{T<:Real}
    #Transition Eqn
    A::AbstractMatrix{T}
    B::AbstractMatrix{T}
    c::AbstractVector{T}
    state_labels::Vector{String}
    # Measurement Eqn
    d::AbstractVector{T}
    C::AbstractMatrix{T}
    measurement_labels::Vector{String}
    # variance
    Q::AbstractMatrix{T}
    H::AbstractMatrix{T}
end

