var documenterSearchIndex = {"docs":
[{"location":"#PCnov.jl","page":"Home","title":"PCnov.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Convenience functions ranging from IO & parsing to physics related functions that are often used. The module is split into multiple essentially separate units.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Pages = [\"docs.md\"]","category":"page"},{"location":"docs/#Type-Shorthands","page":"Library","title":"Type Shorthands","text":"","category":"section"},{"location":"docs/","page":"Library","title":"Library","text":"The package defines and exports shorthands for commonly used types. They are defined as","category":"page"},{"location":"docs/","page":"Library","title":"Library","text":"I64 = Int64\nF64 = Float64\nCF64 = ComplexF64\nVecF64 = Vector{Float64}\nVecCF64 = Vector{ComplexF64}\nMatF64 = Matrix{Float64}\nMatCF64 = Matrix{ComplexF64}","category":"page"},{"location":"docs/","page":"Library","title":"Library","text":"warning: Warning\nThis is bad practice, but often more convenient when quickly prototyping...","category":"page"},{"location":"docs/#cSpline","page":"Library","title":"cSpline","text":"","category":"section"},{"location":"docs/","page":"Library","title":"Library","text":"Interpolation of complex-valued data using Dierckx.jl. We provide both a functor, and a classical interface.","category":"page"},{"location":"docs/","page":"Library","title":"Library","text":"Modules = [PConv]\nPages = [\"cSpline.jl\"]","category":"page"},{"location":"docs/#PConv.cSpline","page":"Library","title":"PConv.cSpline","text":"cSpline(x::AbstractVector{T}, y::AbstractVector; w=ones(length(x)), k=3, bc=\"nearest\", s=0.0)\n\nStruct and Functor for interpolating complex data, using Dierckx.jl's Spine1D. Spline can be evaluated by calling the struct as a function. Regular derivative and integrate functions are avaivible.\n\nArguments\n\nk degree of spline k (1 = linear, 2 = quadratic, 3 = cubic, up to 5)\nbc{\"nearest\" (default), \"zero\", \"extrapolate\", \"error\"} Behavior when evaluating\n\nthe spline outside the support domain (minimum(x), maximum(x)).\n\n\n\n\n\n","category":"type"},{"location":"docs/#PConv.cspline-Tuple{Any, AbstractArray, AbstractArray}","page":"Library","title":"PConv.cspline","text":"cspline(xi, x::AbstractArray, y::AbstractArray; kwargs...)\n\nComplex Interpolation function, by calleing Spline1D for Re and Im seperately. Returns Interpolation of x,y evaluated at xi, if y is a complex array.\n\nArguments\n\nxi::AbstractArray: New points\nx::AbstractArray{Real}: x-values of the data (ordered and real)\ny::AbstractArray: y-values of the data ∈ Complex\nkwargs::NamedTuple: Stanard options for Spline1D\nreturn: Spline1D(x, y, bc)(xi)\n\n\n\n\n\n","category":"method"},{"location":"docs/#PConv.dderivative_cspline-Tuple{Tuple, Any, AbstractMatrix}","page":"Library","title":"PConv.dderivative_cspline","text":"dderivative_cspline(xy_eval::Tuple, x, A::AbstractMatrix; k = 3, nu_x = 1, nu_y = 1)\n\nCalculate derivate of complex matrix A(x, x) at xy_eval using Dierckx.\n\n\n\n\n\n","category":"method"},{"location":"docs/#PConv.derivative_cspline-Tuple{Any, AbstractVector, AbstractVector}","page":"Library","title":"PConv.derivative_cspline","text":"derivative_cspline(x_eval, x, fx; k = 3, nu = 1)\n\nCalculate derivate of complex function fx at x_eval using Dierckx.\n\n\n\n\n\n","category":"method"},{"location":"docs/#Physics","page":"Library","title":"Physics","text":"","category":"section"},{"location":"docs/","page":"Library","title":"Library","text":"Physics related Helper functions","category":"page"},{"location":"docs/","page":"Library","title":"Library","text":"Modules = [PConv]\nPages = [\"helper_physics.jl\"]","category":"page"},{"location":"docs/#PConv.heaviside","page":"Library","title":"PConv.heaviside","text":"heaviside(x::Real, zero::Real=1.0)\n\nHeaviside function Θ(x) with optional zero-point argument θ(0.0)=zero.\n\nStanard value (zero=1.0) implements Θ(x+0⁺).\n\n\n\n\n\n","category":"function"},{"location":"docs/#PConv.nb-Union{Tuple{T2}, Tuple{T1}, Tuple{T1, T2}} where {T1<:Number, T2<:Number}","page":"Library","title":"PConv.nb","text":"nb(x::T1, β::T2=1.0) where {T1 <: Number, T2 <: Number}\n\nBose function nf(x) = 1  (e^(x*β) - 1) at x with temperature β.\n\n\n\n\n\n","category":"method"},{"location":"docs/#PConv.nf-Union{Tuple{T2}, Tuple{T1}, Tuple{T1, T2}} where {T1<:Number, T2<:Number}","page":"Library","title":"PConv.nf","text":"nf(x::T1, β::T2=1.0) where {T1 <: Number, T2 <: Number}\n\nFermi function nf(x) = 1  (e^(x*β) + 1) at x with temperature β.\n\n\n\n\n\n","category":"method"},{"location":"docs/#PConv.pauliMat-Tuple{Int64}","page":"Library","title":"PConv.pauliMat","text":"pauliMat(x::Int)\n\nPauli matrices with x=0,...,3, defined by\n\n'x=0: [1  0; 0 1] ; x=1 [0 1; 1 0 ]'\\\n'x=2: [0 -i; i 0] ; x=3 [1 0; 0 -1]'\n\nreturn: σˣ\n\n\n\n\n\n","category":"method"},{"location":"docs/#Convenience","page":"Library","title":"Convenience","text":"","category":"section"},{"location":"docs/","page":"Library","title":"Library","text":"More general convenience functions, that are often useful","category":"page"},{"location":"docs/","page":"Library","title":"Library","text":"Modules = [PConv]\nPages = [\"helper_conv.jl\"]","category":"page"},{"location":"docs/#Base.identity-Union{Tuple{Vararg{Any, N}}, Tuple{N}} where N","page":"Library","title":"Base.identity","text":"identity(x::Vararg{Any, N}) where N\n\nExtend Base.identity function to accept multiple arguments\n\nreturn: x\n\n\n\n\n\n","category":"method"},{"location":"docs/#PConv.:≂-Tuple{Any, Any}","page":"Library","title":"PConv.:≂","text":"@generated function ≂(x, y)\n\nLenient comparison operator for struct, both mutable and immutable (type with \\eqsim).\n\n\n\n\n\n","category":"method"},{"location":"docs/#PConv.fdiff-Tuple{Any, Any}","page":"Library","title":"PConv.fdiff","text":"fdiff(a, b) = findmax(@. abs(a - b))\n\nConvenience function for calculating the index and value of maximal difference.\n\n\n\n\n\n","category":"method"},{"location":"docs/#PConv.generate_interval-NTuple{4, Any}","page":"Library","title":"PConv.generate_interval","text":"generate_interval(t, t_start, t_step, t_end; digits = 8)\ngenerate_interval(t, t_values; digits = 8)\n\nGenerate index-array for t_values in t. If the exact value is not contained take the closest value that is.\n\n\n\n\n\n","category":"method"},{"location":"docs/#PConv.generate_sym-Tuple{Any, Any, Any}","page":"Library","title":"PConv.generate_sym","text":"generate_sym(Xmin, Xmax, δx)\ngenerate_sym(Xmax, δx)\n\nGenerate symmetric array around 0, i.e. X = Xmin, ..., δx, 0, δx, ..., Xmax. If Xmin is not provided, Xmin = -Xmax is used. Note that X[1] != Xmin , X[end] != Xmax is possible if δx does not fit into the interval.\n\nArguments\n\nXmin(=-Xmax): Minimal value\nXmax: Maximal value\nδx: Spacing\nreturn: X, N, N0 (X[N0] = 0.0)\n\n\n\n\n\n","category":"method"},{"location":"docs/#PConv.isapprox_eps-Union{Tuple{T}, Tuple{Complex{T}, Complex{T}}} where T<:Real","page":"Library","title":"PConv.isapprox_eps","text":"isapprox_eps(x::Complex{T}, y::Complex{T}; factor::Integer=1) where {T<:Real}\nisapprox_eps(x::T, y::T; factor::Integer=1) where {T<:Real}\n\nCompare x, y with times⋅eps(max(x, y)) accuracy, where eps(x) gives floating point accuracy.\n\nIn the case of complex numbers compare real and imag part seperately.\n\nReturns\n\nBool Boolian if x ≈ y with accuracy times⋅eps(max(x, y))\n\n\n\n\n\n","category":"method"},{"location":"docs/#PConv.mdiff-Tuple{Any, Any}","page":"Library","title":"PConv.mdiff","text":"mdiff(a, b) = maximum(@. abs(a - b))\n\nConvenience function for calculating the maximal difference.\n\n\n\n\n\n","category":"method"},{"location":"docs/#PConv.minimize_distance-Tuple{AbstractArray, AbstractArray}","page":"Library","title":"PConv.minimize_distance","text":"minimize_distance(x::Abstractarray, y::Abstractarray)\n\nDetermine permutation indices such that ||x⃗ - y⃗|| ∀i is minimal Note: using sum(abs2, .) instead of norm in order to not introduce an additional dependence!\n\n\n\n\n\n","category":"method"},{"location":"docs/#PConv.search_nearest-Tuple{AbstractArray, Any}","page":"Library","title":"PConv.search_nearest","text":"search_nearest(a::AbstractArray, x; sorted::Bool = false)\n\nFind index of closest element ∈ a to x. sorted decides if a is sorted.\n\n\n\n\n\n","category":"method"},{"location":"docs/#PConv.search_nearest_sorted-Tuple{AbstractArray, Any}","page":"Library","title":"PConv.search_nearest_sorted","text":"search_nearest_sorted(a::AbstractArray, x)\n\nFind index of closest element ∈ a to x. a is assumed sorted.\n\n\n\n\n\n","category":"method"},{"location":"docs/#PConv.size_mb-Tuple{Any}","page":"Library","title":"PConv.size_mb","text":"size_mb(x)\n\nPrint size of x in mb.\n\n\n\n\n\n","category":"method"},{"location":"docs/#PConv.void-Union{Tuple{Vararg{Any, N}}, Tuple{N}} where N","page":"Library","title":"PConv.void","text":"void(x::Vararg{Any, N}) where N\n\nTake arbritrary number of arguments and return nothing.\n\n\n\n\n\n","category":"method"},{"location":"docs/#IO","page":"Library","title":"IO","text":"","category":"section"},{"location":"docs/","page":"Library","title":"Library","text":"Convenience functions for generating and handling (versioned) paths","category":"page"},{"location":"docs/","page":"Library","title":"Library","text":"Modules = [PConv]\nPages = [\"customIO.jl\"]","category":"page"},{"location":"docs/#PConv.PROJECT_ROOT","page":"Library","title":"PConv.PROJECT_ROOT","text":"Absolute path of current active project (folder containing Project.toml) at the time of including using PConv\n\n\n\n\n\n","category":"constant"},{"location":"docs/#PConv.dirnames-Tuple{Integer, AbstractString}","page":"Library","title":"PConv.dirnames","text":"dirnames(n::Integer, path::AbstractString)\n\nExtend Base.dirname function to direcly apply it n-times\n\n\n\n\n\n","category":"method"},{"location":"docs/#PConv.find_project_root-Tuple{AbstractString}","page":"Library","title":"PConv.find_project_root","text":"find_project_root(folder_path::AbstractString)\n\nFind the root-path of project by searching for first Project.toml above/equal folder_path.\n\n\n\n\n\n","category":"method"},{"location":"docs/#PConv.overprint-Tuple{AbstractString}","page":"Library","title":"PConv.overprint","text":"overprint(str::AbstractString)\n\nReplace current line with str, i.e. overprint current line.\n\n\n\n\n\n","category":"method"},{"location":"docs/#PConv.versionized_path-Tuple{Any}","page":"Library","title":"PConv.versionized_path","text":"versionized_path(filename; abspath=PROJECT_ROOT, overwrite = false)\n\nGenerate versionized path*filename by appending _vx to the filename if filename already exists.\n\nArguments\n\nfilename::AbstractString: Folder+name of the file with file extension (Example \"pictures/test.png\")\nabspath::AbstractString=PROJECT_ROOT: Absolute path to use. Default is the\n\ndirectory of the active project.\n\noverwrite::Bool If false, don't versionize the path and potentially overwrite existing\n\nfile\n\nreturn: versionized_path::AbstractString\n\n\n\n\n\n","category":"method"}]
}
