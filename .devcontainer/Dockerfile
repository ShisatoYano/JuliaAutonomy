FROM julia:1.5.3

RUN apt-get update

RUN apt-get -yq install libxt6 libxrender1 libxext6 libgl1-mesa-glx libqt5widgets5

RUN apt-get -yq install build-essential

RUN apt-get -yq install git

RUN git config --global user.name Shisato

RUN git config --global user.email shisatoyano@gmail.com

RUN julia -e 'using Pkg; Pkg.add("PackageCompiler")'
RUN julia -e 'ENV["CONDA_JL_VERSION"]=3; using Pkg; Pkg.add(["PyCall", "PyPlot"])'
RUN julia -e 'using Pkg; Pkg.add(["Plots", "DataFrames", "CSV"])'
RUN julia -e 'using Pkg; Pkg.add(["Test", "StatsPlots", "Statistics"])'
RUN julia -e 'using Pkg; Pkg.add(["FreqTables", "NamedArrays", "Distributions"])'
RUN julia -e 'using Pkg; Pkg.add(["LinearAlgebra"])'