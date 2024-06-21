{ config, pkgs, pkgs-unstable, inputs, ... }:
let
  username = "lambda";
  link = config.lib.file.mkOutOfStoreSymlink;
  isDarwin = pkgs.stdenv.isDarwin;
  homeDir = if isDarwin then "/Users/${username}" else "/home/${username}";
  dotfiles = "${homeDir}/dotfiles";
  rel-dotfiles = "../..";
in {
  home.username = username;
  home.homeDirectory = homeDir;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    pkgs-unstable.neovim
    pkgs-unstable.helix
    tree
    jq
    ripgrep
    fd
    sd
    bat
    eza
    difftastic
    diff-so-fancy
    highlight
    hyfetch
    pgpdump
    pwgen
    fzf
    zf
    mdcat
    miniserve
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
    graphviz
    ranger
    asciinema
    speedtest-cli
    iperf
    mosh
    abduco
    direnv
    scrypt
    nushell
    rizin
    gocryptfs
    opam
    elan
    pkgs-unstable.deno
    luajit
    ninja
    cmake
    nil
    nix-output-monitor
    nvd
  ] ++ (if isDarwin then [
    neofetch
    htop
    goku
    pstree
  ] else [
    syncthing
    nh
  ]);

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
    registry.nixpkgs.flake = inputs.nixpkgs;
    registry.p.flake = inputs.nixpkgs;
    registry.unstable.flake = inputs.nixpkgs-unstable;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      nix-path = [
        "nixpkgs=${inputs.nixpkgs}"
        "unstable=${inputs.nixpkgs-unstable}"
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
