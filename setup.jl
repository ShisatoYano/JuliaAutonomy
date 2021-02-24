# script to install required packages

module Setup
    using Pkg

    packages = [
        :PackageCompiler, :PyCall, :PyPlot,
        :Plots, :DataFrames, :CSV, :Test,
        :StatsPlots, :Statistics, :FreqTables, 
        :NamedArrays, :Distributions
    ]

    function install_packages()
        for pkg in packages
            Pkg.add(String(pkg))
        end        
    end

    function update_packages()
        for pkg in packages
            Pkg.update(String(pkg))
        end        
    end
end