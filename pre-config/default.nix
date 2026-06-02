{ inputs, ... }:
{
  preConf = {
    imports = [
      # 需要配置的配置模块

      # 默认直接引用开启的配置
      ./sops
    ];
  };
}
