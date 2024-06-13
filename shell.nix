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

in with pkgs;
mkShell {

  buildInputs = [
    dhall-json # the binary dhall-to-yaml is in here for some reason..
    dhall-kub
    dhall
  ];

  shellHook = ''
    export DHALLKUB="${dhall-kub}/source.dhall"
  '';
}