{ config, pkgs, ... }:
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
    unstable.neovim
    unstable.helix
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
    nq
    direnv
    scrypt
    nushell
    rizin
    gocryptfs
    btop
    unstable.opam
    elan
    unstable.deno
    luajit
    ninja
    cmake
    nix-output-monitor
    nvd
    nil
  ] ++ (if isDarwin then [
    neofetch
    htop
    goku
    pstree
    katahexCPU
    katahexCPU19
  ] else [
    zf
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

  launchd.agents.homebrew-update = {
    enable = true;
    config.ProgramArguments = [
      "/usr/bin/env"
      "brew"
      "update"
    ];
    config.StartCalendarInterval = [{ Minute = 0; Hour = 13; }];
    config.StandardOutPath = "/tmp/auto-run-update.log";
    config.StandardErrorPath = "/tmp/auto-run-update.log";
    config.EnvironmentVariables.PATH =
      "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin";
  };

  launchd.agents.tldr-update = {
    enable = true;
    config.ProgramArguments = [
      "${pkgs.tldr}/bin/tldr"
      "--update"
    ];
    config.StartCalendarInterval = [{ Minute = 0; Hour = 14; Weekday = 6; }];
    config.StandardOutPath = "/tmp/auto-run-update.log";
    config.StandardErrorPath = "/tmp/auto-run-update.log";
    config.EnvironmentVariables.NIX_SSL_CERT_FILE =
      "/etc/ssl/certs/ca-certificates.crt";
  };

  launchd.agents.opam-update = {
    enable = true;
    config.ProgramArguments = [
      "${pkgs.unstable.opam}/bin/opam"
      "update"
    ];
    config.StartCalendarInterval = [{ Minute = 0; Hour = 14; Weekday = 0; }];
    config.StandardOutPath = "/tmp/auto-run-update.log";
    config.StandardErrorPath = "/tmp/auto-run-update.log";
    config.EnvironmentVariables.PATH =
      "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
