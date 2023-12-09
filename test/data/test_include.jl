#=
Example file for testing
=#
using PConv

function test_include(x)
    println("This function should be inlucded!")
end

#%

function test_noinclude(x)
    println("Should not be included!")
end


# These should also not be inclulded
z = 10
x = 12
