{
  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixpkgs-unstable"; };
    flake-utils = { url = "github:numtide/flake-utils"; };
  };
  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        python = pkgs.python311;
        pythonPackages = python.pkgs;
        venvDir = "./.venv";
        lib-path = with pkgs;
          lib.makeLibraryPath [ libffi openssl stdenv.cc.cc python ];

      in {
        devShell = pkgs.mkShell {
          name = "basicPython";
          inherit venvDir;

          buildInputs = with pkgs;
            [
              # In this particular example, in order to compile any binary extensions they may
              # require, the Python modules listed in the hypothetical requirements.txt need
              # the following packages to be installed locally:
              taglib
              openssl
              git
              libxml2
              libxslt
              libzip
              zlib
            ] ++ (with pythonPackages; [
              python

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
            ]);

          postVenvCreation = ''
            unset SOURCE_DATE_EPOCH
            pip install -r requirements.txt
          '';

          shellHook = ''
            export "LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${lib-path}"
              if [ ! -d $venvDir ]; then
                echo "Creating virtual environment in $venvDir"
                ${pythonPackages.python}/bin/python -m venv $venvDir
              else
                echo "Using existing virtual environment in $venvDir"
              fi
              source $venvDir/bin/activate
          '';

          postShellHook = ''
            # allow pip to install wheels
            unset SOURCE_DATE_EPOCH
          '';
        };
      });
}

