FROM julia:1.6.1

RUN apt-get -yq update

RUN apt-get -yq upgrade

RUN apt-get -yq install build-essential

RUN apt-get -yq install git

RUN git config --global user.name Shisato

RUN git config --global user.email shisatoyano@gmail.com

RUN julia -e 'ENV["CONDA_JL_VERSION"]=3; using Pkg; Pkg.add(["PyCall", "PyPlot"])'
RUN julia -e 'using Pkg; Pkg.add(["Plots", "DataFrames", "CSV"])'
RUN julia -e 'using Pkg; Pkg.add(["Test", "StatsPlots", "Statistics"])'
RUN julia -e 'using Pkg; Pkg.add(["FreqTables", "NamedArrays", "Distributions", "SpecialFunctions"])'
RUN julia -e 'using Pkg; Pkg.add(["LinearAlgebra", "StatsBase", "PDMats", "Combinatorics"])'
RUN julia -e 'ENV["PYTHON"]=""; using Pkg; Pkg.add("Conda"); Pkg.update(); Pkg.build("PyCall"); using PyPlot'