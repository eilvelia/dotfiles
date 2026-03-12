{ config, pkgs, lib, ... }:
let
  username = "lambda";
  link = config.lib.file.mkOutOfStoreSymlink;
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  homeDir = if isDarwin then "/Users/${username}" else "/home/${username}";
  dotfiles = "${homeDir}/dotfiles";
in {
  _module.args.link = link;
  _module.args.dotfiles = dotfiles;

  home.username = username;
  home.homeDirectory = homeDir;

  home.enableNixpkgsReleaseCheck = false;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    archivemount
    aria2
    asciinema
    atool
    bat
    btop
    check-sieve
    cyme
    delta
    diff-so-fancy
    direnv
    duf
    eza
    fastfetch
    fd
    fzf
    gocryptfs
    highlight
    httpie
    hyfetch
    hyperfine
    iperf
    jq
    just
    luajit
    mdcat
    miniserve
    mosh
    neovim
    nmap
    nq
    nushell
    pgpdump
    pwgen
    ripgrep
    sd
    shellcheck
    skim
    speedtest-cli
    tig
    tree-sitter
    unzip
    zellij

    # nix-related stuff
    nil
    nix-diff
    nix-output-monitor
    nix-tree
    nvd
  ] ++ lib.optionals isLinux [
    dust
    dut
    nh
  ];

  xdg.configFile = {
    "direnv/direnvrc".source = link "${dotfiles}/direnv/direnvrc";
    "fish".source = link "${dotfiles}/fish";
    "git".source = link "${dotfiles}/git";
    "helix".source = link "${dotfiles}/helix";
    "kitty".source = link "${dotfiles}/kitty";
    "nvim".source = link "${dotfiles}/nvim";
    "ranger".source = link "${dotfiles}/ranger";

    "tealdeer/config.toml".text = ''
      [display]
      compact = true

      [style]
      example_text.foreground = "green"
      command_name.foreground = "red"
      example_code.foreground = "cyan"

      [updates]
      auto_update = false
    '';
  };

  xdg.mime.enable = lib.mkForce false;

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
