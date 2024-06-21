rec {
  inputs = {
    git_ssh = fetchGit {
      url = "git@github.com:brianmcgee/secret.git";
      ref = "main";
    };
    git_http = fetchGit {
      url = "https://github.com/brianmcgee/secret.git";
      ref = "main";
    };
    tarball = fetchTarball "https://github.com/brianmcgee/secret/archive/main.tar.gz";
    nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-24.05.tar.gz";
  };

  tests =
    let
      pkgs = import inputs.nixpkgs { };
      lib = pkgs.lib.extend (import ./lib.nix);
      tests = builtins.filter (n: n != "nixpkgs") (builtins.attrNames inputs);
    in
    lib.genAttrs
      tests
      (
        pname:
        lib.mkTest {
          inherit pkgs pname;
          input = inputs.${pname};
        }
      );

}
