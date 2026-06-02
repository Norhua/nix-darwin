{
  config,
  pkgs,
  lib,
  ...
}:
{
  # home.packages = with pkgs; [
  # ];

  # zsh
  # programs.zsh = {
  #   zprof.enable = true;
  #
  #   enable = true;
  #   zsh-abbr.enable = true;
  #   initContent =
  #     let
  #       zshConfigEarlyInit = lib.mkOrder 500 ''
  #         export ZSH_DISABLE_COMPFIX="true"
  #       '';
  #       myZshConfig = lib.mkOrder 1500 ''
  #         source $HOME/.config/zsh/zshrc;
  #       '';
  #     in
  #     lib.mkMerge [
  #       zshConfigEarlyInit
  #       myZshConfig
  #     ];
  #   enableCompletion = true;
  #   # completionInit = ''
  #   #   autoload -Uz compinit
  #   #   fpath=(''${(ou)fpath}) # Stable fpath order hence consistent cache hit.
  #   #   if [[ ! -s ''${ZDOTDIR:-$HOME}/.zcompdump || \
  #   #         /run/current-system/sw -nt ''${ZDOTDIR:-$HOME}/.zcompdump ]]; then
  #   #     compinit
  #   #     zcompile ''${ZDOTDIR:-$HOME}/.zcompdump 2>/dev/null
  #   #   else
  #   #     compinit -C
  #   #   fi
  #   # '';
  #
  #   autosuggestion.enable = true;
  #   syntaxHighlighting.enable = true;
  #   oh-my-zsh = {
  #     enable = true;
  #     # theme = "robbyrussell";
  #     plugins = [
  #       "git"
  #       "fzf"
  #       # "autojump"
  #     ];
  #   };
  # };
  programs.fish = {
    enable = true;
    shellInit = ''
      source $HOME/dotfile/config_home/my_fish/config.fish
      source $HOME/dotfile/config_home/my_fish/nix-darwin.fish
    '';
  };
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    # enableZshIntegration = true;
  };
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    # enableZshIntegration = true;
    configPath = "${config.xdg.configHome}/starship/starship.toml";
  };

  # git
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "norhua";
        email = "norhua@outlook.com";
      };
    };
  };
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  # programs.fzf = {
  #   enable = true;
  #   enableZshIntegration = true;
  #   tmux.enableShellIntegration = false;
  # };
}
