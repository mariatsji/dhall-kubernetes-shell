{ pkgs ? import <nixpkgs> { } }:
with pkgs;
mkShell {
  buildInputs = [
    dhall-json # the binary dhall-to-yaml for some reason..
    dhallPackages.dhall-kubernetes
    dhall-lsp-server
  ];

  shellHook = ''
    # ...
  '';
}