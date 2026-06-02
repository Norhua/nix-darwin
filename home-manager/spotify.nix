{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
    in
    {
      enable = true;
      spotifyPackage = pkgs.spotify;
      enabledCustomApps = with spicePkgs.apps; [
        lyricsPlus
        marketplace
      ];
      # colorScheme = "violet";
      # theme = spicePkgs.themes.bloom;
      enabledExtensions = with spicePkgs.extensions; [
        # adblock
        adblockify
        # hidePodcasts
        shuffle
      ];
    };

  home.activation.disableSpotifyUpdates =
    lib.mkIf (pkgs.stdenv.isDarwin && config.programs.spicetify.enable)
      (
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          SPOTIFY_UPDATE_DIR=~/Library/Application\ Support/Spotify/PersistentCache/Update
          if ! /usr/bin/stat -f "%Sf" "$SPOTIFY_UPDATE_DIR" 2> /dev/null | grep -q uchg; then
            rm -rf "$SPOTIFY_UPDATE_DIR"
            mkdir -p "$SPOTIFY_UPDATE_DIR"
            /usr/bin/chflags uchg "$SPOTIFY_UPDATE_DIR"
          fi
        ''
      );
}
