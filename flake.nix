{
  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixpkgs-unstable"; };
    flake-utils = { url = "github:numtide/flake-utils"; };
  };
  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        python = pkgs.python3;
        venvDir = "./.venv";

      in {
        devShell = pkgs.mkShell {
          name = "basicPython";
          inherit venvDir;

          packages = with pkgs;
            [
              (python.withPackages (ps:
                with ps; [
                  # notebook
                  jupyter
                  jupyterlab
                  ipykernel
                  ipython

                  # scientific computing
                  pandas # Data structures & tools
                  numpy # Array & matrices
                  scipy # Integral, solving differential, equations, optimizations)

                  # Visualization
                  matplotlib # plot & graphs
                  seaborn # heat maps, time series, violin plot

                  # Algorithmic Libraries
                  scikit-learn # Machine learning: regression, classificatons,..
                  statsmodels # Ecplore data, estimate statistical models, & perform statistical test.

                  # Formatting
                  black

                ]))
            ];
          shellHook = ''
            if [ ! -d $venvDir ]; then
              echo "Creating virtual environment in $venvDir"
              ${python}/bin/python -m venv $venvDir
            else
              echo "Using existing virtual environment in $venvDir"
            fi
          '';
        };
      });
}

