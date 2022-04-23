using StatsBase
const RealVector{T<:Real} = AbstractArray{T,1}
#abstract type AbstractWeights{S<:Real, T<:Real, V<:AbstractVector{T}} <: AbstractVector{T} end


# experiments
# Empirical estimation of CDF and PDF

## Empirical CDF
struct mECDF{T <: AbstractVector{<:Real}, W <: AbstractWeights{<:Real}}
    sorted_values::T
    weights::W
end

function (mecdf::mECDF)(x::Real)
    isnan(x) && return NaN
    n = searchsortedlast(mecdf.sorted_values, x)
    evenweights = isempty(mecdf.weights)
    weightsum = evenweights ? length(mecdf.sorted_values) : sum(mecdf.weights)
    partialsum = evenweights ? n : sum(view(mecdf.weights, 1:n))
    partialsum / weightsum
end

function (mecdf::mECDF)(v::RealVector)
    evenweights = isempty(mecdf.weights)
    weightsum = evenweights ? length(mecdf.sorted_values) : sum(mecdf.weights)
    ord = sortperm(v)
    m = length(v)
    r = similar(mecdf.sorted_values, m)
    r0 = zero(weightsum)
    i = 1
    for (j, x) in enumerate(mecdf.sorted_values)
        while i <= m && x > v[ord[i]]
            r[ord[i]] = r0
            i += 1
        end
        r0 += evenweights ? 1 : mecdf.weights[j]
        if i > m
            break
        end
    end
    while i <= m
        r[ord[i]] = weightsum
        i += 1
    end
    return r / weightsum
end

"""
    ecdf(X; weights::AbstractWeights)
Return an empirical cumulative distribution function (ECDF) based on a vector of samples
given in `X`. Optionally providing `weights` returns a weighted ECDF.
Note: this function that returns a callable composite type, which can then be applied to
evaluate CDF values on other samples.
`extrema`, `minimum`, and `maximum` are supported to for obtaining the range over which
function is inside the interval ``(0,1)``; the function is defined for the whole real line.
"""
function mecdf(X::RealVector; weights::AbstractVector{<:Real}=Weights(Float64[]))
    any(isnan, X) && throw(ArgumentError("ecdf can not include NaN values"))
    isempty(weights) || length(X) == length(weights) || throw(ArgumentError("data and weight vectors must be the same size," *
        "got $(length(X)) and $(length(weights))"))
    ord = sortperm(X)
    mECDF(X[ord], isempty(weights) ? weights : Weights(weights[ord]))
end

minimum(mecdf::mECDF) = first(mecdf.sorted_values)

maximum(mecdf::mECDF) = last(mecdf.sorted_values)

extrema(mecdf::mECDF) = (minimum(mecdf), maximum(mecdf))