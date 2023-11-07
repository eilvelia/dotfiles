{ config, pkgs, pkgs-unstable, inputs, ... }:
let
  username = "lambda";
  link = config.lib.file.mkOutOfStoreSymlink;
  isDarwin = pkgs.stdenv.isDarwin;
  homeDir = if isDarwin then "/Users/${username}" else "/home/${username}";
  dotfiles = "${homeDir}/dotfiles";
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
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
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
    # exa
    pkgs-unstable.eza
    difftastic
    diff-so-fancy
    pgpdump
    pwgen
    fzf
    zf
    mdcat
    hyperfine
    du-dust
    opam
    deno
    luajit
    gh
    tldr
    tokei
    unzip
    nmap
    speedtest-cli
    ranger
    nil
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
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
    ".inputrc".source = link "${dotfiles}/inputrc";
  } else {});

  xdg.configFile = {
    "nvim" = { recursive = true; source = link "${dotfiles}/nvim"; };
    "fish" = { recursive = true; source = link "${dotfiles}/fish"; };
    "kitty" = { recursive = true; source = link "${dotfiles}/kitty"; };
  } // (if isDarwin then {} else {
    "sway" = { recursive = true; source = link "${dotfiles}/sway"; };
  });

  nix.registry = if isDarwin then {
    nixpkgs.flake = inputs.nixpkgs-unstable;
    p.flake = inputs.nixpkgs-unstable;
  } else {};

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/lambda/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
