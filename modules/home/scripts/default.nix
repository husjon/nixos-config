{ ... }:
{
  home.file.".local/bin/" = {
    source = ./bin;
    recursive = true;
    executable = true;
  };
}
