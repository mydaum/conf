{
  allowUnfree = true;

  firefox.enableAdobeFlash = true;

  packageOverrides = pkgs_: with pkgs_; {
    all = with pkgs; buildEnv {
      name = "all";
      paths = [
        autoconf
        automake
        evince
        firefoxWrapper
        gcc
        git
        gnupg
        haskellPackages.cabal-install
        haskellPackages.ghc
        haskellPackages.stack
        irssi
        liberation_ttf
        libreoffice
        mplayer
        nix-repl
        pidgin
        python27Packages.livestreamer
        python3
        python34Packages.nose
        steam
        thunderbird
        unzip
        vim
        vlc
        zsh
      ];
    };
  };
}
