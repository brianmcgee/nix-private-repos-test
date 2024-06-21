let
  nixpkgs = builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-24.05.tar.gz";
  pkgs = import nixpkgs { };
  lib = pkgs.lib.extend (import ./lib.nix);
in
rec {

  inputs = {
    # uses git under the hood
    # note: you need a valid ssh key registered in github for this to work
    git_ssh = builtins.fetchGit {
      url = "git@github.com:brianmcgee/secret.git";
      ref = "main";
    };

    # uses git under the hood, which in turn will use cURL for this.
    # note:
    #   whilst it supports a netrc file, it does not respect the `netrc-file` config in `nix.conf`, instead
    #   referring to ~/.netrc
    git_http = builtins.fetchGit {
      url = "https://github.com/brianmcgee/secret.git";
      ref = "main";
    };

    # uses cURL under the hood and respects the `netrc-file` config in `nix.conf`.
    tarball = builtins.fetchTarball "https://github.com/brianmcgee/secret/archive/main.tar.gz";
  };

  # define a test for each input which validates the contents of brianmcgee/secret
  tests = lib.genAttrs (builtins.attrNames inputs) (
    pname:
    lib.mkTest {
      inherit pkgs pname;
      input = inputs.${pname};
    }
  );

  # a convenience for building all tests in one call e.g. nix-build -A check
  check = pkgs.symlinkJoin {
    name = "check";
    paths = builtins.attrValues tests;
  };

}
