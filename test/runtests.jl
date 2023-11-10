using PConv
using SafeTestsets

@safetestset "cSpline" begin include("cSpline.jl") end
@safetestset "CustomIO" begin include("versionized_path_test.jl") end
@safetestset "helper_conv" begin include("helper_conv.jl") end
