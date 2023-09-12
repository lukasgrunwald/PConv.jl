using PConv
using Test

@testset "versionized_path" begin
filename = "temp.csv"
filename_slash = "/temp.csv"
temp_dir = mktempdir()
abspath = temp_dir
abspath_slash = temp_dir * "/"

corr_path = abspath * filename_slash
corr_path2 = abspath * "/temp_v1.csv"

@test corr_path == versionized_path(filename; abspath)
@test corr_path == versionized_path(filename; abspath = abspath_slash)
@test corr_path == versionized_path(filename_slash; abspath)

touch(corr_path)

@test corr_path2 == versionized_path(filename; abspath)

rm(corr_path)
rm(temp_dir)
end
