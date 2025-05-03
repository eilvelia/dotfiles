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
  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    asciinema
    bat
    btop
    cyme
    delta
    diff-so-fancy
    direnv
    duf
    eza
    fd
    fzf
    gocryptfs
    highlight
    httpie
    hyfetch
    hyperfine
    iperf
    jq
    luajit
    mdcat
    miniserve
    mosh
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

    unstable.neovim

    nil
    nix-output-monitor
    nix-tree
    nvd
  ] ++ lib.optionals isLinux [
    du-dust
    dut
    nh
  ];

  xdg.configFile = {
    "git".source = link "${dotfiles}/git";
    "nvim".source = link "${dotfiles}/nvim";
    "fish".source = link "${dotfiles}/fish";
    "kitty".source = link "${dotfiles}/kitty";
    "ranger".source = link "${dotfiles}/ranger";
    "direnv/direnvrc".source = link "${dotfiles}/direnv/direnvrc";

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
    # TODO: try also lorri?
    nix-direnv.enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
