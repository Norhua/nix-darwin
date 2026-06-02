# nix-darwin 配置

这是一个从 [ryan4yin/nix-darwin-kickstarter](https://github.com/ryan4yin/nix-darwin-kickstarter) 修改而来的个人 macOS 配置，使用 flakes、nix-darwin、Home Manager 和 nix-homebrew 管理系统、软件包、Shell 环境和 Homebrew 应用。

当前默认主机配置为 `M4Mini0721`，用户为 `amadeus`，系统架构为 `aarch64-darwin`。

## 目录结构

- `flake.nix`：flake 入口，定义 inputs、主机名、用户名、系统架构和 darwin configuration。
- `flake.lock`：锁定所有 flake 依赖版本，保证可复现构建。
- `macos/configuration.nix`：nix-darwin 主配置，包含 Nix、主机、用户和 Homebrew 初始化设置。
- `macos/apps.nix`：系统级 Nix 包、字体、Homebrew taps、brews 和 casks。
- `macos/system.nix`：macOS 系统 defaults，例如 Dock、Finder、窗口和菜单栏设置。
- `macos/service.nix`：launchd 服务配置，例如 `sunshine`、`mihomo`、`easytier`。
- `home-manager/home.nix`：Home Manager 入口。
- `home-manager/shell.nix`：fish、zoxide、starship、git、delta 等用户环境。
- `home-manager/spotify.nix`：spicetify 配置。
- `overlays/default.nix`：自定义 overlays，目前提供 `pkgs.stable`。

## 使用前需要修改

如果把这份配置用于其他机器，至少需要检查这些位置：

- `flake.nix` 中的 `username`、`hostname` 和 `system`。
- `macos/configuration.nix` 中 `nix-homebrew.user` 目前硬编码为 `amadeus`。
- `macos/service.nix` 中 `mihomo` 和 `easytier` 的配置路径目前包含 `/Users/amadeus`。
- `home-manager/shell.nix` 中 fish 会 source `$HOME/dotfile/config_home/my_fish/...`。
- `home-manager/shell.nix` 中 git 用户名和邮箱。

注意：`homebrew.onActivation.cleanup = "zap"` 会在激活时卸载这里未声明的 Homebrew formula/cask 及相关文件。首次迁移已有 Homebrew 环境前建议先确认 `macos/apps.nix` 中的列表完整。

## 常用命令

首次应用或切换配置：

```bash
sudo darwin-rebuild switch --flake ~/.config/nix-darwin#M4Mini0721
```

如果尚未安装 `darwin-rebuild`，可以通过 flake input 启动：

```bash
nix run github:nix-darwin/nix-darwin/master#darwin-rebuild -- switch --flake ~/.config/nix-darwin#M4Mini0721
```

之后也可以使用配置中安装的 `nh`：

```bash
nh darwin switch ~/.config/nix-darwin#M4Mini0721
```

更新所有 flake inputs：

```bash
nix flake update
```

只更新某个 input：

```bash
nix flake lock --update-input nixpkgs
```

格式化 Nix 代码：

```bash
nix fmt
```

检查 flake：

```bash
nix flake check
```

## Review 记录

- 配置整体模块拆分清晰，入口、macOS 系统配置、软件列表、服务和 Home Manager 责任边界比较明确。
- `nixpkgs-unstable`、`nix-darwin/master`、`home-manager/master` 搭配合理，但更新频率高，建议每次 `nix flake update` 后运行一次 `nix flake check` 或至少执行一次 dry build。
- 当前有多处用户和路径硬编码，作为个人配置没问题；如果要泛化成模板，建议统一改为从 `username` 或 `config.users.users.${username}.home` 派生。
- `homebrew.onActivation.cleanup = "zap"` 行为较强，适合完全声明式管理 Homebrew，但不适合保留手工安装应用。
- launchd 服务写入 `/var/log/mihomo` 和 `/var/log/easytier`，需要确保目录存在且权限合适，否则服务可能启动但日志写入失败。
- 当前仓库是 Git 仓库时，Nix flake 通常只会纳入已被 Git 跟踪的文件。新增或修改 Nix 文件后，建议先 `git add` 再执行 flake 构建，避免本地构建读不到未跟踪文件。

## 参考

- [nix-darwin manual](https://daiderd.com/nix-darwin/manual/index.html)
- [Home Manager manual](https://nix-community.github.io/home-manager/)
- [NixOS & Flakes Book](https://github.com/ryan4yin/nixos-and-flakes-book)
