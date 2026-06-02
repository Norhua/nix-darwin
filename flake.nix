{
  description = "Nix for macOS configuration";

  ##################################################################################################################
  #
  # 想更深入了解 Nix？在找适合新手的教程吗？
  # 可以看看 https://github.com/ryan4yin/nixos-and-flakes-book
  #
  ##################################################################################################################

  # 这里的 nixConfig 只会影响 flake 本身，不会影响系统配置！
  nixConfig = {
    substituters = [
      # "https://mirrors.cernet.edu.cn/nix-channels/store"
      "https://mirror.nju.edu.cn/nix-channels/store"
      # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      # "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
      "https://cache.nixos.org"
    ];
  };

  # 这是 flake.nix 的标准写法。`inputs` 是这个 flake 的依赖，
  # `inputs` 里的每一项在拉取并构建后，都会作为参数传给 `outputs` 函数。
  # 可以通过 `nh darwin switch --update-input XXX` 来独立更新某个 input
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    stablepkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    llm-agents.url = "github:numtide/llm-agents.nix";

    nix-darwin = {
      # nix-darwin must track master when nixpkgs tracks nixpkgs-unstable.
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
      # 修复问题 https://github.com/zhaofengli/nix-homebrew/issues/138
      inputs.brew-src.url = "github:Homebrew/brew/5.1.11";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # `outputs` 函数会返回这个 flake 的所有构建结果。
  # 一个 flake 可以有很多用法，也可以产出不同类型的输出，
  # `outputs` 中的参数都定义在 `inputs` 里，可以直接通过名字引用。
  # 不过 `self` 是个例外，这个特殊参数指向 `outputs` 自身（自引用）。
  # 这里的 `@` 语法会给 inputs 参数对应的属性集起别名，方便在函数内部使用。
  outputs =
    inputs@{
      self,
      nixpkgs,
      sops-nix,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      username = "amadeus";
      hostname = "M4Mini0721";
      system = "aarch64-darwin"; # aarch64-darwin 或 x86_64-darwin
      specialArgs = {
        inherit inputs username hostname;
        inherit (self) outputs;
      };

      # specialArgs = inputs // {
      #   inherit username hostname;
      # };
    in
    {
      darwinModules = import ./pre-config { inherit inputs; inherit (self) outputs; };

      overlays = import ./overlays { inherit inputs; };

      darwinConfigurations."${hostname}" = nix-darwin.lib.darwinSystem {
        inherit system specialArgs;

        modules = [
          ./macos/configuration.nix

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users.${username} = import ./home-manager/home.nix;
          }
        ];
      };
      # Nix 代码格式化工具
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
    };
}
