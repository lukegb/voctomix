{
  description = "Full-HD Software Live-Video-Mixer in python";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    inherit (nixpkgs) lib;

    systems = [ "x86_64-linux" "aarch64-linux" ];
    forAllSystems = lib.genAttrs systems;

    nixpkgsForSystem = system: import nixpkgs {
      inherit system;
    };
  in {
    packages = forAllSystems (system: let
      pkgs = nixpkgsForSystem system;
    in {
      voctomix = pkgs.python3Packages.callPackage ./package.nix { };
      default = self.packages."${system}".voctomix;
    });

  };
}
