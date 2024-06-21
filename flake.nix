{
  description = "Flake for penrose-personal";

  inputs = {
    nixpks.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    naersk,
    flake-utils,
    ...
  }:
  flake-utils.lib.eachDefaultSystem (
    system:
     let
      pkgs = import nixpkgs {
        inherit system;
      };
      naerskLib = pkgs.callPackage naersk {};
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = [];
      };
      defaultPackage = naerskLib.buildPackage {
        pname = "penrose-personal";
        src = ./.;
        buildInputs = [];
        nativeBuildInputs = [];
      };
    }
  );
}
