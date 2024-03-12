module PConv

# # Shorthands for types
include("type_shorthands.jl")
export I64, F64, CF64
export VecF64, VecCF64, MatF64, MatCF64

# Convenience functions
include("helper_physics.jl")
export nf, nb, heaviside, pauliMat, commutator, anti_commutator

include("helper_conv.jl")
export search_nearest, search_nearest_sorted, minimize_distance
export generate_sym, generate_interval
export void, identity
export mdiff, fdiff, isapprox_eps, ≂
export size_mb, match_lengths

# Complex spline interpolations
include("cSpline.jl")
export cSpline, derivative, integrate # Functor implementation
export cspline, derivative_cspline, dderivative_cspline # Classical Implementation

# Convenience IO operations
include("customIO.jl")
export PROJECT_ROOT, dirnames
export versionized_path, find_project_root
export overprint
export pinclude, rinclude

using Reexport

@reexport using UnPack

function __init__()
    # Find project root at the time of including the PConv package
    global PROJECT_ROOT = dirname(project().path)
end

end # module
