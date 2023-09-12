using PConv
using Test

f(x, y) = exp(-y^2 + im * y) * sin(x)
∂x_f(x, y) = exp(-y^2 + im * y) * cos(x)
∂y_f(x, y) = (-2y + im) * exp(-y^2 + im * y) * sin(x)
∂x∂y_f(x, y) = (-2y + im) * exp(-y^2 + im * y) * cos(x)

@testset "cSpline" begin
    x = -10:0.01:10 |> collect
    N = length(x)
    N0 = search_nearest_sorted(x, 0.0)
    mat = Matrix{CF64}(undef, N, N)

    for i in 1:N, j in 1:N
        mat[i, j] = f(x[i], x[j])
    end

    ∂x_mat = Vector{ComplexF64}(undef, length(x))
    ∂y_mat = Vector{ComplexF64}(undef, length(x))
    temp = similar(∂y_mat)
    val_x = 0.5
    val_y = 0.3
    val_xy = (0.4, 0.13)

    for i in 1:N
        ∂x_mat[i] = derivative_cspline(val_x, x, mat[:, i])
        ∂y_mat[i] = derivative_cspline(val_y, x, mat[i, :])
        temp[i] = derivative_cspline(val_xy[1], x, mat[:, i])
    end

    ∂x∂y_mat = derivative_cspline(val_xy[2], x, temp)
    ∂x∂y_mat_alt = dderivative_cspline(val_xy, x, mat)

    @test isapprox(∂y_mat, ∂y_f.(x, val_y); atol = 1e-6)
    @test isapprox(∂x_mat, ∂x_f.(val_x, x); atol = 1e-6)
    @test isapprox(∂x∂y_mat, ∂x∂y_f(val_xy...); atol = 1e-6)
end

# Additional plots of the differences
# plt.yscale("log")
# plt.plot(x, @. abs(∂x_mat - ∂x_f.(val_x, x)))
# plt.plot(x, @. abs(∂y_mat - ∂y_f.(x, val_y)))
# plt.plot(x, @. (∂y_mat))
# plt.plot(x, @. ∂y_f.(x, val_y))
# plt.plot(x, temp |> imag)
# plt.show()
