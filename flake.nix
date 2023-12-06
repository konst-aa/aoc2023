{
  description = "aoc2023 in chicken scheme";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # i like to live life dangerously
  };

  outputs = { self, nixpkgs }: {

    defaultPackage.x86_64-linux =
      let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        stdenv = pkgs.stdenv;
        eggs = pkgs.chickenPackages.chickenEggs;
        defaultBuildInputs = with eggs; [
          pkgs.gnumake
          pkgs.chicken
          srfi-1 # list-lib
          srfi-113 # sets
          srfi-128 # comparators
          srfi-152 # string-lib
          vector-lib # clam 9
        ];

      in
        pkgs.stdenv.mkDerivation {
          src = ./.;

          name = "aoc2023";
          buildInputs = defaultBuildInputs;
          # buildPhase = ''
          #   make compile
          # '';
        };

  };
}
