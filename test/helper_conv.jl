using PConv
using Test

@testset "match_lengths" begin
    x = rand()
    y = rand(10)
    z = rand()

    x_, y_, z_ = match_lengths(x, y, z)

    @test length(x_) == length(y_) == length(z_)
    @test all(x_[1] .== x_)
    @test all(z_[1] .== z_)
end
