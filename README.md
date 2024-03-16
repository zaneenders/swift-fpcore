# FPCore

This Package is a Swift implementation of the [FPCore spec](https://fpbench.org/spec/fpcore-2.0.html) 
Project.

## Warning ⚠️
This package is unfinished but if there is more interest I will go ahead and 
implement and maintain the remaining spec

## Vision
- Bring the FPCore spec to Swift and it's package ecosystem and leverage all 
of swift's features
    - Result builders for constructing statically type checked FPCore specs
    - Safe but flexible type system
    - Support for working across languages like c and c++
        - Numerical tools built with c and c++
        - MPFR
    - Declarative and safe concurrency (Sendable types)
    - upcoming non-copyable (move only) types for better systems performance
