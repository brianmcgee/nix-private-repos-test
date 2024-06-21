rec {
  inputs = {
    git = fetchGit {
      url = "git@github.com:brianmcgee/secret.git";
      ref = "main";
    };
    http = fetchGit {
      url = "https://github.com/brianmcgee/secret.git";
      ref = "main";
    };
    nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-24.05.tar.gz";
  };

  tests =
    let
      pkgs = import inputs.nixpkgs { };
      lib = pkgs.lib.extend (import ./lib.nix);
    in
    lib.genAttrs
      [
        "git"
        "http"
      ]
      (
        pname:
        lib.mkTest {
          inherit pkgs pname;
          input = inputs.${pname};
        }
      );

}
