{
  hostname,
  username,
  outputs,
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./service.nix
    ./system.nix
    ./apps.nix
    outputs.darwinModules.preConf

    inputs.nix-homebrew.darwinModules.nix-homebrew
    {
      nix-homebrew = {
        enable = true;
        enableRosetta = true;
        user = "amadeus";
        autoMigrate = true;
      };
    }
  ];

  ##########################################################
  # nix 配置
  ##########################################################
  nix = {
    # Determinate 使用它自己的守护进程来管理 Nix 安装，
    # 这会与 nix-darwin 原生的 Nix 管理机制发生冲突。
    #
    # 如果你使用的是 Determinate Nix，请把这里设为 false。
    # 注意：关闭这个选项后，下面所有 Nix 配置都会失效，
    # 你需要手动修改 /etc/nix/nix.custom.conf 来补上对应参数。
    enable = true;
    package = pkgs.lixPackageSets.latest.lix;

    channel.enable = false;

    settings = {
      # 全局启用 flakes
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      accept-flake-config = true;
      # 会优先于官方缓存（https://cache.nixos.org）使用的替代源
      substituters = [
        "https://mirrors.cernet.edu.cn/nix-channels/store"
        # "https://mirror.nju.edu.cn/nix-channels/store"
        # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        # "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      extra-substituters = [ "https://cache.numtide.com" ]; # llm-agents.nix 的二进制缓存
      extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
      builders-use-substitutes = true;

      # 因为下面这个问题，所以禁用 auto-optimise-store：
      #   https://github.com/NixOS/nix/issues/7273
      # "error: cannot link '/nix/store/.tmp-link-xxxxx-xxxxx' to '/nix/store/.links/xxxx': File exists"
      auto-optimise-store = false;
    };

    # 每周执行一次垃圾回收，以降低磁盘占用
    gc = {
      automatic = lib.mkDefault true;
      options = lib.mkDefault "--delete-older-than 7d";
    };
  };
  # # 避免 legacy channel 路径告警，并为 nh 提供默认 flake 目标
  # environment.variables = {
  #   # 纯 flakes 流程，不再使用 channels
  #   NIX_PATH = [ "nixpkgs=flake:nixpkgs" ];
  #   # 让 `nh darwin switch` 无参时也能直接定位到当前主机配置
  #   NH_DARWIN_FLAKE = "/Users/amadeus/.config/nix-darwin#M4Mini0721";
  # };

  ##########################################################
  # host 配置
  ##########################################################
  networking.hostName = hostname;
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;

  ##########################################################
  # 用户配置
  ##########################################################
  users.users."${username}" = {
    home = "/Users/${username}";
    description = username;
    shell = pkgs.fish;
  };
  system.primaryUser = username;
  nix.settings.trusted-users = [ username ];

  # 创建会加载 nix-darwin 环境的 /etc/zshrc。
  # 如果你想使用 Darwin 默认的 shell，也就是 zsh，这一步是必需的。
  # programs.zsh.enable = true;
  # programs.zsh.enableGlobalCompInit = false;
  programs.fish.enable = true;

}
