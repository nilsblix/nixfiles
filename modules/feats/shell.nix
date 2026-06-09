{ ... }:
{
    flake.modules.darwin.shell = { pkgs, ... }: {
        environment.shells = [
            pkgs.fish
        ];
        programs.fish.enable = true;
        programs.zsh.enable = true;
    };

    flake.modules.homeManager.shell = { lib, pkgs, ... }: {
        programs.zsh = lib.mkIf (!pkgs.stdenv.isDarwin) {
            enable = true;
            initContent = ''
                fish
            '';
        };

        programs.fish = {
            enable = true;
            shellInit = ''
                set -U fish_greeting

                function y
                    set tmp (mktemp -t "yazi-cwd.XXXXXX")
                    command yazi $argv --cwd-file="$tmp"
                    if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
                        builtin cd -- "$cwd"
                    end
                    command rm -f -- "$tmp"
                end

                bind \cc 'echo; commandline ""; commandline -f repaint'

                alias codex "nix run github:numtide/llm-agents.nix#codex"
                alias da "direnv allow"
                alias gd "git diff"
                alias gs "git status"
                alias nd "nix develop -c fish"
                alias nvim "~/neovim-flake/result/bin/nvim";
            '';
        };
    };

    flake.modules.nixos.shell = {
        programs.zsh.enable = true;
    };
}
