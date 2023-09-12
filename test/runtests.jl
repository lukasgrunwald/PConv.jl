using PConv
using SafeTestsets

@safetestset "cSpline" begin include("cSpline.jl") end
@safetestset "CustomIO" begin include("versionized_path_test.jl") end
