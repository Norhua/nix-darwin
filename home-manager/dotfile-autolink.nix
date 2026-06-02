{
  config,
  pkgs,
  ...
}:
let
  fishPath = "${config.home.homeDirectory}/nix-config/dotfile/fish";
in
{
  # xdg.configFile."fish/conf.d" = {
  #   source = config.lib.file.mkOutOfStoreSymlink fishPath;
  #   recursive = true;
  # };
}
