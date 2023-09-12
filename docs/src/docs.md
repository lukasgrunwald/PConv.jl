# Type Shorthands

The package defines and exports shorthands for commonly used types. They are defined as

```julia
I64 = Int64
F64 = Float64
CF64 = ComplexF64
VecF64 = Vector{Float64}
VecCF64 = Vector{ComplexF64}
MatF64 = Matrix{Float64}
MatCF64 = Matrix{ComplexF64}
```

!!! warning

    This is bad practice, but often more convenient when quickly prototyping...

# cSpline

Interpolation of complex-valued data using [`Dierckx.jl`](https://github.com/kbarbary/Dierckx.jl). We provide both a functor, and a classical interface.

```@autodocs
Modules = [PConv]
Pages = ["cSpline.jl"]
```

# Physics

Physics related Helper functions

```@autodocs
Modules = [PConv]
Pages = ["helper_physics.jl"]
```

# Convenience

More general convenience functions, that are often useful

```@autodocs
Modules = [PConv]
Pages = ["helper_conv.jl"]
```

# IO

Convenience functions for generating and handling (versioned) paths

```@autodocs
Modules = [PConv]
Pages = ["customIO.jl"]
```