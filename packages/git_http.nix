{
  lib,
  pkgs,
  inputs,
  pname,
  ...
}:
lib.mkTest {
  inherit pkgs pname;
  input = inputs.${pname};
}
