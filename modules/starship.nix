{ lib, ... }:

let
  prependDollarAndJoinWith =
    separator: strings: builtins.concatStringsSep separator (map (s: "$" + s) strings);
  starshipVar = s: "\$\{${s}\}";

  infrastructure = [
    "pulumi"
    "terraform"
    "aws"
    "gcloud"
    "openstack"
    "azure"
  ];

  versionControl = [
    "vcsh"
    "pijul_channel"
    "hg_branch"
    "git_state"
    "git_branch"
    "git_commit"
    "git_metrics"
    "git_status"
  ];

  buildTooling = [
    "cmake"
    "gradle"
    "meson"
  ];

  environment = [
    "guix_shell"
    "nix_shell"
    "direnv"
    "env_var"
  ];

  languages = [
    "c"
    "cobol"
    "elixir"
    "elm"
    "erlang"
    "fennel"
    "gleam"
    "golang"
    "haskell"
    "haxe"
    "java"
    "julia"
    "kotlin"
    "lua"
    "nim"
    "nodejs"
    "ocaml"
    "opa"
    "perl"
    "php"
    "purescript"
    "python"
    "raku"
    "rlang"
    "red"
    "ruby"
    "rust"
    "scala"
    "solidity"
    "swift"
    "typst"
    "vlang"
    "zig"
    "crystal"

    "deno"
    "dotnet"
  ];

  containerization = [
    "container"
    "singularity"
    "kubernetes"
    "docker_context"
    "vagrant"
  ];
in
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = "$jobs󱄅 (red)$username $directory ${
        lib.concatMapStringsSep "" (prependDollarAndJoinWith "") [
          languages
          buildTooling
          infrastructure
          environment
          containerization
          [
            "cmd_duration"
            "fill"
          ]
        ]
      }${prependDollarAndJoinWith "" versionControl}$line_break$character";

      add_newline = true;

      fill.symbol = " ";

      jobs = {
        symbol = "󱟱 ";
        format = "[$number$symbol]($style)";
      };

      username = {
        format = "[$user]($style)";
        show_always = true;
        style_user = "purple bold";
      };

      character = {
        success_symbol = "[>](bold)";
        error_symbol = "[>](red bold)";
        vicmd_symbol = "[>](bold)";
      };

      directory = {
        format = "at [$path]($style)[$read_only]($read_only_style)";
        truncation_length = 5;
        truncation_symbol = ".../";
        home_symbol = " ~";
        read_only = "  ";
        read_only_style = "red";
      };

      nix_shell = {
        format = "via [$state($name)]($style) ";
        impure_msg = "󰼩 ";
        pure_msg = "󱩰 ";
      };

      status = {
        format = "[$symbol](red)";
        symbol = "";
        success_symbol = " ";
        disabled = false;
      };

      git_branch = {
        format = " [$symbol$branch(:$remote_branch)]($style)";
        style = "white";
        symbol = " ";
      };

      git_status = {
        format = "( [${
          prependDollarAndJoinWith "" [
            "conflicted"
            "untracked"
            "modified"
            "staged"
            "renamed"
            "deleted"
          ]
        }](218) [$ahead_behind$stashed]($style))";
        style = "red";
        ahead = "[⇡${starshipVar "count"}](lavender)";
        conflicted = " ";
        deleted = "󰗨 ${starshipVar "count"}";
        diverged = "⇕⇡${starshipVar "ahead_count"}⇣${starshipVar "behind_count"}";
        modified = "[ ${starshipVar "count"}]($style)";
        staged = "[+$count](green)";
        stashed = " ${starshipVar "count"}";
        untracked = "[ ${starshipVar "count"}]($style)";
      };

      git_state = {
        format = "\\([$state( $progress_current/$progress_total)]($style)\\)";
        style = "bold yellow";
        bisect = "BISECTING";
      };

      git_commit = {
        format = " [\\($hash$tag\\)]($style)";
      };

      git_metrics = {
        disabled = false;
        format = " [+$added](green)|[-$deleted](red)";
        only_nonzero_diffs = true;
      };
    }
    // builtins.listToAttrs (
      map
        (tuple: {
          name = builtins.elemAt tuple 0;
          value = {
            symbol = builtins.elemAt tuple 1;
          };
        })
        [
          [
            "aws"
            "  "
          ]

          [
            "azure"
            ""
          ]

          [
            "buf"
            " "
          ]

          [
            "bun"
            " "
          ]

          [
            "c"
            " "
          ]

          [
            "cpp"
            " "
          ]

          [
            "cmake"
            " "
          ]

          [
            "conda"
            " "
          ]

          [
            "crystal"
            " "
          ]

          [
            "dart"
            " "
          ]

          [
            "deno"
            " "
          ]

          [
            "docker_context"
            " "
          ]

          [
            "elixir"
            " "
          ]

          [
            "elm"
            " "
          ]

          [
            "fennel"
            " "
          ]

          [
            "fossil_branch"
            " "
          ]

          [
            "gcloud"
            "  "
          ]

          [
            "golang"
            " "
          ]

          [
            "guix_shell"
            " "
          ]

          [
            "haskell"
            " "
          ]

          [
            "haxe"
            " "
          ]

          [
            "hg_branch"
            " "
          ]

          [
            "hostname"
            " "
          ]

          [
            "java"
            " "
          ]

          [
            "julia"
            " "
          ]

          [
            "kotlin"
            " "
          ]

          [
            "lua"
            " "
          ]

          [
            "memory_usage"
            "󰍛 "
          ]

          [
            "meson"
            "󰔷 "
          ]

          [
            "nim"
            "󰆥 "
          ]

          [
            "nodejs"
            " "
          ]

          [
            "ocaml"
            " "
          ]

          [
            "openstack"
            ""
          ]

          [
            "package"
            "󰏗 "
          ]

          [
            "perl"
            " "
          ]

          [
            "php"
            " "
          ]

          [
            "pijul_channel"
            " "
          ]

          [
            "pixi"
            "󰏗 "
          ]

          [
            "pulumi"
            ""
          ]

          [
            "python"
            " "
          ]

          [
            "rlang"
            "󰟔 "
          ]

          [
            "ruby"
            " "
          ]

          [
            "rust"
            "󱘗 "
          ]

          [
            "scala"
            " "
          ]

          [
            "swift"
            " "
          ]

          [
            "terraform"
            ""
          ]

          [
            "zig"
            " "
          ]

          [
            "gradle"
            " "
          ]
        ]
    );
  };
}
