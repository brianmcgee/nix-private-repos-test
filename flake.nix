{
  description = "An exploration of using private repos with Nix";

  # Add all your dependencies here
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    blueprint = {
      url = "github:numtide/blueprint/feat/extra-args";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # let's pull in a private repo in different ways

    git.url = "git+ssh://git@github.com/brianmcgee/secret.git?shallow=1";
    http.url = "github:brianmcgee/secret";
  };rm re

  # Keep the magic invocations to minimum.
  outputs =
    inputs:
    inputs.blueprint {
      inherit inputs;
      extraArgs = {
        lib = inputs.nixpkgs.lib.extend (import ./lib.nix);
      };
    };
}
