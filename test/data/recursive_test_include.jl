#=
Test for recursive test include statement
=#
using PConv

pinclude("test_include.jl", "#%")

test_recursive_include() = println("Included")

##-
test_no_recursive_include() = println("Should not be included!")
