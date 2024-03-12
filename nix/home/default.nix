{ config, pkgs, pkgs-unstable, inputs, ... }:
let
  username = "lambda";
  link = config.lib.file.mkOutOfStoreSymlink;
  isDarwin = pkgs.stdenv.isDarwin;
  homeDir = if isDarwin then "/Users/${username}" else "/home/${username}";
  dotfiles = "${homeDir}/dotfiles";
  rel-dotfiles = "../..";
in {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = homeDir;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    neovim
    helix
    tree
    htop
    jq
    ripgrep
    fd
    sd
    bat
    eza
    difftastic
    diff-so-fancy
    highlight
    neofetch
    hyfetch
    pgpdump
    pwgen
    fzf
    zf
    mdcat
    hyperfine
    du-dust
    gh
    tldr
    tokei
    tig
    unzip
    nmap
    duf
    weechat
    ranger
    asciinema
    speedtest-cli
    pkgs-unstable.opam # fails to compile in 23.11
    elan
    deno
    luajit
    ninja
    cmake
    direnv
    nushell
    rizin
    nil
  ] ++ (if isDarwin then [
    goku
    pstree
    encfs # also needs fuse
  ] else []);

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".gitconfig".source = link "${dotfiles}/gitconfig";
  } // (if isDarwin then {
    ".inputrc".source = ./${rel-dotfiles}/inputrc;
    ".vimrc".source = link "${dotfiles}/vimrc";
  } else {});

  xdg.configFile = {
    "nvim" = { recursive = true; source = link "${dotfiles}/nvim"; };
    "fish" = { recursive = true; source = link "${dotfiles}/fish"; };
    "kitty" = { recursive = true; source = link "${dotfiles}/kitty"; };
    "ranger" = { recursive = true; source = link "${dotfiles}/ranger"; };
  } // (if !isDarwin then {
    "sway" = { recursive = true; source = link "${dotfiles}/sway"; };
  } else {});

  nix = if isDarwin then {
    package = pkgs.nix;
    registry.nixpkgs.flake = inputs.nixpkgs-unstable;
    registry.p.flake = inputs.nixpkgs-unstable;
    registry.nixpkgs-stable.flake = inputs.nixpkgs;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      nix-path = [
        "nixpkgs=${inputs.nixpkgs}"
        "nixpkgs-unstable=${inputs.nixpkgs-unstable}"
      ];
    };
  } else {};

  # You can also manage environment variables but you will have to manually
  # source
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  # or
  #  /etc/profiles/per-user/lambda/etc/profile.d/hm-session-vars.sh
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {};

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
