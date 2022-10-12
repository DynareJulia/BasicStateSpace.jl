Base.@kwdef struct StateSpaceModel{T<:Real}
    #Transition Eqn
    A::AbstractMatrix{T}
    B::AbstractMatrix{T}
    c::AbstractVector{T}
    # Measurement Eqn
    d::AbstractVector{T}
    C::AbstractMatrix{T}
    # variance
    Q::AbstractMatrix{T}
    H::AbstractMatrix{T}
end

