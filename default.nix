rec {
  inputs = {
    git_ssh = builtins.fetchGit {
      url = "git@github.com:brianmcgee/secret.git";
      ref = "main";
    };
    git_http = builtins.fetchGit {
      url = "https://github.com/brianmcgee/secret.git";
      ref = "main";
    };
    tarball = builtins.fetchTarball "https://github.com/brianmcgee/secret/archive/main.tar.gz";
    nixpkgs = builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-24.05.tar.gz";
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
