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
          srfi-1
          srfi-113
          srfi-128
          srfi-152
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
