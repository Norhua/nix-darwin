{
  outputs,
  inputs,
  pkgs,
  ...
}:
{
  ##########################################################################
  #
  #  在这里安装所有应用和软件包。
  #
  #  注意：所有可用选项都可以在这里找到：
  #    https://daiderd.com/nix-darwin/manual/index.html
  #
  #
  ##########################################################################

  # 从 Nix 官方软件仓库安装软件包。
  #
  # 这里安装的软件包对所有用户可用，并且可跨机器复现，也支持回滚。
  # 但在 macOS 上，它的稳定性通常不如 Homebrew。
  #
  # 相关讨论：https://discourse.nixos.org/t/darwin-again/29331
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    outputs.overlays.stable
    inputs.llm-agents.overlays.default
  ];
  environment.systemPackages = with pkgs; [
    # nix-darwin
    nh
    nixfmt
    # lib and tool
    perl5Packages.Apprainbarf
    coreutils-prefixed
    stable.mpd
    nodejs_24
    diffutils
    gnupatch
    ripgrep
    delve # go language debugger
    p7zip
    tree
    tmux
    wget
    bat
    fzf
    git
    fd
    uv

    # tui app
    llm-agents.antigravity-cli
    llm-agents.claude-code
    llm-agents.opencode
    # llm-agents.codex
    tree-sitter
    fastfetch
    lazygit
    neovim
    yazi
    rmpc
    htop
    gh

    # service
    orbstack
    docker

    # language
    python3
    lua
    go

    # gui app
    # bitwarden-desktop
    # betterdisplay
    telegram-desktop
    llama-cpp
    firefox
    kitty
    mpv
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
    nerd-fonts.sauce-code-pro
    nerd-fonts.fira-code

    lxgw-wenkai-tc
    lxgw-wenkai
  ];

  # 通过 Homebrew 安装的应用不受 Nix 管理，也不可复现！
  # 但在 macOS 上，Homebrew 的应用选择比 nixpkgs 丰富得多，尤其是 GUI 应用！
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      # `zap`：卸载这里未列出的所有 formula 及其相关文件。
      cleanup = "zap";
      extraFlags = [ "--verbose" ];
    };

    taps = [
      "laishulu/homebrew" # macism
      # "anomalyco/tap" # opencode
    ];
    brews = [
      "laishulu/homebrew/macism" # im-select 的依赖，用于切换输入法
      "cliproxyapi"
      # "anomalyco/tap/opencode"
      # "aria2"  # 下载工具
    ];
    casks = [
      # tools
      "karabiner-elements"
      "hammerspoon"
      # "finetune"
      "raycast"
      "obs"

      "visual-studio-code"
      "google-chrome"
      "antigravity"
      "localsend"
      "moonlight"
      "codex-app"
      "cc-switch"
      "inkscape"
      "termius"
      "pixpin"
      "zotero"
      "utm"

      # Office 365
      "microsoft-powerpoint"
      "microsoft-onenote"
      "microsoft-excel"
      "microsoft-word"
      "onedrive"

      "uuremote"
      "wechat"
      "qq"
    ];
  };
}
