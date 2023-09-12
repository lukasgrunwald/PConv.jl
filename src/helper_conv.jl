#=
Convenience and helper functions often used
1.) search_nearest
2.) generate_sym
3.) generate_interval
4.) Extension of Basis functions
5.) Comparison functions
6.) Misc: size_mb, minimaize_distance
=#
using Combinatorics: permutations

# —————————————————————————————— search_nearest functions —————————————————————————————— #
"""
    search_nearest_sorted(a::AbstractArray, x)

Find index of closest element ∈ a to x. a is assumed sorted.
"""
function search_nearest_sorted(a::AbstractArray, x)
    idx = searchsortedfirst(a, x)
    if (idx == 1)
        return idx
    elseif (idx > length(a))
        return length(a)
    elseif (a[idx] == x)
        return idx
    elseif (abs(a[idx] - x) < abs(a[idx - 1] - x))
        return idx
    else # (abs(a[idx]-x) > abs(a[idx-1]-x))
        return idx - 1
    end
end

"""
    search_nearest(a::AbstractArray, x; sorted::Bool = false)

Find index of closest element ∈ a to x. `sorted` decides if a is sorted.
"""
function search_nearest(a::AbstractArray, x; sorted::Bool=false)
    if !sorted
        return argmin(abs.(a .- x))
    else # array sorted (faster method)
        return search_nearest_sorted(a, x)
    end
end

# ——————————————————————————————— Generate (index)-arrays —————————————————————————————— #
"""
    generate_sym(Xmin, Xmax, δx)
    generate_sym(Xmax, δx)

Generate symmetric array around 0, i.e. `X = Xmin, ..., δx, 0, δx, ..., Xmax`. If Xmin is not
provided, Xmin = -Xmax is used. Note that `X[1] != Xmin` , `X[end] != Xmax` is possible if
δx does not fit into the interval.

# Arguments
- `Xmin(=-Xmax):` Minimal value
- `Xmax:` Maximal value
- `δx:` Spacing
- `return:` X, N, N0 (X[N0] = 0.0)
"""
function generate_sym(Xmin, Xmax, δx)
    Xmin >= Xmax && error("Invalid boundaries!")
    (Xmin > 0 || Xmax < 0) && error("Invalid boundaries")

    # Build symmetric array around 0
    X_plus = 0:δx:Xmax # generate right half
    X_minus = 0:(-δx):Xmin # generate like this, such that -δt, 0, δt spacing.
    X = vcat(X_minus[end:-1:2], X_plus)

    N = length(X)
    N0 = length(X_minus)
    return X, N, N0
end

generate_sym(Xmax, δx) = generate_sym(-Xmax, Xmax, δx)

# —————————————————————————————————— generate_interval ————————————————————————————————— #
"""
    generate_interval(t, t_start, t_step, t_end; digits = 8)
    generate_interval(t, t_values; digits = 8)

Generate index-array for t_values in t. If the exact value is not contained take the closest
value that is.
"""
function generate_interval(t, t_start, t_step, t_end; digits = 8)
    δt = round(t[2] - t[1]; digits)
    t_step < δt && error("t_step smaller then δt")
    t_end == -1 && (t_end = t[end])

    idx_start = argmin(@. abs(t - t_start))
    idx_step = floor(Int64, t_step / δt)
    idx_end = argmin(@. abs(t - t_end))
    interval = idx_start:idx_step:idx_end

    return interval
end

function generate_interval(t, t_values)
    idx = Vector{Int64}(undef, length(t_values))

    for i in eachindex(t_values)
        idx[i] = search_nearest_sorted(t, t_values[i])
    end

    return idx
end


# ————————————————————————————— Extension of base functions ———————————————————————————— #
"""
    identity(x::Vararg{Any, N}) where N

Extend Base.identity function to accept multiple arguments
- `return:` x
"""
function Base.identity(x::Vararg{Any, N}) where N
    return x
end

"""
    void(x::Vararg{Any, N}) where N

Take arbritrary number of arguments and return nothing.
"""
function void(x::Vararg{Any, N}) where N
    return nothing
end

# ————————————————————————— Comparison (convenience) functions ————————————————————————— #
"""
    @generated function ≂(x, y)

Lenient comparison operator for `struct`, both mutable and immutable (type with \\eqsim).
"""
@generated function ≂(x, y)
    # term after && checks if the data types are the same
    if !isempty(fieldnames(x)) && x == y
        mapreduce(n -> :(x.$n == y.$n), (a,b)->:($a && $b), fieldnames(x))
    else
        :(x == y)
    end
end

"""
    mdiff(a, b) = maximum(@. abs(a - b))

Convenience function for calculating the maximal difference.
"""
mdiff(a, b) = maximum(@. abs(a - b))

"""
    fdiff(a, b) = findmax(@. abs(a - b))

Convenience function for calculating the index and value of maximal difference.
"""
fdiff(a, b) = findmax(@. abs(a - b))

"""
    isapprox_eps(x::Complex{T}, y::Complex{T}; factor::Integer=1) where {T<:Real}
    isapprox_eps(x::T, y::T; factor::Integer=1) where {T<:Real}

Compare x, y with `times⋅eps(max(x, y))` accuracy, where eps(x) gives floating point \
accuracy.

In the case of complex numbers compare real and imag part seperately.
# Returns
- `Bool` Boolian if `x ≈ y` with accuracy `times⋅eps(max(x, y))`
"""
function isapprox_eps(x::Complex{T}, y::Complex{T}; factor::Integer=1) where {T<:Real}
    f1 = isapprox(real.(x), real.(y),
                  atol=factor * eps(maximum([(abs ∘ real)(x), (abs ∘ real)(y)])))
    f2 = isapprox(imag.(x), imag.(y),
                  atol=factor * eps(maximum([(abs ∘ imag)(x), (abs ∘ imag)(y)])))
    return all([f1, f2])
end

function isapprox_eps(x::T, y::T; factor::Integer=1) where {T<:Real}
    return isapprox(x, y, atol=factor * eps(maximum([abs(x), abs(y)])))
end

# —————————————————————————————————————————————————————————————————————————————————————— #
#                                          Misc                                          #
# —————————————————————————————————————————————————————————————————————————————————————— #
"""
    size_mb(x)

Print size of x in mb.
"""
function size_mb(x)
    temp = (string ∘ round)(Base.summarysize(x) * 10^-6; digits = 4)
    println(temp * " mb")
end

"""
    minimize_distance(x::Abstractarray, y::Abstractarray)

Determine permutation indices such that ||x⃗ - y⃗|| ∀i is minimal
Note: using sum(abs2, .) instead of norm in order to not introduce an additional dependence!
"""
function minimize_distance(x::AbstractArray, y::AbstractArray)
    (length(x) != length(y)) && error("Arrays not the same length!")
    ar = 1:1:length(x)

    fid = ar
    @inbounds for id ∈ permutations(ar)
        # Calculate distance between current and old permutation
        norm_new = @views sum(abs2, x[id] - y)
        norm_old = @views sum(abs2, x[fid] - y)

        # Check if new permutation is "significantly" smaller then the old one
        if (norm_new < norm_old) && !(norm_new ≈ norm_old)
            fid = id
        end
    end

    return fid
end
