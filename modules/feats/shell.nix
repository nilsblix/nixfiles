{ ... }:
{
    flake.modules.darwin.shell = {
        programs.zsh.enable = true;
    };

    flake.modules.homeManager.shell = { ... }: {
        programs.zsh = {
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
