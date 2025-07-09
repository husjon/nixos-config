{ ... }:
{
  programs.ncmpcpp = {
    enable = true;

    settings = {
      volume_change_step = 1;
    };
    bindings = [
      {
        key = "j";
        command = "scroll_down";
      }
      {
        key = "k";
        command = "scroll_up";
      }
      {
        key = "h";
        command = "previous_column";
      }
      {
        key = "l";
        command = "next_column";
      }
      {
        key = "ctrl-b";
        command = "page_up";
      }
      {
        key = "ctrl-u";
        command = "page_up";
      }
      {
        key = "ctrl-f";
        command = "page_down";
      }
      {
        key = "ctrl-d";
        command = "page_down";
      }
      {
        key = "g";
        command = "move_home";
      }
      {
        key = "G";
        command = "move_end";
      }
      {
        key = "n";
        command = "next_found_item";
      }
      {
        key = "N";
        command = "previous_found_item";
      }
    ];
  };
}
