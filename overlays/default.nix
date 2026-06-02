{ inputs, ... }:
{
  stable = final: prev: {
    stable = inputs.stablepkgs.legacyPackages.${prev.stdenv.hostPlatform.system};
  };
}
