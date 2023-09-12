#=
Complex Spline1D interpolation function for Spline1D package
=#

import Dierckx
using Dierckx: Spline1D, derivative, evaluate

# —————————————————————————————————————————————————————————————————————————————————————— #
#                                Complex Spline1D functor                                #
# —————————————————————————————————————————————————————————————————————————————————————— #

"""
    cSpline(x::AbstractVector{T}, y::AbstractVector; w=ones(length(x)), k=3, bc="nearest", s=0.0)

Struct and Functor for interpolating complex data, using Dierckx.jl's `Spine1D`. Spline can be
evaluated by calling the struct as a function. Regular derivative and integrate functions are
avaivible.

# Arguments
- `k` degree of spline k (1 = linear, 2 = quadratic, 3 = cubic, up to 5)
- `bc{"nearest" (default), "zero", "extrapolate", "error"}` Behavior when evaluating
the spline outside the support domain (minimum(x), maximum(x)).
"""
struct cSpline
    spl_re::Spline1D
    spl_im::Spline1D
    function cSpline(x::AbstractVector{T}, y::AbstractVector; kwargs...) where T<:Real
        spl_re = Spline1D(x, real.(y); kwargs...)
        spl_im = Spline1D(x, imag.(y); kwargs...)
        return new(spl_re, spl_im)
    end
end

(p::cSpline)(x) = p.spl_re(x) + im * p.spl_im(x)

function Dierckx.derivative(spl::cSpline, x_eval; nu::Integer)
    ∂spl_re = derivative(spl.spl_re, x_eval; nu)
    ∂spl_im = derivative(spl.spl_im, x_eval; nu)
    return complex.(∂spl_re, ∂spl_im)
end

function Dierckx.integrate(spl::cSpline, a::Real, b::Real)
    ∫_real = integrate(spl.spl_re, a, b)
    ∫_imag = integrate(spl.spl_im, a, b)
    return complex(∫_real, ∫_imag)
end

# —————————————————————————————————————————————————————————————————————————————————————— #
#                        Direct inplementation with 2D derivatives                       #
# —————————————————————————————————————————————————————————————————————————————————————— #

"""
    cspline(xi, x::AbstractArray, y::AbstractArray; kwargs...)

Complex Interpolation function, by calleing Spline1D for Re and Im seperately.
Returns Interpolation of x,y evaluated at xi, if y is a complex array.

# Arguments
- `xi::AbstractArray:` New points
- `x::AbstractArray{Real}:` x-values of the data (ordered and real)
- `y::AbstractArray:` y-values of the data ∈ Complex
- `kwargs::NamedTuple:` Stanard options for Spline1D
- `return:` Spline1D(x, y, bc)(xi)
"""
function cspline(xi, x::AbstractArray, y::AbstractArray; kwargs...)

    spr = Spline1D(x, real.(y); kwargs...)
    spi = Spline1D(x, imag.(y); kwargs...)

    return spr(xi) .+ im * spi(xi)
end

"""
    derivative_cspline(x_eval, x, fx; k = 3, nu = 1)

Calculate derivate of complex function fx at x_eval using Dierckx.
"""
function derivative_cspline(x_eval, x::AbstractVector, fx::AbstractVector; k = 3, nu = 1)
    sp_re = Spline1D(x, real(fx); k, bc = "error")
    sp_im = Spline1D(x, imag(fx); k, bc = "error")
    ∂nut_fx = derivative(sp_re, x_eval; nu) + im * derivative(sp_im, x_eval; nu)
    return ∂nut_fx
end

"""
    dderivative_cspline(xy_eval::Tuple, x, A::AbstractMatrix; k = 3, nu_x = 1, nu_y = 1)

Calculate derivate of complex matrix A(x, x) at xy_eval using Dierckx.
"""
function dderivative_cspline(xy_eval::Tuple, x, A::AbstractMatrix; k = 3, nu_x = 1, nu_y = 1)
    x_eval, y_eval = xy_eval
    N = length(x)

    temp = Vector{eltype(A)}(undef, N)
    @inbounds for i in 1:N
        temp[i] = derivative_cspline(x_eval, x, (@view A[:, i]); k, nu = nu_x)
    end

    ∂x∂y_A = derivative_cspline(y_eval, x, temp; k, nu = nu_y)
    return ∂x∂y_A
end
