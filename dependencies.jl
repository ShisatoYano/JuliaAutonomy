# script to install required packages
# usage: julia packages.jl

using Pkg

Pkg.add("PackageCompiler")

using PackageCompiler

dependencies = [
    :Plots,
    :DataFrames,
    :CSV,
    :Test,
    :StatsPlots,
    :Statistics
]

for pkg in dependencies
    Pkg.add(String(pkg))
end

for pkg in dependencies
    Pkg.update(String(pkg))
end

create_sysimage(dependencies;replace_default=true)