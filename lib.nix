final: prev: {
  # A quick way of validating the secret repo was included correctly by looking for a well-known value in a well-known
  # file.
  mkTest =
    {
      pkgs,
      input,
      pname,
    }:
    pkgs.runCommandLocal pname { } ''
      set -euo pipefail

      path="${input}/hello.txt"
      expected="world"
      actual=$(cat ${input}/hello.txt)

      if [ "$actual" != "$expected" ]; then
          echo "failure: expected '$expected', found '$actual' in $path"
          exit 1
      fi

      mkdir -p "$out/${pname}"
      cp $path "$out/${pname}/"
    '';
}
