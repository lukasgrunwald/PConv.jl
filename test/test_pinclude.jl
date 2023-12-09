#=
Test function for modifying code before it is loaded into the current scope
=#
using PConv

# Include top level file with delimiter #%
pinclude("../test/data/test_include.jl", "#%")

@isdefined test_include
!@isdefined test_noinclude

# Recursive include statement
pinclude("../test/data/recursive_test_include.jl", "##-")

@isdefined test_recursive_include
!@isdefined test_no_recursive_include
!@isdefined test_noinclude
