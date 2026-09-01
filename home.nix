{ inputs, pkgs, config, ... }:

let
system = pkgs.stdenv.hostPlatform.system;
dotfiles = "${config.home.homeDirectory}/nixos-env/config";
assets = "${config.home.homeDirectory}/nixos-env/assets";
create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
configs = {
    bat = "bat";
    delta = "delta";
    lazygit = "lazygit";
    kitty = "kitty";
    mango = "mango";
    noctalia = "noctalia";
    nvim = "nvim";
    yazit = "yazi";
};
in
{
    home.username = "bduck";
    home.homeDirectory = "/home/bduck";


    home.file.".face".source = ./assets/face.jpg;

    home.file."Pictures/Wallpapers".source = create_symlink "${assets}/nixos-env/assets/wallpapers";


    xdg.configFile = builtins.mapAttrs ( name: subpath: {
            source = create_symlink "${dotfiles}/${subpath}";
            recursive = true;
            }) configs;


    programs.git = {
        enable = true;
        settings = {
            user = {
                name = "Brennan Duck";
                email = "brennantduck@gmail.com";
            };
            init.defaultBranch = "main";
        };
    }; 



    programs.zsh = {
        enable = true;
        autosuggestion.enable = true;
        oh-my-zsh = {
            enable = true;
            plugins = [
                "git"
            ];
            theme = "robbyrussell";
        };
        shellAliases.ls = "lsd";
        shellAliases.ll = "lsd -alF";
        initContent = ''
        bindkey -s ^g "lazygit\n"
        '';

    };
    programs.starship.enable = true;
    programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
    };


    home.packages = with pkgs; [
            bat
            clang
            clang-tools
            cmake
            delta
            discord
            firefox
            fzf
            ghostty
            go
            gofumpt
            gopls
            kitty
            lazygit
            lsd
            lua5_1
            lua-language-server
            luarocks
            neovim
            ninja
            nodejs
            prettierd
            python3
            obsidian
            readest
            ripgrep
            rustup
            slurp
            spotify
            stremio-linux-shell
            stylua
            tree-sitter
            typescript-language-server
            unzip
            wl-clipboard
            xwayland-satellite
            yazi
            zoxide
            inputs.helium.packages.${system}.default
            ];
    home.stateVersion = "26.05"; # Keep the version from the first Home Manager install.
}
