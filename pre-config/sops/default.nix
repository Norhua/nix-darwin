{
  config,
  # lib,
  pkgs,
  inputs,
  ...
}:
let
in
{
  imports = [
    inputs.sops-nix.darwinModules.sops
  ];
  config = {
    environment.systemPackages = with pkgs; [
      ssh-to-age
      sops
      age # file encryption tool
    ];

    sops = {
      # defaultSopsFile = ../../secrets/sops/default.yaml;
      age.keyFile = "/var/lib/sops-nix/keys.txt";
      # secrets = {
      # };
    };
  };
}
