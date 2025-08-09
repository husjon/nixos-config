{ pkgs, ... }:
{
  home.packages = with pkgs; [
    git-crypt
    git-graph
  ];

  programs.git = {
    enable = true;

    extraConfig = {
      core.excludesfile = "~/.gitignore";
    };
  };

  home.file.".gitignore" = {
    text = ''
      .borg-nobackup
    '';
  };

  programs.lazygit.enable = true;
}
