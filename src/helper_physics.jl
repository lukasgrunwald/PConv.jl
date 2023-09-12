#=
Physics related convenience functions
1.) General Functions
2.) Scalar Dyson equations
=#

"""
    nf(x::T1, β::T2=1.0) where {T1 <: Number, T2 <: Number}

Fermi function ``nf(x) = 1 / (e^(x*β) + 1)`` at x with temperature β.
"""
function nf(x::T1, β::T2=1.0) where {T1 <: Number, T2 <: Number}
    return 1 / (exp(x * β) + 1)
end

"""
    nb(x::T1, β::T2=1.0) where {T1 <: Number, T2 <: Number}

Bose function ``nf(x) = 1 / (e^(x*β) - 1)`` at x with temperature β.
"""
function nb(x::T1, β::T2=1.0) where {T1 <: Number, T2 <: Number}
    return 1 / (exp(x * β) - 1)
end

"""
    heaviside(x::Real, zero::Real=1.0)

Heaviside function Θ(x) with optional zero-point argument θ(0.0)=zero.

Stanard value (zero=1.0) implements Θ(x+0⁺).
"""
function heaviside(x::Real, zero::Real=1.0)

    if x > 0 return 1
    elseif x < 0 return 0
    else return zero
    end
end

"""
    pauliMat(x::Int)

Pauli matrices with x=0,...,3, defined by

    'x=0: [1  0; 0 1] ; x=1 [0 1; 1 0 ]'\\
    'x=2: [0 -i; i 0] ; x=3 [1 0; 0 -1]'

`return:` σˣ
"""
function pauliMat(x::Int)

    @assert x ∈ 0:3

    if x == 0
        return [1. + 0im 0.0; 0.0 1.]
    elseif x == 1
        return [0.0+0im 1.;1. 0.]
    elseif x == 2
        return  [0.0+0im -1.0im;1.0im 0.]
    elseif x == 3
        return [1. + 0im 0.0; 0.0 -1.]
    end
end
