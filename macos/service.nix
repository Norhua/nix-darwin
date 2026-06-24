{
  pkgs,
  config,
  username,
  ...
}:
let
  homeDir = config.users.users.${username}.home;
in
{

  environment.systemPackages = with pkgs; [
    stable.easytier
    # sunshine
    mihomo
  ];

  # # nixpkg sunshine
  # launchd.user.agents.sunshine = {
  #   command = "${pkgs.sunshine}/bin/sunshine";
  #
  #   serviceConfig = {
  #     RunAtLoad = true;
  #     # KeepAlive = true;
  #     StandardOutPath = "${homeDir}/Library/Logs/sunshine/sunshine.log";
  #     StandardErrorPath = "${homeDir}/Library/Logs/sunshine/sunshine.err.log";
  #   };
  # };
  # # homebrew sunshine
  # launchd.user.agents.sunshine = {
  #   command = "/opt/homebrew/opt/sunshine/bin/sunshine";
  #
  #   serviceConfig = {
  #     Label = "dev.lizardbyte.sunshine";
  #     RunAtLoad = true;
  #     # KeepAlive = true;
  #     StandardOutPath = "${homeDir}/Library/Logs/sunshine/sunshine.log";
  #     StandardErrorPath = "${homeDir}/Library/Logs/sunshine/sunshine.err.log";
  #   };
  # };

  launchd.daemons.mihomo = {
    command = "${pkgs.mihomo}/bin/mihomo -d /Users/amadeus/.config/mihomo";

    serviceConfig = {
      RunAtLoad = true;
      # KeepAlive = true;
      StandardOutPath = "/var/log/mihomo/mihomo.log";
      StandardErrorPath = "/var/log/mihomo/mihomo.error.log";
    };
  };

  launchd.daemons.easytier = {
    # command = "${pkgs.easytier}/bin/easytier-core -c /Users/amadeus/.config/easytier/config.toml";
    command = "${pkgs.stable.easytier}/bin/easytier-core -c /Users/amadeus/.config/easytier/config.toml";

    serviceConfig = {
      RunAtLoad = true;
      # KeepAlive = true;
      StandardOutPath = "/var/log/easytier/easytier.log";
      StandardErrorPath = "/var/log/easytier/easytier.error.log";
    };
  };

}
