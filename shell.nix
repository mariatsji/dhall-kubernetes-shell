{ pkgs ? import <nixpkgs> { } }:
with pkgs;
mkShell {
  buildInputs = [
    dhall-json # the binary dhall-to-yaml for some reason..
    dhall-lsp-server
  ];

  shellHook = ''
    # ...
  '';
}