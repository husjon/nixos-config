{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.husjon;
in
{
  imports = [
    ./blender.nix
    ./fuzzel.nix
    ./mako.nix
    ./ncmpcpp.nix
    ./neovim.nix
    ./steam.nix
    ./tmux.nix
    ./waybar.nix
  ];

  options.husjon.programs.extraPrograms = lib.mkOption {
    description = "A list of extra programs to install for the user";
    default = [ ];
    type = lib.types.listOf lib.types.package;
  };

  config = lib.mkIf cfg.user.enable {
    home-manager.users."${cfg.user.username}" = {
      home.packages =
        with pkgs;
        [
          # TODO: look into cleaning up / moving these packages
          discord
          firefox
          grim
          htop
          libnotify
          lxsession
          mpv # video player
          nerd-fonts.fira-code
          nerd-fonts.symbols-only
          networkmanagerapplet
          nil
          nixfmt-rfc-style
          obsidian
          pavucontrol
          playerctl
          pqiv # image viewer
          pureref
          ripgrep
          slurp
          spotify
          trash-cli
          unstable.brave
          vivaldi
          vscode
          wl-clipboard
          yazi
          zathura # pdf viewer
        ]
        ++ cfg.programs.extraPrograms;

      home.sessionVariables = {
        NIL_PATH = "${pkgs.nil}/bin/nil";
      };

      programs.fzf.enable = true;

      programs.starship.enable = true;
    };
  };
}
