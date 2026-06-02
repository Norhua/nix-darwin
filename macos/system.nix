{ pkgs, ... }:

###################################################################################
#
#  macOS 系统配置
#
#  所有配置选项都在这里有文档：
#    https://daiderd.com/nix-darwin/manual/index.html#sec-options
#
###################################################################################
{
  system = {
    stateVersion = 6;
    startup.chime = false; # 关闭开机提示音

    defaults = {
      # dock 栏设置
      dock = {
        autohide = true; # 确保开启了自动隐藏
        autohide-delay = 0.0; # 彻底消除防误触延迟（浮点数）
        autohide-time-modifier = 0.1; # 大幅加快弹出的滑动动画速度
        mru-spaces = false; # 关闭最近使用的空间排序
      };

      # 访达设置
      finder = {
        AppleShowAllFiles = false; # 不显示隐藏文件
        FXPreferredViewStyle = "Nlsv"; # 默认打开列表视图
        NewWindowTarget = "Home"; # 默认打开家目录
        QuitMenuItem = false; # 允许退出访达
        ShowPathbar = true; # 显示路径栏
        ShowStatusBar = true; # 显示底部状态栏
        _FXSortFoldersFirst = true; # 按名称排序时将文件夹排在前面
      };
      # 配合 finder 中的 AppleShowAllFiles 选项
      # 达到只在其他应用打开的文件选择器中显示 dotfile
      NSGlobalDomain = {
        AppleShowAllFiles = true;
      };

      # 辅助功能设置
      universalaccess = {
        reduceMotion = true; # 减少界面动画
      };

      CustomUserPreferences = {
        "com.microsoft.VSCode" = {
          # 快捷键设置
          NSUserKeyEquivalents = {
            "Copy" = "^c";
          };
        };

        # 傻逼 bilibil 后台播放切换流导致播放卡顿和
        # 回归前台后进度回溯问题。
        # 不需要修改系统休眠设置了
        # "org.nixos.firefox" = {
        #   # 关闭 nixpkg 中的 firefox 的 macOS App Nap
        #   # 对应命令: defaults write org.mozilla.firefox NSAppSleepDisabled -bool YES
        #   NSAppSleepDisabled = true;
        # };

      };

      # 快捷键设置
      WindowManager.EnableTilingOptionAccelerator = false; # 禁用按住 alt 键平铺窗口
      NSGlobalDomain = {
        NSWindowShouldDragOnGesture = false; # 不启用cmd + 鼠标拖动窗口
      };

      # Other
      menuExtraClock.Show24Hour = true; # 显示 24 小时制时钟
    };
  };

  # 允许使用 Touch ID 进行 sudo 认证
  # security.pam.services.sudo_local.touchIdAuth = true;
}
