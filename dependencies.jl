# script to install required packages
# usage: julia packages.jl

using Pkg

dependencies = [
    "Plots",
    "DataFrames",
    "CSV",
    "Test"
]

Pkg.add(dependencies)