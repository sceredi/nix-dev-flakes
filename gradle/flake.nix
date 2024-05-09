{
  description = "A very basic java/gradle flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: {

    devShells.x86_64-linux.default = let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      # choose our preferred jdk package
      jdk = pkgs.jdk21;
    in pkgs.mkShell {
      buildInputs = with pkgs; [
        jdk
        kotlin
        # customise the jdk which gradle uses by default
        (callPackage gradle-packages.gradle_8 { java = jdk; })
      ];
    };
  };
}

