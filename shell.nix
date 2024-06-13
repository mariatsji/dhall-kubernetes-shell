let pkgs = import ./nixpkgs.nix;

    dhall-kub = pkgs.dhallPackages.buildDhallGitHubPackage {
      name = "dhall-kubernetes";
      owner = "dhall-lang";
      repo = "dhall-kubernetes";
      directory = "1.26";
      file = "package.dhall";
      rev = "v7.0.0";
      sha256 = "sha256-I//GAkTgQbihiRhjJXDN0rNmvaNb+9hLElJ+1BodFkk=";
      source = true;
    };

    dhall-prelude = pkgs.dhallPackages.buildDhallGitHubPackage {
      name = "Prelude";
      owner = "dhall-lang";
      repo = "dhall-lang";
      directory = "Prelude";
      file = "package.dhall";
      rev = "v22.0.0";
      sha256 = "sha256-Ay0zko9bUGD4D3fVq1ZogVnKHlcvOqRcvCvCxH1J/ZQ=";
      source = true;
    };

    my-dhall-lsp-server = (import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/1b7a6a6e57661d7d4e0775658930059b77ce94a4.tar.gz";
    }) {}).haskellPackages.dhall-lsp-server;

in with pkgs;
mkShell {

  buildInputs = [
    dhall-json # the binary dhall-to-yaml is in here for some reason..
    dhall-kub
    dhall-prelude
    dhall-bash
    dhall
    my-dhall-lsp-server
  ];

  shellHook = ''
    export DHALLKUB="${dhall-kub}/source.dhall"
    export DHALLPRELUDE="${dhall-prelude}/source.dhall"
  '';
}