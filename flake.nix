{
  description = "Signal Program Runner (sigpr)";
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ flake-utils.lib.system.x86_64-linux ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        haskellPackages = pkgs.haskellPackages;
        pkgsStatic = pkgs.pkgsStatic;
        staticHaskellPackages = pkgsStatic.haskellPackages;
        sigpr =
          haskellPackages.callCabal2nix "sigpr" ./. { };
        staticSigpr =
          staticHaskellPackages.callCabal2nix "sigpr" ./. { };
      in
      {
        packages.default = staticSigpr;
        devShells.default = haskellPackages.shellFor {
          packages = p: [
            (pkgs.haskell.lib.disableOptimization sigpr)
          ];

          buildInputs = [
            # nix tools
            pkgs.nixpkgs-fmt
            pkgs.nil
            # haskell tools
            haskellPackages.haskell-language-server
            haskellPackages.cabal-install
            haskellPackages.hpack
          ];
        };
      }
    );
}
