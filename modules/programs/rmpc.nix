{ config, lib, ... }:
let
  cfg = config.husjon;
in
{
  options.husjon.programs.rmpc.enable = lib.mkEnableOption "rmpc";

  config = lib.mkIf cfg.programs.rmpc.enable {
    home-manager.users."${cfg.user.username}" = {
      programs.rmpc = {
        enable = true;

        config = ''
          #![enable(implicit_some)]
          #![enable(unwrap_newtypes)]
          #![enable(unwrap_variant_newtypes)]
          (
              volume_step: 1,
              max_fps: 60,
              theme: Some("default"),

              tabs: [
                  ( name: "Queue",          pane: Pane(Queue)),
                  ( name: "Directories",    pane: Pane(Directories)),
                  ( name: "Artists",        pane: Pane(Artists)),
                  ( name: "Album Artists",  pane: Pane(AlbumArtists)),
                  ( name: "Albums",         pane: Pane(Albums)),
                  ( name: "Playlists",      pane: Pane(Playlists),),
                  ( name: "Search",         pane: Pane(Search),),
              ],
          )
        '';
      };

      home.file.".config/rmpc/themes/default.ron".text = ''
        #![enable(implicit_some)]
        #![enable(unwrap_newtypes)]
        #![enable(unwrap_variant_newtypes)]
        (
            show_song_table_header: true,
            tab_bar: (),
            symbols: (
                song: "S",
                dir: "D",
                marker: "M",
            ),
            progress_bar: (
                symbols: ["[", "-", ">", " ", "]"],
            ),
            scrollbar: (
                symbols: ["│", "█", "▲", "▼"],
            ),
            song_table_format: [
                (
                    prop: (kind: Property(Artist),
                        default: (kind: Text("Unknown"))
                    ),
                    width: "33%",
                ),
                (
                    prop: (kind: Property(Title),
                        default: (kind: Text("Unknown"))
                    ),
                    width: "33%",
                ),
                (
                    prop: (kind: Property(Album), style: (fg: "white"),
                        default: (kind: Text("Unknown Album"), style: (fg: "white"))
                    ),
                    width: "33%",
                ),
                (
                    prop: (kind: Property(Duration),
                        default: (kind: Text("-"))
                    ),
                    width: "12",
                    alignment: Right,
                ),
            ],
            layout: Split(
                direction: Vertical,
                panes: [
                    (
                        pane: Split(
                            direction: Horizontal,
                            panes: [
                                ( pane: Pane(AlbumArt), size: "10%"),
                                ( pane: Pane(Header),   size: "90%"),
                            ],
                        ),
                        size: "6",
                    ),

                    ( pane: Pane(Tabs),        size: "3"),
                    ( pane: Pane(TabContent),  size: "100%"),
                    ( pane: Pane(ProgressBar), size: "1"),
                ],
            ),
            header: (
                rows: [
                    (
                        left: [ ],
                        center: [
                            (kind: Text("")),
                            (kind: Property(Song(Title)), style: (modifiers: "Bold"),
                                default: (kind: Text("No Song"), style: (modifiers: "Bold"))
                            )
                        ],
                        right: [
                            (kind: Property(Widget(ScanStatus)), style: (fg: "blue")),
                            (kind: Property(Widget(Volume)), style: (fg: "blue"))
                        ]
                    ),
                    (
                        left: [ ],
                        center: [
                            (kind: Text("")),
                            (kind: Property(Song(Artist)), style: (fg: "yellow", modifiers: "Bold"),
                                default: (kind: Text("Unknown"), style: (fg: "yellow", modifiers: "Bold"))
                            ),
                            (kind: Text(" - ")),
                            (kind: Property(Song(Album)),
                                default: (kind: Text("Unknown Album"))
                            )
                        ],
                        right: [
                            (
                                kind: Property(Widget(States(
                                    active_style: (fg: "white", modifiers: "Bold"),
                                    separator_style: (fg: "white")))
                                ),
                                style: (fg: "dark_gray")
                            ),
                        ]
                    ),
                    (
                        left: [ ],
                        center: [
                            (kind: Text("["), style: (fg: "yellow", modifiers: "Bold")),
                            (kind: Property(Status(StateV2(playing_label: "Playing", paused_label: "Paused", stopped_label: "Stopped"))), style: (fg: "yellow", modifiers: "Bold")),
                            (kind: Text("]"), style: (fg: "yellow", modifiers: "Bold"))
                        ],
                        right: [
                            (kind: Property(Status(Elapsed))),
                            (kind: Text(" / ")),
                            (kind: Property(Status(Duration))),
                            (kind: Text(" (")),
                            (kind: Property(Status(Bitrate))),
                            (kind: Text(" kbps)"))
                        ],
                    ),
                ],
            ),
        )
      '';

    };
  };
}
