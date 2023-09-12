# PConv.jl

Convenience functions ranging from IO & parsing to physics related functions that are often used. The module is split into multiple essentially separate units.

- `cusotmIO.jl` (Save)-path generation and handling.
- `cSpline` Interpolation of complex data using `Dierckx.jl` library
- `helper_physics.jl` Commonly used physics-realted functions
- `helper_conv.jl` More general helper functions. These are mostly convenience implementation like `search_nearest` or an extension of the `@unpack` macro.
