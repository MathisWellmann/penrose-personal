{
  description = "Flake for penrose-personal";

  inputs = {
    nixpks.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpks";
    };
    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    naersk,
    flake-utils,
    rust-overlay,
    ...
  }:
  flake-utils.lib.eachDefaultSystem (
    system:
     let
      overlays = [(import rust-overlay)];
      pkgs = import nixpkgs {
        inherit system overlays;
      };
      naerskLib = pkgs.callPackage naersk {};
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          rust-bin.stable.latest.default
        ];
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
